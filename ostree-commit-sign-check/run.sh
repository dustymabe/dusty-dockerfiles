#!/bin/bash

set -eu -o pipefail

VERSION=$1
REPO="./ostreerepo"
REMOTE="remote-${VERSION}"
REF="fedora/${VERSION}/x86_64/atomic-host"
URL="https://kojipkgs.fedoraproject.org/atomic/${VERSION}/"

if [ ! -d $REPO ]; then
    mkdir $REPO
fi

if [ ! -f $REPO/config ]; then
    ostree --repo=$REPO init --mode=archive-z2
    ostree --repo=$REPO remote add --no-gpg-verify $REMOTE $URL
fi

echo '<html>'
date
echo '<br>'

# Grab metadata
ostree --repo=$REPO pull --commit-metadata-only --depth=-1 "${REMOTE}:${REF}"
echo '<br>'

printhtmllink() {
    echo -n "<a href='${1}'>${2}</a>"
}

# Roll through the commits and verify each one is signed
n=''
while out=$(ostree --repo=$REPO show "${REF}${n}"); do
        commit=$(echo "$out" | head -n 1 | cut -d ' ' -f 2)
    n+='^'
    commiturl="${URL}/objects/${commit::2}/${commit:2:${#commit}}.commitmeta"

    echo -n "checking "
    printhtmllink $commiturl ${commit::7}

    if ! curl --output /dev/null --silent --head --fail "$commiturl"; then
        echo -n "... BAD: URL does not exist: "
        printhtmllink $commiturl $commiturl
        echo "<br>"
    else
        echo "... GOOD!<br>"
    fi
    echo
done

echo '</html>'



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

# Grab metadata
ostree --repo=$REPO pull --commit-metadata-only --depth=1 "${REMOTE}:${REF}"

echo '<html>'

# Roll through the commits and verify each one is signed
n=''
while out=$(ostree --repo=$REPO show "${REF}${n}"); do
        commit=$(echo "$out" | head -n 1 | cut -d ' ' -f 2)
    n+='^'
    commiturl="${URL}/objects/${commit::2}/${commit:2:${#commit}}.commitmeta"

    printhtml ${commit::7} $commiturl

    if ! curl --output /dev/null --silent --head --fail "$commiturl"; then
        echo "... BAD: URL does not exist: $commiturl<br>"
    else
        echo "... GOOD!<br>"
    fi
    echo
done

echo '</html>'


printhtml {
    echo -n "checking <a href='${1}'>${2}</a>"
}

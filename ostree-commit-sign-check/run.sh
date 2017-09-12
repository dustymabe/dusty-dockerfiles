#!/bin/bash

set -eu -o pipefail

VERSION=$1
REPO="./ostreerepo"
REMOTE="remote-${VERSION}"
# Can define REF or URL as positional args if you like, if not defined
# will attempt to derive from $VERSION variable
REF="${2-fedora/${VERSION}/x86_64/atomic-host}"
URL="${3-https://kojipkgs.fedoraproject.org/atomic/${VERSION}/}"

if [ ! -d $REPO ]; then
    mkdir $REPO
fi

# Create repo if it doesn't exist
if [ ! -f $REPO/config ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

# Add remote if it doesn't exist
ostree --repo=$REPO remote add --if-not-exists --no-gpg-verify $REMOTE $URL

echo '<html>'
date
echo '<br>' 
echo "<b>Testing $VERSION $REF at $URL</b>" 
echo '<br>' 
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



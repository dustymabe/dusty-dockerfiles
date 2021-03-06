#!/bin/bash

set -eu -o pipefail

VERSION=$1
REPO="./ostreerepo"
REF="$2"
#Can define URL as position arg if you like. If not will use default
URL="${3-https://dl.fedoraproject.org/atomic/repo/}"
REMOTE="remote-${REF//\//-}"

if [ ! -d $REPO ]; then
    mkdir $REPO
fi

# Create repo if it doesn't exist
if [ ! -f $REPO/config ]; then
    ostree --repo=$REPO init --mode=archive-z2
fi

# Add remote if it doesn't exist
ostree --repo=$REPO remote add --if-not-exists --no-gpg-verify $REMOTE $URL

echo '<html><br><font face="Courier New">'
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

    version=$(ostree --repo=$REPO show $commit --print-metadata-key=version)
    date=$(ostree --repo=$REPO show $commit | grep Date | cut -d " " -f 3)

    echo -n "checking ${date} ${version} " 
    printhtmllink $commiturl ${commit::7}

    if ! curl --output /dev/null --silent --head --fail "$commiturl"; then
        echo "... BAD: Please run: robosignatory-signatomic $REF $commit<br>"
    else
        echo "... GOOD!<br>"
    fi
    echo
done

echo '<br><br><br>'
echo '</font></html>'



#!/bin/bash -e

mkdir -p publish-docs

TAGS=${1:-obs rdo ubuntu debian debconf}
INDEX=doc/install-guide/source/index.rst

LINKCHECK=""
if [[ $# > 0 ]] ; then
    if [ "$1" = "--linkcheck" ] ; then
        LINKCHECK="$1"
    fi
fi

# For translation work, we should have only one index file,
# because our tools generate translation resources from
# only one index file.
# Therefore, this tool uses one combined index file
# while processing title for each distribution.

# Save and restore the index file
cp -f ${INDEX} ${INDEX}.save
trap "mv -f ${INDEX}.save ${INDEX}" EXIT

# Set this to a sensible value if not set by OpenStack CI.
if [ -z "$ZUUL_REFNAME" ] ; then
    ZUUL_REFNAME="master"
fi

# This marker is needed for infra publishing.
# Note for stable branches, this needs to be the top of each manual.
MARKER_TEXT="Project: $ZUUL_PROJECT Ref: $ZUUL_REFNAME Build: $ZUUL_UUID Revision: $ZUUL_NEWREV"

for tag in $TAGS; do
    TARGET="draft/install-guide-${tag}"
    if [[ "$tag" == "debconf" ]]; then
        # Build the guide with debconf
        # To use debian only contents, use "debian" tag.
        tools/build-rst.sh doc/install-guide-debconf  \
            --tag debian --target "$TARGET" $LINKCHECK --pdf
    else
        ##
        # Because Sphinx uses the first heading as title regardless of
        # only directive, replace title directive with the proper title
        # for each distribution to set the title explicitly.

        title=$(grep -A 5 "^.. only:: ${tag}" ${INDEX} | \
                  head -n 6 | sed -n 4p | sed -e 's/^ *//g')
        sed -i -e "s/\.\. title::.*/.. title:: ${title}/" ${INDEX}

        # Build the guide
        tools/build-rst.sh doc/install-guide \
            --tag ${tag} --target "$TARGET" $LINKCHECK --pdf
    fi
    # Add this for stable branches
    if [ "$ZUUL_REFNAME" != "master" ] ; then
        echo $MARKER_TEXT > publish-docs/$TARGET/.root-marker
    fi
done

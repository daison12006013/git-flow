#!/bin/bash

#=====================================================
# This command is useful to sync previous Sprint
# to the new Sprint + develop branch.
#=====================================================

devBranch="develop"
origin="origin"

function dirty() {
    if [ $(git diff --name-only) ]; then
        echo "
        YOU HAVE UNCOMMITTED FILES, PLEASE CHECK!
        "
        exit 1
    fi

    if [ -z "$(git ls-remote $origin release/$1)" ]; then
        echo "
        Branch release/$1 does not exist in $origin!
        "
        exit 1
    fi

    if [ -z "$(git ls-remote $origin release/$2)" ]; then
        echo "
        Branch release/$2 does not exist in $origin!
        "
        exit 1
    fi
}

function print() {
    if [ -z $1 ]; then
        echo "Provide the [OLD] sprint name"
        exit 1
    fi

    if [ -z $2 ]; then
        echo "Provide the [NEW] sprint name"
        exit 1
    fi

    echo "
git fetch
git checkout $devBranch
git pull $origin $devBranch --no-edit
git pull $origin release/$1 --no-edit
git push $origin $devBranch
git checkout release/$2
git pull $origin release/$2 --no-edit
git pull $origin $devBranch --no-edit
git push $origin release/$2
"
}

dirty "$1" "$2"
print "$1" "$2"

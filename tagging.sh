#!/bin/bash

#=======================================================================
# This command is used to help us generate the
# console command to deploy release or hotfix
#
# Sources:
#      https://danielkummer.github.io/git-flow-cheatsheet/index.html
#      https://gist.github.com/JamesMGreene/cdd0ac49f90c987e45ac
#
# Example of this command:
#   bash ../gittools/tagging.sh release jane v3.146.0
#   bash ../gittools/tagging.sh hotfix "" v3.146.1
#=======================================================================

mainBranch="master"
devBranch="develop"
origin="origin"

function dirty() {
    if [ $(git diff --name-only) ]; then
        echo "
        YOU HAVE UNCOMMITTED FILES, PLEASE CHECK!
        "
        exit 1
    fi
}

function print() {

    if [ "$1" != "release" ] && [ "$1" != "hotfix" ]; then
        echo "First argument must be release or hotfix!"
        exit 1
    fi

    if [ -z $3 ]; then
        echo "Provide the second param as the TAG version"
        exit 1
    fi

    if [ "$1" = "release" ]; then
    echo "
git fetch
git checkout release/$2
git branch $mainBranch -D
git branch $devBranch -D

git fetch
git checkout $mainBranch
git checkout $devBranch
git pull $origin $devBranch --no-edit
git pull $origin $1/$2 --no-edit
git push $origin $devBranch

git branch | grep $1\* | xargs git branch -D
git tag -l | xargs git tag -d
git fetch --tags

git flow $1 start $3
git flow $1 publish $3
"
    fi

    if [ "$1" = "hotfix" ]; then
    echo "
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Make sure you've created a branch hotfix/$3
git checkout develop
git branch master -D
git fetch
git checkout master
git branch hotfix/$3
git checkout hotfix/$3
git push origin hotfix/$3
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

git fetch
git branch $mainBranch -D
git branch $devBranch -D
git branch $1/$3 -D

git fetch
git checkout $mainBranch
git checkout $devBranch
git checkout $1/$3

git tag -l | xargs git tag -d
git fetch --tags
"
    fi

    echo "
git checkout $mainBranch
git merge --no-ff --no-edit $1/$3
git tag -a $3 -m "$3"
git checkout $devBranch
git merge --no-ff --no-edit $3
git push origin $devBranch
git push origin $mainBranch
git push origin --tags
git branch -d $1/$3
"

    if [ "$1" = "release" ]; then
    echo "
git push origin -d $1/$3
"
    fi
}

dirty
print "$1" "$2" "$3"

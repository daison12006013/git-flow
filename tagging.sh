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
#   bash ../gittools/tagging.sh --tag-type=release --tag-version=v3.146.0 --tag-name=jane
#   bash ../gittools/tagging.sh --tag-type=hotfix  --tag-version=v3.146.0
#=======================================================================

usage="$(basename "$0") [-h] [-e] [-f] [--help] [--origin <origin>] [--main-branch <branch>] [--develop-branch <branch>] [--tag-type <type>] [--tag-name <name>] [--tag-version <version>] -- script to help generate the console command to deploy release or hotfix

where:
    --origin <origin>           Specify the origin (default: origin)
    --main-branch <branch>      Specify the main branch (default: master)
    --develop-branch <branch>   Specify the develop branch (default: develop)
    --tag-type <type>           Specify the tag type (default: release)
    --tag-name <name>           Specify the tag name (default: \"\")
    --tag-version <version>     Specify the tag version (default: \"\")
    -e, --execute               Execute the generated console command
    -h, --help                  Show this help text"

MAIN_BRANCH="master";
DEVELOP_BRANCH="develop";
ORIGIN="origin";
EXECUTE=0;
TAG_TYPE="release"; # or hotfix
TAG_NAME=""; # release name
TAG_VERSION=""; # release version

# parse the options
while getopts "eh-:" OPT ; do
    case ${OPT} in
        -)
            case ${OPTARG} in
                main-branch=*) MAIN_BRANCH=${OPTARG#*=} ;;
                develop-branch=*) DEVELOP_BRANCH=${OPTARG#*=} ;;
                tag-type=*) TAG_TYPE=${OPTARG#*=} ;;
                tag-name=*) TAG_NAME=${OPTARG#*=} ;;
                tag-version=*) TAG_VERSION=${OPTARG#*=} ;;
                execute) EXECUTE=1 ;;
                origin=*) ORIGIN=${OPTARG#*=} ;;
                help) echo "${usage}"; exit 0 ;;
                *) echo "${usage}"; exit 1 ;;
            esac
            ;;
        e) EXECUTE=1 ;;
        h) echo "${usage}"; exit 0 ;;
        *) echo "${usage}"; exit 1 ;;
    esac
done

# Append subsequent options from external
shift $((OPTIND-1))
EXTERNAL_OPTIONS="$@"

function dirty() {
    if [ $(git diff --name-only) ]; then
        echo "
        YOU HAVE UNCOMMITTED FILES, PLEASE CHECK!
        "
        exit 1
    fi
}

function print() {

    # Check if the tag type is not release or hotfix
    if [ "$1" != "release" ] && [ "$1" != "hotfix" ]; then
        echo "Provide a valid --tag-type= (release or hotfix)"
        exit 1
    fi

    # Check if the tag type is release and the tag name is empty
    if [ "$1" == "release" ] && [ "$2" == "" ]; then
        echo "Provide a valid --tag-name= (e.g. jane)"
        exit 1
    fi

    if [ -z $3 ]; then
        echo "Provide the --tag-version= (e.g. v3.146.0)"
        exit 1
    fi

    local FINAL_SCRIPT=""

    if [ "$1" = "release" ]; then
    FINAL_SCRIPT+="
echo \"Cleaning up local branches...\" && \\
git fetch && \\
git checkout $1/$2 && \\
git branch $MAIN_BRANCH -D && \\
git branch $DEVELOP_BRANCH -D && \\
echo \"Cleaning up local branches... done\"

echo \"Updating [$DEVELOP_BRANCH] branch and push to [$ORIGIN]...\" && \\
git fetch && \\
git checkout $MAIN_BRANCH && \\
git checkout $DEVELOP_BRANCH && \\
git pull $ORIGIN $DEVELOP_BRANCH --no-edit && \\
git pull $ORIGIN $1/$2 --no-edit && \\
git push $ORIGIN $DEVELOP_BRANCH && \\
echo \"Updating [$DEVELOP_BRANCH] branch and push to [$ORIGIN]... done\"

echo \"Cleaning up local tags\" && \\
git branch | grep $1\* | xargs git branch -D && \\
git tag -l | xargs git tag -d && \\
git fetch --tags && \\
echo \"Cleaning up local tags... done\"

"
    fi

    if [ "$1" = "hotfix" ]; then
    FINAL_SCRIPT+="
echo \"Cleaning up local branches...\" && \\
git fetch && \\
git checkout $1/$3 && \\
git branch $MAIN_BRANCH -D && \\
git branch $DEVELOP_BRANCH -D && \\
git branch $1/$3 -D && \\
echo \"Cleaning up local branches... done\"

git fetch && \\
git checkout $MAIN_BRANCH && \\
git checkout $DEVELOP_BRANCH && \\
git checkout $1/$3 && \\

echo \"Cleaning up local tags\" && \\
git branch | grep $1\* | xargs git branch -D && \\
git tag -l | xargs git tag -d && \\
git fetch --tags && \\
echo \"Cleaning up local tags... done\"

"
    fi

    FINAL_SCRIPT+="echo \"Creating tag\" && \\
git checkout $MAIN_BRANCH && \\
git merge --no-ff --no-edit --no-verify $1/$3 && \\
git tag -a $3 -m "$3" && \\
git checkout $DEVELOP_BRANCH && \\
git merge --no-ff --no-edit --no-verify $3 && \\
git push $ORIGIN $DEVELOP_BRANCH && \\
git push $ORIGIN $MAIN_BRANCH && \\
git push $ORIGIN --tags && \\
echo \"Creating tag... done\"

"

    if [ "$1" = "release" ]; then
        FINAL_SCRIPT+="git branch -d $1/$3 && \\
git push $ORIGIN -d $1/$3
"
    fi

    echo "$FINAL_SCRIPT"
}

dirty
result=$(print "$TAG_TYPE" "$TAG_NAME" "$TAG_VERSION")

if [ $EXECUTE -eq 1 ]; then
    echo "Executing the generated console command..."
    eval "$result"
else
    echo "Generated console command:"
    echo "$result
"

fi

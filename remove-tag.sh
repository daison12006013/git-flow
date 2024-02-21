#!/bin/bash

# To run this bash command, open a terminal and navigate to the directory where the script is located.
# Then, execute the script by typing the following command:
# ./remove-tag.sh v3.181.1

# Replace <tag-name> with the name of the tag you want to remove.
# This script will delete the specified tag locally and also remove it from the remote repository.

# Local tag example:
git tag -d $@

# Remote tag example:
git push -d origin $@

# Git Flow

This tool will help you follow the git flow.

## Table of Contents
- [Flow for Release and Hotfix](#flow-for-release-and-hotfix)
- [IN PROGRESS - Flow for creating branches for (feature, release and hotfix)](#in-progress---flow-for-creating-branches-for-feature-release-and-hotfix)
- [Syncing Branches](#syncing-branches)
- [Tag Removal](#tag-removal)

## Flow for Release and Hotfix

Below will print out the flow for `release/v1.0.0` to be `tags/v1.0.0`

```sh
$> ./flow.sh --tag-type=release --tag-version=v1.0.0
```

Below will print out the flow for `hotfix/v1.0.1` to be `tags/v1.0.1`. Please do note that `--tag-version=` will be used as if `--tag-name=` is not present.

```sh
$> ./flow.sh --tag-type=hotfix --tag-version=v1.0.1
```

### Sprint Naming

There are companies that names their sprint based on characters, such as Pokemon/Disney characters, instead of `release/v1.0.0` or `hotfix/v1.0.0` you can rename it to be `release/eevee` or `hotfix/eevee-2`

```sh
$> ./flow.sh  --tag-type=release --tag-version=v1.0.0 --tag-name=eevee
$> ./flow.sh  --tag-type=hotfix  --tag-version=v1.0.1 --tag-name=eevee-2
```

### Note:

- To execute the command, you can pass `--execute`
- To have a diff url, you can pass `--git-url=https://bitbucket.org/meta/react`

## IN PROGRESS - Flow for creating branches for (feature, release and hotfix)

```sh
$> ./flow.sh --tag-type=feature --tag-name=ISSUE-101  --create
$> ./flow.sh --tag-type=release --tag-name=sprint-2   --create --tag-version=v1.1.0
$> ./flow.sh --tag-type=hotfix                        --create --tag-version=v1.1.1
```

## Syncing Branches

This will print-out how to sync your `old sprint branch` to your `develop branch` and `new sprint branch`.

```sh
$> ./sync-branch.sh old-sprint new-sprint
```

## Tag Removal

This command will help you to clean up your tags, if ever you've accidentally tagged a wrong branch.

```sh
$> ./remove-tag.sh v1.0.0
$> ./remove-tag.sh v1.0.0 v1.1.0
```

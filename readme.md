# Git Flow

This tool will help you to manage how to tag your project.

## Tagging Release / Hotfix

This command will print-out the lists of git commands you needed to release or hotfix.

```bash
$> ./tagging.sh release v1.0.0
```

```bash
$> ./tagging.sh hotfix "" v1.0.1
```

## Syncing Branches

This will print-out how to sync your `old sprint branch` to your `develop branch` and `new sprint branch`.

```bash
$> ./sync-branch.sh old-sprint new-sprint
```

## Tag Removal

This command will help you to clean up your tags, if ever you've accidentally tagged a wrong branch.

```bash
$> ./remove-tag.sh v1.0.0
$> ./remove-tag.sh v1.0.0 v1.1.0
```

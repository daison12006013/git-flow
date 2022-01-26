# GitFlow

## Tagging Release / Hotfix

This command will print-out the lists of git commands you needed to release or hotfix.

```bash
$> ./tagging.sh release v1.0.0

git fetch
git branch master -D
git branch develop -D
git fetch
git checkout master
git checkout develop
git branch | grep release\* | xargs git branch -D
git tag -l | xargs git tag -d
git fetch --tags
git flow release start v1.0.0
git flow release publish v1.0.0
git checkout master
git merge --no-ff --no-edit release/v1.0.0
git tag -a v1.0.0 -m v1.0.0
git checkout develop
git merge --no-ff --no-edit v1.0.0
git push origin --tags
git push origin develop
git push origin master
git branch -d release/v1.0.0
```

```bash
$> ./tagging.sh hotfix v1.0.1

git fetch
git branch master -D
git branch develop -D
git fetch
git checkout master
git checkout develop
git branch | grep hotfix\* | xargs git branch -D
git tag -l | xargs git tag -d
git fetch --tags
git flow hotfix finish v1.0.1
git push origin --tags
git checkout master
git merge --no-ff --no-edit hotfix/v1.0.1
git tag -a v1.0.1 -m v1.0.1
git checkout develop
git merge --no-ff --no-edit v1.0.1
git push origin --tags
git push origin develop
git push origin master
git branch -d hotfix/v1.0.1
```

## Syncing Branches

This will print-out how to sync your `old sprint branch` to your `develop branch` and `new sprint branch`.

```bash
$> ./sync-branch.sh old-sprint new-sprint

git fetch
git checkout develop
git pull origin develop --no-edit
git pull origin release/old-sprint --no-edit
git push origin develop
git checkout release/new-sprint
git pull origin release/new-sprint --no-edit
git pull origin develop --no-edit
git push origin release/new-sprint
```

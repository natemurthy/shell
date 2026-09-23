#!/usr/bin/env bash

# a collection of Git shell commands for doing some tricky things at times
set -euo pipefail

#
# Alternative to `git pull --rebase` when rebasting PR stacks.
# This is helpfule for preserving commit history as each PR in the stack is continually rebased.
#

BRANCH=$(git rev-parse --abbrev-ref HEAD)
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')   # origin/<branch>
REMOTE=$(git config "branch.$BRANCH.remote")                                # origin

git diff --quiet && git diff --cached --quiet || { echo "commit or stash first" >&2; exit 1; }

git fetch "$REMOTE"

UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')
FORK=$(git merge-base --fork-point "$UPSTREAM" HEAD) \
  || { echo "no fork-point in reflog for $UPSTREAM; pass the old tip manually" >&2; exit 1; }

echo "replaying onto $UPSTREAM:"
git log --oneline "$FORK..HEAD"

git rebase --onto "$UPSTREAM" "$FORK"
git push "$REMOTE" "$BRANCH"

#!/bin/zsh

candidate_branches_to_delete=()

propose_git_branch_cleanup() {
  local_branches=($(git for-each-ref --format='%(refname:short)' refs/heads/))

  for local_branch in "${local_branches[@]}"; do
    if [[ $(git for-each-ref --format='%(refname:short)' refs/remotes/origin/) == *"$local_branch"* ]]; then
      echo "Keeping $local_branch"
    else
      candidate_branches_to_delete+=("$local_branch")
    fi
  done

  echo ""
  echo "Proposing to delete branches:"
  for b in "${candidate_branches_to_delete[@]}"; do
    echo $b
  done
}

confirmed_git_branch_cleanup() {
  for b in "${candidate_branches_to_delete[@]}"; do
    git branch -D $b
  done
}

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

# Check if the current branch is 'main'
if [[ "$current_branch" == "main" ]]; then
  propose_git_branch_cleanup
else
  echo "Current branch is: $current_branch"
  echo "Must be on main branch to clean up local branches"
  exit 1
fi

read -r "REPLY?Do you want to proceed with deleting these local branches? [Y/n] "

echo ""
if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
  confirmed_git_branch_cleanup
else
  echo "Aborting"
  exit 0
fi

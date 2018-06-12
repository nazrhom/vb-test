# bin/#!/usr/bin/env bash

set -eu

# File separator set to \n.
# N.B. This will be valid for the whole script
# IFS=$'\n'

# Show all commits on the current branch that are not on master
for commit in `git cherry master`
do
  # The first character will indicate if the commit is added or removed
  # wrt master. In case of a valid PR we should only encounter +
  if [ "$commit" == "-" ]; then
    echo "Error"
    exit 1
  fi
  if [ "$commit" == "+" ]; then
    continue
  fi
  # Show message and author with formatting
  t=`git show $commit -s --format=%B`
  echo $t
done

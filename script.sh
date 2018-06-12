# bin/#!/usr/bin/env bash

set -eu

# File separator set to \n.
# N.B. This will be valid for the whole script
IFS=$'\n'

regex='([[:print:]]*)*change-type:[[:space:]]*(minor|major|patch)($|[[:print:]]*)'
echo $regex
function getIncrement() {
  echo $1
  if [[ $1 =~ $regex ]]
  then
    echo "${BASH_REMATCH[2]}"
  else
    echo "No match"
  fi
}

# Show all commits on the current branch that are not on master
for commit in `git cherry master`
do
  # The first character will indicate if the commit is added or removed
  # wrt master. In case of a valid PR we should only encounter +
  operation=${commit:0:1}
  if [ $operation != "+" ]; then
    echo "Error"
    exit 1
  fi
  # The rest of the string is the SHA of the commit
  SHA=${commit:2}
  # Show message and author with formatting
  t=`git show $SHA -s --format=%B`

  # Check for incement, will set FINAL_INCREMENT if it finds a footer
  # tag with value greater than the current FINAL_INCREMENT. It will
  # error if not tag is found
  getIncrement `echo $t | tr [:upper:] [:lower:]`
done
















#  Alternative (NO IFS)
# if [ "$commit" == "-" ]; then
#   echo "Error"
#   exit 1
# fi
# if [ "$commit" == "+" ]; then
#   continue
# fi

#!/bin/sh
set -eux

cd supervisor-repo

# File separator set to \n.
# N.B. This will be valid for the whole script
IFS=$'\n'

regex='([[:print:]]*)*change-type:[[:space:]]*(minor|major|patch)($|[[:print:]]*)'
FINAL_INCREMENT='patch'

function mbUpdateIncrement() {
  if [[ $FINAL_INCREMENT == "minor" && $1 == 'major' ]]
  then
  FINAL_INCREMENT=$1
elif [[ $FINAL_INCREMENT == "patch" ]]
  then
  FINAL_INCREMENT=$1
  fi
}

function getIncrement() {
  if [[ $1 =~ $regex ]]
  then
    mbUpdateIncrement "${BASH_REMATCH[2]}"
  else
    echo "Error: No match"
    exit 1
  fi
}
echo `git branch`
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
  # Show commit body
  body=`git show $SHA -s --format=%B`

  # Check for incement, will set FINAL_INCREMENT if it finds a footer
  # tag with value greater than the current FINAL_INCREMENT. It will
  # error if not tag is found
  getIncrement `echo $body | tr [:upper:] [:lower:]`
done
echo $FINAL_INCREMENT
















#  Alternative (NO IFS)
# if [ "$commit" == "-" ]; then
#   echo "Error"
#   exit 1
# fi
# if [ "$commit" == "+" ]; then
#   continue
# fi

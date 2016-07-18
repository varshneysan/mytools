#!/usr/bin/env sh 

# This tool take the list of branches to merge to release branch 
# Argument: ./MergeBranch.sh <file having fix branches name> <target branch>
# Example : ./MergeBranch.sh fix_list release-7-jun-2016-1
# Value of BASE_PATH will change based on your repo path.

BASE_PATH="/Users/sandeep/gitrepo/Internal/webapp"
BrachFile=$1
TargetBranch=$2
Cdir=`pwd`

function log(){
    echo "================================================="
    echo "--- INFO: $@"
    echo "================================================="
}

function log_warning(){
    echo "================================================="
    echo "=== WARN: $@"
    echo "================================================="

}

function log_error(){
    echo "================================================="
    echo "### ERROR: $@"
    echo "================================================="
    exit 127
}

function pull_branch() {
    log "Switching to branch $1 and Execute git pull origin $1"
    git checkout $1
    [ $? -ne 0 ] && log_error "Could not switch to branch $1"

    git pull origin $1
    [ $? -ne 0 ] && log_error "Could not pull branch - $line from origin"
   
    if [ "$1" == "master" ]; then
       git pull --all
    fi
}

function merge_branch() {
    log "Switching to branch $TargetBranch to merge $1"
    git checkout $TargetBranch
    git pull origin $1
}

if [ -z "${Cdir}/${BrachFile}" ] || [ ! -f "${Cdir}/${BrachFile}" ]; then
   log_error "Branch Info file ${Cdir}/${BrachFile} is not available" ];
else
   log "Branch Info file is $BrachFile"
fi

if [ -z "$TargetBranch" ]; then
   log_error "Target Branch to merge is missing"
else
   log "Target branch to merge : $TargetBranch"
fi

cd $BASE_PATH
pull_branch master

log "Checking out all branches and updating from origin"
while read line
do
   if [[ "$line" =~ ^# ]]; then
      log "Ignoring line $line"
   else
      log $line
      pull_branch $line
      merge_branch $line
#      echo "Should Proceed further [y/n]? "
      read -p "Should Proceed further [y/n]? " response < /dev/tty
      if [ "$response" != "y" ]; then
         echo "Exiting program."
         exit 1 
      fi
   fi
done < ${Cdir}/${BrachFile}

#while read line
#do
     
#done < ${Cdir}/${BrachFile}


log "All done. Existing now"
exit 0

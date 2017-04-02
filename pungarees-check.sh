#!/usr/bin/env bash

BRANCH=$1

git checkout ${BRANCH} > /dev/null

BRANCH_COV_STRING=$(py.test --cov | grep TOTAL | awk '{ print $NF }')
BRANCH_COV_NUM="${BRANCH_COV_STRING//%}"

git stash > /dev/null

git checkout master > /dev/null

MASTER_COV_STRING=$(py.test --cov | grep TOTAL | awk '{ print $NF }')
MASTER_COV_NUM="${MASTER_COV_STRING//%}"

echo Coverage in ${BRANCH} is ${BRANCH_COV_STRING}

if [ ${BRANCH_COV_NUM} -eq ${MASTER_COV_NUM} ]; then

    echo "Nice! Coverage in ${BRANCH} and on master is ${BRANCH_COV_STRING}"

elif [ ${BRANCH_COV_NUM} -gt ${MASTER_COV_NUM} ]; then

    echo "Awesome! Coverage in ${BRANCH} is ${BRANCH_COV_STRING}, while in master is ${MASTER_COV_STRING}"

elif [ ${BRANCH_COV_NUM} -lt ${MASTER_COV_NUM} ]; then
    echo "Oh noes! Coverage in master is ${MASTER_COV_STRING}, while in ${BRANCH} is only ${BRANCH_COV_STRING}"
    echo "Go back to those tests!"
fi
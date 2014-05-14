#!/bin/bash

minion_name=`more /etc/salt/minion | grep -v "^#" | grep -v "^$" | grep id | awk '{print $2}'`

mkdir -p /usr/local/backup
cd /usr/local/backup
git init
gitclone git@github.com:lipengyu1573/backup.git
git 














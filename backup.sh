#!/bin/bash

salt "*" cmd.run 'echo "StrictHostKeyChecking no" >> ~/.ssh/config'
salt "*" cmd.run 'yum install git'
salt "*" gem.install backup
salt "*" cmd.run 'mkdir -p /usr/local/backup;cd /usr/local/backup;rm -rf ./backup;git init;git clone git@github.com:lipengyu1573/backup.git;cd ./backup;sh backup_analyze.sh' 

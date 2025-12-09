#!/bin/bash

BACKUPDB="/home/ubuntu/backupdb"
BACKUP_FILE="/var/opt/mssql/data"  
FILE="E_FRM2_MGP"
date=$(date +"%Y-%m-%d")

find $BACKUP_FILE -type f -name "*.bak" -exec rm {} \;
find $BACKUPDB -type f -name "$FILE-$date.bak.tar.gz" -exec tar -zxvf {} -C $BACKUP_FILE \;
find $BACKUP_FILE -type f -name "*.bak" -exec chown mssql:mssql {} \;
find $BACKUPDB -type f -mtime +7 -name "*.bak.tar.gz" -exec rm {} \;

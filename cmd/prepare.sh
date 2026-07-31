#!/bin/bash

BACKUPDB="/home/ubuntu/backupdb"
BACKUP_FILE="/var/opt/mssql/data"
BACKUP_NFS="/mnt/nfs"
FILE="E_FRM2_MGP"
date=$(date +"%Y-%m-%d")
preparelog="/home/ubuntu/backupdb/cmd/prepare.log"

echo "***** date $(date '+%Y-%m-%d %H:%M:%S') *****" >> $preparelog

find $BACKUP_FILE -type f -name "*.bak" -exec rm {} \;
find $BACKUPDB -type f -name "$FILE-$date.bak.tar.gz" -exec tar -zxvf {} -C $BACKUP_FILE \;
find $BACKUP_FILE -type f -name "*.bak" -exec chown mssql:mssql {} \;

find $BACKUPDB -type f -name "$FILE-$date.bak.tar.gz" -exec cp {} $BACKUP_NFS \;
find $BACKUPDB -type f -name "*-$date.sql.tar.gz" -exec cp {} $BACKUP_NFS \;

find $BACKUPDB -type f -mtime +2 -name "*.tar.gz" -exec rm {} \;
find $BACKUP_NFS -type f -mtime +2 -name "*.tar.gz" -exec rm {} \;

echo "***** finish *****" >> $preparelog

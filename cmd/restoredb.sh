#!/bin/bash

# Set variables for connection and file paths
SERVER="dback"         # Example: localhost or IP address of your SQL Server
USER="sa"             # Example: sa
PASSWORD="regAsm13#!"     # Your password for SQL Server login
BACKUP_FILE="/var/opt/mssql/data"  # Full path to the backup file
DATABASE_NAME="E_FRM2_BACKUP" # The name of the database you want to restore
FILE="E_FRM2_MGP"
date=$(date +"%Y-%m-%d")
restoredb="/home/ubuntu/backupdb/cmd/restoredb.log"

echo "*****date $(date '+%Y-%m-%d %H:%M:%S')*****" >> "$restoredb"

/opt/mssql-tools18/bin/sqlcmd -S $SERVER -U $USER -C -P $PASSWORD -Q "ALTER DATABASE $DATABASE_NAME SET OFFLINE WITH ROLLBACK IMMEDIATE"

# Run the restore command using sqlcmd
/opt/mssql-tools18/bin/sqlcmd -S $SERVER -U $USER -C -P $PASSWORD -Q "RESTORE DATABASE [$DATABASE_NAME] FROM DISK = N'$BACKUP_FILE/$FILE-$date.bak' WITH REPLACE;" >> "$restoredb"


/opt/mssql-tools18/bin/sqlcmd -S $SERVER -U $USER -C -P $PASSWORD -Q "ALTER DATABASE $DATABASE_NAME SET ONLINE"

# Check if restore is successful
if [ $? -eq 0 ]; then
  echo "Database $DATABASE_NAME restored successfully!" >> "$restoredb"
else
  echo "Error restoring database." >> "$restoredb"
fi

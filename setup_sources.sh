#!/bin/zsh 

# Restore system databases from their backups 

readonly NAME='datawarehouse'
readonly PASSWORD='rashid@23'
readonly USER='sa'

# Make sure the datawarehouse is running 
SEARCH_NAME=$(docker ps | awk -F ' ' '{print $NF}' | grep --regex "${NAME}")

if [[ "${SEARCH_NAME}" = "${NAME}" ]]
then 
  echo "${SEARCH_NAME} is running." >&1 
  echo "Restoring backups..."
  docker exec -it "${NAME}" /opt/mssql-tools/bin/sqlcmd -U "${USER}" -P "${PASSWORD}" -i /var/opt/mssql/building-a-data-warehouse/restore_sources.sql
  
  # Check if the backups were restored
  if [[ $? -ne 0 ]]
  then
    echo 'Databases were not restored because an error occured' >&2 
    exit 1 
  fi

  # Databases were restored 
  echo 'The docker command executed successfully. Check the output to determine if the databases were successfully restored' >&1
  exit 0
fi
   

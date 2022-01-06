#!/bin/zsh 


# Upload country data from my_country.csv

readonly NAME='datawarehouse'
readonly PASSWORD='rashid@23'
readonly USER='sa'

# Make sure the datawarehouse is running
SEARCH_NAME=$(docker ps | awk -F ' ' '{print $NF}' | grep --regex "${NAME}")


if [[ "${SEARCH_NAME}" = "${NAME}" ]] 
then 
  echo "${SEARCH_NAME} is running. " >&1
  echo "Uploading country data..."
  docker exec -it "${NAME}" /opt/mssql-tools/bin/sqlcmd -U "${USER}" -P "${PASSWORD}" -i /var/opt/mssql/building-a-data-warehouse/upload_country_data.sql

  # Check if the command executed gracefully
  if [[ $? -ne 0 ]]
  then
     echo 'The country data was not uploaded because an error occured.' >&2
     exit 1
  fi

  # Command executed successfully
  echo 'The docker command executed successfully. Check the output to determine if the data was successfully uploaded' >&1
  exit 0
fi
  

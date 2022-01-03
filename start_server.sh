# This scripts spins up a new instance of sql server with docker 

# Make sure the user enters the source and target ports
if [[ "${#}" -eq 0 ]] 
then 
  echo "please enter the source and target ports" >&2 
  exit 1
fi


PASSWORD="rashid@23"
HOST_PORT="${1}"
CONTAINER_PORT="${2}"
NAME='datawarehouse'


# Stop the container if it's already running 
docker stop $NAME 

# Remove the container 
docker container rm $NAME 

# Start the container 
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$PASSWORD" --name $NAME -p $HOST_PORT:$CONTAINER_PORT -d mcr.microsoft.com/mssql/server


# Make sure the container is created successfully 
if [[ $? -ne 0 ]]
then 
  echo "unable to create the container" >&2 
  exit 1 
fi

# Copy the scripts into the container 
docker cp building-a-data-warehouse/ datawarehouse:/var/opt/mssql 

if [[ $? -ne 0 ]]
then
  echo "Unable to copy scripts to the datawarehouse" >&2
  exit 1
fi


# Run the DDS Scripts 
for dds_file in $(cat building-a-data-warehouse/Scripts/DDS/build_dds.bat)
do
  docker exec -it datawarehouse /opt/mssql-tools/bin/sqlcmd -U sa -P ${PASSWORD} -i /var/opt/mssql/building-a-data-warehouse/Scripts/DDS/$dds_file
done

if [[ $? -ne 0 ]]
then
  echo "A script failed to run." >&2
  exit 1
fi


# Run the NDS scripts 
for nds_file in $(cat building-a-data-warehouse/Scripts/NDS/build_nds.bat)
do
  docker exec -it datawarehouse /opt/mssql-tools/bin/sqlcmd -U sa -P ${PASSWORD} -i /var/opt/mssql/building-a-data-warehouse/Scripts/NDS/$nds_file
done


# Script run successfully
exit 0

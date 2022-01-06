#!/bin/zsh

# Activate the python virtual env 
source ../../../Environments/python3Env/bin/activate

# Login into postgres if all works out 
if [[ $? -eq 0 ]]
then 
  pgcli -h localhost -p 5432 -U postgres
  exit 0
fi


# Something went wrong
echo 'Something went wrong' >&2
exit 1

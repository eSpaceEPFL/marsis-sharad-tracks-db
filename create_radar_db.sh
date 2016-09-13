#!/bin/bash
# $1 -> dbname
# $2 -> admin (marsis)
# $3 -> user (marsisuser)
# $4 -> table space (optional)

dbname=$1
admin=$2
user=$3

tablespace=""

if [ ! -z "$4" ]
  then
    tablespace="-D \"$4\""
fi

createdb -U $admin -w $dbname $tablespace
createuser -U $admin $user

psql -U $admin -w -d $dbname -c "CREATE EXTENSION postgis;"
psql -U $admin -w -d $dbname -c "CREATE EXTENSION postgis_topology;"
psql -U $admin -w -d $dbname -f mars2000.sql



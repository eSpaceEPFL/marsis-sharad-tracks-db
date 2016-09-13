#!/bin/bash
# $1 -> dbname
# $2 -> admin
# $3 -> pwd
# $4 -> table prefix (use marsis or sharad)
# $.. -> file list

dbname=$1
admin=$2
pwd=$3
tpref=$4

for f in ${@: 5}
do
    ogr2ogr -a_srs mars2000.wkt -append -f PostgreSQL PG:"user=$admin password=$pwd dbname=$dbname" $f -nln $tpref_orbit_points
done


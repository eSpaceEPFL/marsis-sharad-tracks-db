#!/bin/bash
# $1 -> dbname
# $2 -> admin (radaradmin)
# $3 -> user (radaruser)
# $4 -> init_gml_file (fake_snr.gml)
# $5 -> table prefix (use marsis or sharad)

dbname=$1
admin=$2
user=$3
gml=$4
tpref=$5

# Just to create the table to grant select on
ogr2ogr -a_srs mars2000.wkt -f PostgreSQL PG:"user=$admin dbname=$dbname" $gml -nln $tpref'_orbit_points'

psql -U $admin -w -d $dbname -c "GRANT SELECT ON "$tpref"_orbit_points TO $user"
psql -U $admin -w -d $dbname -c "DELETE FROM "$tpref"_orbit_points"

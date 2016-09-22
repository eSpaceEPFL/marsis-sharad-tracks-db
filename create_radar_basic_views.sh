#!/bin/bash
# $1 -> dbname
# $2 -> admin (radaradmin)
# $3 -> user (radaruser)
# $4 -> table prefix (marsis/sharad)

dbname=$1
admin=$2
user=$3
tpref=$4
PSQL_COMMAND="psql -U $admin -w -d $dbname -c "


if [ $tpref == marsis ]
    then
        select=" ogc_fid, ST_Shift_Longitude(wkb_geometry) as wkb_geometry, orbit, point_id, scetw, scetf,  ephemt, geoep, sunlon, sundist, target, tarscx, tarscy, tarscz, scalt, tarscvx, tarscvy, tarscvz, tarscradv, tarsctanv, locsunt, sunzenith, dipx, dipy, dipz, monox, monoy, monoz, f1, f2, snr_f1_m1, snr_f1__0, snr_f1_p1, snr_f2_m1, snr_f2__0, snr_f2_p1, qi1, qi2 "
fi

if [ $tpref == sharad ]
    then
        select="  ogc_fid, ST_Shift_Longitude(wkb_geometry) as wkb_geometry, point_id, epoch, lat, lon, mars_r, sc_r, rad_v, tan_v, sza, phase, orbit "
fi

# Points view with -180 < lon < 180
$PSQL_COMMAND "CREATE MATERIALIZED VIEW "$tpref"_orbit_points_180 AS SELECT $select  FROM "$tpref"_orbit_points;"

$PSQL_COMMAND "CREATE UNIQUE INDEX "$tpref"_orbit_points_180_u_idx ON "$tpref"_orbit_points_180 (ogc_fid)"

$PSQL_COMMAND "CREATE INDEX "$tpref"_orbit_points_180_idx ON "$tpref"_orbit_points_180 using gist (wkb_geometry)"

$PSQL_COMMAND "GRANT SELECT ON "$tpref"_orbit_points_180 TO $user"

# Lines view
$PSQL_COMMAND "CREATE MATERIALIZED VIEW "$tpref"_orbit_lines AS SELECT orbit, ST_MakeLine(wkb_geometry) as wkb_geometry  FROM "$tpref"_orbit_points GROUP BY orbit"

$PSQL_COMMAND "CREATE UNIQUE INDEX "$tpref"_orbit_lines_u_idx ON "$tpref"_orbit_lines (orbit)"

$PSQL_COMMAND "CREATE INDEX "$tpref"_orbit_lines_idx ON "$tpref"_orbit_lines using gist (wkb_geometry)"

$PSQL_COMMAND "GRANT SELECT ON "$tpref"_orbit_lines TO $user"

# Lines view 180
$PSQL_COMMAND "CREATE MATERIALIZED VIEW "$tpref"_orbit_lines_180 AS SELECT orbit, ST_Shift_Longitude(ST_MakeLine(wkb_geometry)) as wkb_geometry  FROM "$tpref"_orbit_points GROUP BY orbit"

$PSQL_COMMAND "CREATE UNIQUE INDEX "$tpref"_orbit_lines_180_u_idx ON "$tpref"_orbit_lines_180 (orbit)"

$PSQL_COMMAND "CREATE INDEX "$tpref"_orbit_lines_180_idx ON "$tpref"_orbit_lines_180 using gist (wkb_geometry)"

$PSQL_COMMAND "GRANT SELECT ON "$tpref"_orbit_lines_180 TO $user"




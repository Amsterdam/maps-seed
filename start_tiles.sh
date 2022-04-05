#!/bin/sh

# Utility script for invoking individual seed jobs from the compose services
# and a fresh copy of the relevant databases

set -e
set -u

DIR="$(dirname $0)"

dc() {
	docker-compose pull
	docker-compose -p mapproxy -f ${DIR}/docker-compose.yml $*
}

trap 'dc kill ; dc rm -f' EXIT

# clean environment
dc down

# start database
dc up -d --force-recreate database
# Start mapserver
dc up -d mapserver
sleep 10

# create dirs
sudo mkdir -p /mnt/tiles
sudo chmod 755 /mnt/tiles

# import basiskaart db
dc exec -T database update-db.sh basiskaart
dc exec -T database update-db.sh bag_v11

# generate geojson
dc build
docker cp indexes.sh "$(dc ps -q database)":/tmp/indexes.sh
dc exec database psql -U basiskaart -d basiskaart -f /tmp/indexes.sh
dc run topo_$1

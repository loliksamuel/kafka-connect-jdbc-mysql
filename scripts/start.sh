#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#set -o nounset \
#    -o errexit \
#    -o verbose

verify_installed()
{
  local cmd="$1"
  if [[ $(type $cmd 2>&1) =~ "not found" ]]; then
    echo -e "\nERROR: This script requires '$cmd'. Please install '$cmd' and run again.\n"
    exit 1
  fi
}
verify_installed "jq"
verify_installed "docker-compose"

# Verify Docker memory is increased to at least 8GB
DOCKER_MEMORY=$(docker system info | grep Memory | grep -o "[0-9\.]\+")
if (( $(echo "$DOCKER_MEMORY 7.0" | awk '{print ($1 < $2)}') )); then
  echo -e "\nWARNING: Did you remember to increase the memory available to Docker to at least 8GB (default is 2GB)? Demo may otherwise not work properly.\n"
  sleep 3
fi

# Stop existing demo Docker containers
${DIR}/stop.sh


# Bring up Docker Compose
echo -e "Bringing up Docker Compose"
docker-compose up -d

# Verify Docker containers started
if [[ $(docker-compose ps) =~ "Exit 137" ]]; then
  echo -e "\nERROR: At least one Docker container did not start properly, see 'docker-compose ps'. Did you remember to increase the memory available to Docker to at least 8GB (default is 2GB)?\n"
  exit 1
fi


# Verify Docker has the latest cp-kafka-connect image
if [[ $(docker-compose logs connect) =~ "server returned information about unknown correlation ID" ]]; then
  echo -e "\nERROR: Please update the cp-kafka-connect image with 'docker-compose pull'\n"
  exit 1
fi

# Verify Kafka Connect Worker has started within 60 seconds
MAX_WAIT=180
CUR_WAIT=0
while [[ ! $(docker logs connect) =~ "Kafka Connect started" ]]; do
  sleep 20
  CUR_WAIT=$(( CUR_WAIT+3 ))
  if [[ "$CUR_WAIT" -gt "$MAX_WAIT" ]]; then
    echo -e "\nERROR: The logs in Kafka Connect container do not show 'Kafka Connect started'. Please troubleshoot with 'docker-compose ps' and 'docker-compose logs'.\n"
    exit 1
  fi
done

echo -e "\nStart streaming from   mysql (source connector) and sink connectors:"
${DIR}/connectors/submit.sh
#
#echo -e "\nStart streaming from   mysql (source connector):"
#${DIR}/connectors/submit_src_mysql_ts.sh
#
#echo -e "\nStart streaming to postgres (sink connector):"
#${DIR}/connectors/submit_sink_postgres.sh

curl  http://localhost:8083/connectors|jq
echo -e "\nDONE! Connect to Confluent Control Center at http://localhost:9021\n"

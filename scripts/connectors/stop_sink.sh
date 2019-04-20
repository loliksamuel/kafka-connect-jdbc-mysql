#!/bin/bash

docker exec connect curl -X DELETE https://connect:8083/connectors/sink-postgres
#docker exec connect curl -X DELETE https://connect:8083/connectors/src-mysql_ts
#docker exec connect curl -X DELETE https://connect:8083/connectors/src-mysql

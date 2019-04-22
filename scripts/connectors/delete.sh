#!/bin/bash

docker exec connect curl -X DELETE https://connect:8083/connectors/sink_postgres
docker exec connect curl -X DELETE https://connect:8083/connectors/src_mysql_ts
docker exec connect curl -X DELETE https://connect:8083/connectors/src_mysql_bulk
docker exec connect curl -X DELETE https://connect:8083/connectors/src_mysql_txn

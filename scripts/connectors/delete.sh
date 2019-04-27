#!/bin/bash

docker exec connect curl -X DELETE localhost:8083/connectors/sink_postgres|jq
docker exec connect curl -X DELETE localhost:8083/connectors/src_mysql_ts|jq
docker exec connect curl -X DELETE localhost:8083/connectors/src_mysql_bulk|jq
docker exec connect curl -X DELETE localhost:8083/connectors/src_mysql_txn|jq

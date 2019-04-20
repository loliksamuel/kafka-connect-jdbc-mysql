#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
    "name": "src-mysql",
    "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:mysql://mysql:3306/demo",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "mysql-08-",
                "mode":"bulk",
                "batch.max.rows":100,
                "table.whitelist" : "demo.accounts",
                "poll.interval.ms" : 360000
                }
}
EOF
)


#   CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM: "HTTPS"
#   CONNECT_REST_ADVERTISED_HOST_NAME: "connect"
#  https://connect:8083/connectors


docker exec connect curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors

#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
    "name": "sink-postgres",
    "config": {
            "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
            "connection.url": "jdbc:postgresql://postgres:5432/kafka-sink?user=connect_user&password=asgard",
            "connection.user": "connect_user",
            "connection.password": "asgard",
            "key.converter": "org.apache.kafka.connect.json.JsonConverter",
            "key.converter.schemas.enable": "false",
            "insert.mode": "upsert",
            "auto.create": true,
            "auto.evolve": true,
            "table.name.format": "accounts",
            "pk.mode": "record_value",
            "pk.fields" :"id",
            "topics": "mysql-08-accounts"
    }
}
EOF
)

docker exec connect curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8083/connectors

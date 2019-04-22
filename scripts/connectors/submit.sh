#!/bin/bash

HEADER="Content-Type: application/json"
DATA1=$( cat << EOF
{
    "name": "src_mysql_bulk",
    "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:mysql://mysql:3306/demo",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "mysql-08-",
                "mode":"bulk",
                "batch.max.rows":100,
                "table.whitelist" : "demo.accounts",
                "poll.interval.ms" : 3600000
                }
}
EOF
)

DATA2=$( cat << EOF
{
    "name": "sink_postgres",
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

DATA3=$( cat << EOF
{
    "name": "src_mysql_ts",
        "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:mysql://mysql:3306/demo",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "mysql-08-",
                "mode":"timestamp",
                "table.whitelist" : "demo.accounts",
                "timestamp.column.name": "UPDATE_TS",
                "validate.non.null": false
                }
}
EOF
)


DATA4=$( cat << EOF
{
        "name": "src_mysql_txn",
        "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:mysql://mysql:3306/demo",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "mysql-20-",
                "mode":"incrementing",
                "table.whitelist" : "demo.transactions",
                "incrementing.column.name": "txn_id",
                "validate.non.null": false
                }
        }
EOF
)


DATA5=$( cat << EOF
{
    "name": "sink_postgres_gb",
    "config": {
            "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
            "connection.url": "jdbc:postgresql://postgres:5432/kafka-sink?user=connect_user&password=asgard",
            "connection.user": "connect_user",
            "connection.password": "asgard",
            "key.converter": "io.confluent.connect.avro.AvroConverter",
            "key.converter.schema.registry.url": "http://schema-registry:8081",
            "value.converter": "io.confluent.connect.avro.AvroConverter",
            "value.converter.schema.registry.url": "http://schema-registry:8081",
            "insert.mode": "upsert",
            "auto.create": true,
            "auto.evolve": true,
            "table.name.format": "T_ACCOUNTS_GB",
            "pk.mode": "record_value",
            "pk.fields": "ROWKEY",
            "topics": "T_ACCOUNTS_GB"
    }
}
EOF
)

#   CONNECT_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM: "HTTPS"
#   CONNECT_REST_ADVERTISED_HOST_NAME: "connect"
#  https://connect:8083/connectors


docker exec connect curl -X POST -H "${HEADER}" --data "${DATA1}" http://localhost:8083/connectors
docker exec connect curl -X POST -H "${HEADER}" --data "${DATA2}" http://localhost:8083/connectors
docker exec connect curl -X POST -H "${HEADER}" --data "${DATA3}" http://localhost:8083/connectors
docker exec connect curl -X POST -H "${HEADER}" --data "${DATA4}" http://localhost:8083/connectors
#docker exec connect curl -X PUT  -H "${HEADER}" --data "${DATA5}" http://localhost:8083/connectors
#curl http://localhost:8083/connectors -X POST  -H "Content-Type: application/json" -d '
#curl http://localhost:8083/connectors



curl http://localhost:8083/connectors/src_mysql_ts/status|jq
curl http://localhost:8083/connectors/src_mysql_txn/status|jq
curl http://localhost:8083/connectors/src_mysql_bulk/status|jq
curl http://localhost:8083/connectors/sink_postgres/status|jq
curl http://localhost:8083/connectors/|jq

#!/bin/bash


echo "Sleeping 10 seconds to wait for all connectors to come up"
sleep 10
MYSQL_ROOT_PASSWORD=Admin123
docker exec -it db_mysql bash  -c "mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY '123';
exit ;
EOF
"
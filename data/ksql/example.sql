CREATE TABLE example (registertime BIGINT,  userid VARCHAR, gender VARCHAR, regionid VARCHAR)  WITH (KAFKA_TOPIC = 'mysql-08-accounts',  VALUE_FORMAT='JSON', KEY = 'userid');


#!/bin/bash
mkdir ./build
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth/master/powerauth-docs/sql/mysql/schema_boot.sql > ./build/schema.sql
curl -L https://raw.githubusercontent.com/lime-company/lime-security-powerauth-push/master/powerauth-push-docs/sql/mysql/create_push_server_schema.sql >> ./build/schema.sql

docker build -t powerauth-push-mysql ./

rm -rf ./build
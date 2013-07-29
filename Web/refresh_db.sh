#!/bin/bash

mkdir -p tmp
touch tmp/flaskr.db
sqlite3 tmp/flaskr.db < schema.sql

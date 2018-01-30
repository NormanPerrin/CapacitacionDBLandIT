#!/usr/bin/env bash

mkdir db_config
mongod --configsvr --replSet configRS --port 27500 --dbpath db_config/ --logpath logs/log.cfgsvr --logappend --fork

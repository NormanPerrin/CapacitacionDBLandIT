#!/usr/bin/env bash

mkdir db2_pri db2_sec db2_ter logs
mongod --shardsvr --replSet rs2 --port 27158 --dbpath db2_pri --logpath logs/mongodb.log --logappend --fork &
mongod --shardsvr --replSet rs2 --port 27159 --dbpath db2_sec --logpath logs/mongodb.log --logappend --fork &
mongod --shardsvr --replSet rs2 --port 27160 --dbpath db2_ter --logpath logs/mongodb.log --logappend --fork

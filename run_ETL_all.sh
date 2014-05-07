#!/bin/bash

# Author: James Attard
# Date: 09 April 2014
# Description: Wrapper script for the ETL
# Usage: Run only from Bamboo!

set -e

ETL_DIR=/root/dwh
LOG_DIR=/root/dwh/log
ETL_DATE=`date +"%Y-%m-%d" --date="1 days ago"`

echo "$ETL_DATE" > $ETL_DIR/status/etl_date.dat
touch $ETL_DIR/status/ETL.running

pushd $ETL_DIR

./run_ETL_Dim_Game.sh >> $LOG_DIR/etl_dim_game.log 2>&1
./run_ETL_Dim_Player.sh >> $LOG_DIR/etl_dim_player.log 2>&1
./run_LOAD_Dim_Game.sh >> $LOG_DIR/load_dim_game.log 2>&1
./run_LOAD_Dim_Player.sh >> $LOG_DIR/load_dim_player.log 2>&1

./run_ETL_Fact_gameActivity.sh >> $LOG_DIR/etl_fact_gameactivity.log 2>&1
./run_LOAD_Fact_gameActivity.sh >> $LOG_DIR/load_fact_gameactivity.log 2>&1

rm $ETL_DIR/status/ETL.running


set -e

SERVER="staging-datamart"
DWH_DIR="/root/dwh"
LOG_DIR="$DWH_DIR/log"
ETL_SCRIPT="$DWH_DIR/run_ETL_all.sh"
ETL_DATE=`date +"%Y-%m-%d" --date="1 days ago"`
SKIPPED_DATE=`date +"%Y-%m-%d" --date="2 days ago"`
LAST_ETL_DATE=`ssh root@"$SERVER" cat $DWH_DIR/status/etl_date.dat`

echo "*******************************************************"
echo "ETL_DATE: $ETL_DATE"
echo "LAST_ETL_DATE: $LAST_ETL_DATE"
echo "*******************************************************"

# Avoid running the ETL twice by mistake
if [ $LAST_ETL_DATE == $ETL_DATE ]; 
then 
    echo "ERROR: This ETL was already run today."
    exit 1
fi

# Avoid running the ETL if last one failed or still running
if ssh root@"$SERVER" stat "$DWH_DIR"/status/ETL.running \> /dev/null 2\>\&1
then
    echo "ERROR: Last ETL failed or still running."
    exit 1
fi

# Avoid running the ETL if previous day was completely skipped
if [ $(date -d $SKIPPED_DATE +"%y%m%d") -gt $(date -d $LAST_ETL_DATE +"%y%m%d") ]
then 
    echo "ERROR: Last ETL was skipped or not successful."
    exit 1
fi

# Run the ETL!!!
ssh root@"$SERVER" "$ETL_SCRIPT"

# Echo logs extract
ssh root@"$SERVER" grep -R $ETL_DATE $LOG_DIR

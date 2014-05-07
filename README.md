data-warehouse
==============

A collection of scripts (including ETL scripts) useful for data-warehousing

- trigger_ETL.sh
This script can be used from a CI system like Jenkins or Bamboo to trigger the ETL, capture result output and notify the Data Warehouse team accordingly.

- run_ETL_all.sh
This script is executed from the trigger_ETL.sh script above. This is a simple wrapper script to demonstrate how to execute the entire individual ETL scripts running on your data warehouse system. To use, simply replace the scripts with the ones you have. Flags are produced depending on the status of ETL output which are then read by the trigger_ETL.sh and alert the team of any problems.

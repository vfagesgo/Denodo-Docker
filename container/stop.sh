#!/bin/bash
# -----------------------------------------------------------------------------
#  STOP ALL DENODO Processed
# -----------------------------------------------------------------------------

cd /denodo/bin

#Stop the process

#wait 60s
#./arn_shutdown.sh &
#./arn_webadmin_shutdown.sh &
#./arnindex_shutdown.sh &
#./browserpool_shutdown.sh &
./datacatalog_shutdown.sh &
./diagnosticmonitoringtool_shutdown.sh &
#./itpilot_webadmin_shutdown.sh &
#./scheduler_shutdown.sh &
#./scheduler_webadmin_shutdown.sh &
#./verification_shutdown.sh &
./vqlserver_shutdown.sh &
#./webcontainer_shutdown.sh &

echo "Denodo stoped succefully"

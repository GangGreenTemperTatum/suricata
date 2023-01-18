# Suricata 'eve.json' & 'fast.log' are rapidly filling up and causing utilization/high disk capacity issues
# The below log rotation script is remediation for this

# Run this script on cron to perform cleanup via a schedule, I.E:
# 0 01,13 * * * /development/suricata_cleanup_log_script.sh /var/log/suricata/ 10 /development/logs.txt

#!/bin/bash

# $1 == Log directory for suricata
# $2 == Max number of log files to be archived
# $3 == new line separated list of logs to monitor and archive

# Statically setting the largest a log file should be 10G
MAXLOGSIZE=10737418240
RESTART=0

if [ -z $1 ]; then
  echo "Need to supply root directory of suricata logs"
  exit 1
else
  # Should add logic to verify that this variable is an actual directory
  LOGDIR=$(echo $1 | sed 's:/*$::')
fi

if [ -z $2 ]; then
  echo "Need to supply maximum number of suricata logs to archive"
  exit 1
else
  # Should add logic to verify that this is a number
  MAXNUM=$2
fi

if [ -z $3 ]; then
  echo "Need to supply file containing a new line separated list of logs to monitor"
  exit 1
else
  # Should add logic to make sure this is a file
  mapfile -t LOGS < $3
fi

for LOGFILE in "${LOGS[@]}"; do

  # First need to verify that there is only the max number of logs in the directory
  LOGCOUNT=$(ls -l $LOGDIR/ | grep -i $LOGFILE | wc -l)
  if (( $LOGCOUNT == 0 )); then
    echo "No $LOGFILE archives could be found"
    continue
  fi

  if [ $(($LOGCOUNT-$MAXNUM)) -gt 0 ]; then
    echo -n "Removing $(($LOGCOUNT-$MAXNUM)) excess $LOGFILE archives..."
    ls -t1 $LOGDIR/$LOGFILE* | tail -n +$(($MAXNUM + 1)) | xargs rm -f
    echo "[DONE]"
  else
    echo "No excess $LOGFILE archives could be found"
  fi

  if [ -f $LOGDIR/$LOGFILE ]; then
    LOGSIZE=$(stat -c %s $LOGDIR/$LOGFILE)
    if (( $LOGSIZE >= $MAXLOGSIZE )); then
      ARCHIVENAME="$LOGFILE-$(date '+%Y%m%d%H%M%S')"
      echo -n "Archiving $LOGDIR/$LOGFILE..."
      mv $LOGDIR/$LOGFILE $LOGDIR/$ARCHIVENAME
      tar -czf "$LOGDIR/$ARCHIVENAME.tar.gz" -C $LOGDIR $ARCHIVENAME
      rm -f $LOGDIR/$ARCHIVENAME
      echo "[DONE]"
      RESTART=1
    else
      PER=$((100*$LOGSIZE/$MAXLOGSIZE))
      echo "$LOGDIR/$LOGFILE does not exceed the maximum log size: $LOGSIZE/$MAXLOGSIZE ($PER%)"
    fi
  else
    echo "$LOGDIR/$LOGFILE does not exist"
  fi
done

if [ $RESTART -eq 1 ]; then
  echo -n "Restarting Suricata service... "
  systemctl restart suricata
  echo "[DONE]"
fi

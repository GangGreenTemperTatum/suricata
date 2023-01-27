# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
0 0 * * * /usr/bin/suricata-update update-source; /usr/bin/suricata-update list-sources; /usr/bin/suricata-update; systemctl restart suricata; echo "Suricata updated" | /usr/bin/logger -t CRON
#
# Old Suricata Cron:
#15 0 * * * suricata-update list-sources
#30 0 * * * suricata-update
#45 0 * * * systemctl restart suricata
#
# Development Scripts:
0 01,13 * * * /development/suricata_cleanup_log_script.sh /var/log/suricata/ 10 /development/logs.txt
# 
0 
#
0 

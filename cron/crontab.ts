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
# Suricata Native Housekeeping:
#
# Reload Suricata Data Sources to dynamically update rulesets, including custom IoC's and datasets that are added by the below scripts
# m h  dom mon dow   command
0 0 * * * /usr/bin/suricata-update update-source; /usr/bin/suricata-update list-sources; /usr/bin/suricata-update; systemctl restart suricata; echo "Suricata updated" | /usr/bin/logger -t CRON
#
# Old Suricata Cron:
#15 0 * * * suricata-update list-sources
#30 0 * * * suricata-update
#45 0 * * * systemctl restart suricata
#
# Development Scripts:
#
# Cleanup `eve.json` filesize to reduce danger of consuming too much filesystem capacity and resources
0 01,15 * * * /development/suricata_cleanup_log_script.sh /var/log/suricata/ 10 /development/logs.txt
#
# Run the Python script to pull IoC's from Threat Intelligence feeds ($ which python3)
0 01,30 * * * /usr/bin/python3 /development/rf-ip-risklists/rf_risklist_api_names_to_file.py >> /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv
#
# Run a simple script to convert the IoC's as IP addresses in Base64 and append them to the custom IoC dataset
0 01,45 * * * 
# 
# "Suricata Native Housekeeping" will proceed the following morning (~23 hours) to restart Suricata service with the newly-loaded IoC's and datasets from "Development Scripts"
# 

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
# m h  dom mon dow   command
# To reload a brand new crontab (`crontab -r`)
# 
# Suricata Native Housekeeping:
#
# Reload Suricata Data Sources to dynamically update rulesets, including custom IoC's and datasets that are added by the below scripts
0 0 * * * /usr/bin/suricata-update update-source; /usr/bin/suricata-update list-sources; /usr/bin/suricata-update; systemctl restart suricata; echo "Suricata updated" | /usr/bin/logger -t CRON
#
# Old Suricata Cron:
#15 0 * * * suricata-update list-sources
#30 0 * * * suricata-update
#45 0 * * * systemctl restart suricata
#
##### Suricata Threatbus #####
# 
# 
##### Development Scripts: #####
#
# Cleanup `eve.json` filesize to reduce danger of consuming too much filesystem capacity and resources
# Script input argument is all files listed in `logs.txt` within same directory as the script
0 01,15 * * * /development/suricata_cleanup_log_script.sh /var/log/suricata/ 10 /development/logs.txt
#
# Run the Python script to pull IoC's from Threat Intelligence feeds (`$ which python3`)
#0 23 * * * /usr/bin/python3 /development/rf-ip-risklists/rf_risklist_api_names_to_file.py >> /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv
#
# This cron entry is replacing the above line and instead of storing individual timestamped files, is storing them to a static file entry
0 23 * * * /usr/bin/python3 /development/rf-ip-risklists/rf_risklist_api_names_to_file.py 1> /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_rf_ip_risklist_ips_latest.txt 2> /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_rf_ip_risklist_ips_latest_err_log_$(date +"%Y_%m_%d_%H_%M_%S_%s").log
# 
# Run a simple script to convert the IoC's as IP addresses in Base64 and append them to the custom IoC dataset
10 23 * * * /usr/bin/bash /development/rf-ip-risklists/parsed-ip-risklists/iterate_txt_file_base64_encode.sh 2> /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_base64_encoding_err_log_$(date +"%Y_%m_%d_%H_%M_%S_%s").log
# 
# "Suricata Native Housekeeping" will proceed (~24 hours) to restart Suricata service with the newly-loaded IoC's and datasets from "Development Scripts"
# 

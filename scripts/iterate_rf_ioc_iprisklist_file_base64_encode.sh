# which bash
#!/usr/bin/bash

# This script reads a static filename's contents set by a Python script ran by a crontab rule and pipes the output to a base64 encoded form on a line-separated basis, suitable as a Suricata dataset.

for line in `cat /development/rf-ip-risklists/parsed-ip-risklists/iprisklist_rf_ip_risklist_ips_latest.txt`;
do
	echo $line | base64
done > /etc/suricata/rules/ipv4s_base64_rf_base64.lst

# Invoke using the following example:
# chmod +x <script.sh>

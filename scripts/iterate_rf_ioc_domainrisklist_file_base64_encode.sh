# which bash
#!/usr/bin/bash
# set -eou pipefail <<-- Removed as it was failing to resolve a domain and limiting results

for line in `cat /development/rf-ip-risklists/parsed-domain-risklists/domainrisklist_rf_domain_risklist_domains_latest.txt`;
do
        echo $line | base64
done > /etc/suricata/rules/domains_base64_rf_base64.lst

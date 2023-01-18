# A simple script to enumerate line-by-line of a .lst file (including many domain IoC's in Base64-encoded format), base64-decode and echo confirmation to STDOUT
# This .lst file can be used to create Suricata datasets "set" and this script is useful for testing validity of the dataset

#!/bin/bash
# set -eou pipefail <<-- Removed as it was failing to resolve a domain and limiting results

while read domain_b64; do
  domain=$(echo "$domain_b64" | base64 -d -)
  host "$domain"
done < $1

# Invoke using the following example:
# chmod +x enumerate_base64_iocs_to_text_stdout.sh
# ./enumerate_base64_iocs_to_text_stdout.sh ./test-domains-base64-encoded.lst

# Alternate single line shell statements to perform the same actions as this script are:
# $ cat ./test-domains-base64-encoded.lst | while read line; do host_name=$(echo "$line" | base64 -d -) && host "$host_name"; done

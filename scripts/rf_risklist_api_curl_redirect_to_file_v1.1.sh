#!/bin/bash

# This script performs a CURL using API key for threat intel (with a bash environment variable) and stores the data from the API call to a unique filename, structured by a prepended string, followed by date and timestamps

CURL=$(which curl)
# Test passing a dummy environment variable for testing if needed:
#RFAPITOKEN=FOO_TOKEN
CURLARGS="-v -f"
# OR 
# CURLARGS="-H "X-RFToken: $RFAPITOKEN" -f -v -o iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv""
# Enable the below statement by removing the comment and sniff the traffic for troubleshooting:
# CURLARGS="-H "X-RFToken: $RFAPITOKEN" -f -v -p 8080""
RFIPRISKLIST="https://api.recordedfuture.com/v2/ip/risklist?format=csv%2Fsplunk&gzip=false"

# To redact the credential, ensure to export the API Token env variable into `~/.bashrc` for the curl command body to function with authorization and prevent 401
# $ echo "export RFAPITOKEN=X" >> ~/.bashrc
# $ source ~/.bashrc

# EXECUTION:
# $ chmod +x ./<script>.sh

# you can store the result in a variable
# raw="$($CURL $CURLARGS $RFIPRISKLIST)"

# or you can redirect it into a file:
$CURL ${CURLARGS} -H "X-RFToken: $RFAPITOKEN" $RFIPRISKLIST -o ./unparsed_iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv

# OLD:
# $CURL $CURLARGS $RFIPRISKLIST 
# When invoking the script in this method, you do not need the curl `-o` argument 
#$CURL $CURLARGS $RFIPRISKLIST -f -v >> ./unparsed_iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv

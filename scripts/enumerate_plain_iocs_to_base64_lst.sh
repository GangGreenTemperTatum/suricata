# A simple script to enumerate line-by-line of a .txt file (including many domain IoC's in plain-text), base64-encode them, append the value to a .lst file and echo confirmation to STDOUT
# This .lst file can be used to create Suricata datasets "set"

# Alternate single line shell statements to perform the same actions as this script are:
# $ cat ./test-domains-plaintext.txt | while read domains do;  echo $domains | base64 >&2 ; echo $domains | base64 >> ./test-domains-base64-encoded.lst ; done

#!/bin/bash
# set -eou pipefail <<-- Removed as it was failing to resolve a domain and limiting results

dir=$(cat ./test-domains-plaintext.txt)
while IFS= read -r line 
do
        #echo -n $line | base64 -w 1000
        echo -n $line | base64 >> ./test-domains-base64-encoded.lst
        echo "Encoded IoC Domain with Base64: "$line" and written to an output file at $(date +"%Y-%m-%d %H:%M:%S")" >&2
done <<< "$dir"

# Testing and Invoking using the following example:

# Set bash script permissions:
# $ chmod +x ./<script-name>.sh
# $ touch ./test-domains-base64-encoded.lst

# Ensure the text file is empty:
# $ > test-domains-plaintext.txt

# Or, test by sending static defined STDIN values to the text file if not already pre-populated:
# echo example.com >> test-domains-plaintext.txt && echo example2.com >> test-domains-plaintext.txt && echo example3.com >> test-domains-plaintext.txt && echo example4.com >> test-domains-plaintext.txt && cat test-domains-plaintext.txt

# Invoke the script where `dir` is hard-coded in the script:
# $ ./<script-name>.sh
# View the resulting file contents:
# $ cat test-domains-base64-encoded.lst

# The alternate method of specifying a specific input file when invoking the script: 
# ./<script-name>.sh ~/Downloads/test-domains-plaintext.txt

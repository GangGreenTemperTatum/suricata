# A simple receieve plain-text input from user input and echo the result to STDOUT as Base64-encoded values

#! bin/bash
echo "Enter a domain to Base64-encode!"
read domain
domain_as_base64=`echo -n $domain | base64` 
echo "Encoding Domain as Base64 result equals '$domain_as_base64'" >&2

# Testing and Invoking using the following example:

# Set bash script permissions:
# $ chmod +x ./<script-name>.sh

# Run the script and enter input when prompted:
# $ ./<script-name>.sh

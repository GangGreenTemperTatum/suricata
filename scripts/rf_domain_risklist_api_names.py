#!/usr/bin/env python3

# DO:
"""
$ mkdir -p ~/.config/rf
# nano ~/.config/rf/config.cfg
"""
# THEN:
# $ vim ~/.config/rf/config.cfg
"""
[DEFAULT]
apitoken: <put token here>
"""
# INVOKING THE SCRIPT: (Local file)
# $ python3 ./rf_domain_risklist_api_names.py >> ./iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv

import csv
import argparse
import configparser
import logging
import os
import requests
from pathlib import Path

parser = argparse.ArgumentParser(
    description="This script takes csv information and reads the 'Name' header from the following API call",
)
parser.add_argument('-c','--config', action='store', dest='config_file',
                    help='Path to config file, otherwise, load from ~/.config/rf/config.cfg')
parser.add_argument('-v','--verbose', action='store_true', dest='verbose',
                    help='This boolean flag will trigger raw information to stdout')
args = parser.parse_args()
config = configparser.ConfigParser()

if args.verbose:
	logging.basicConfig(level=logging.DEBUG, format='[%(levelname)s] %(message)s')
else:
	logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

if args.config_file:
	config.read(args.config_file)
else:
	config.read("{}/.config/rf/config.cfg".format(Path.home()))

rf_url = 'https://api.recordedfuture.com/v2/domain/risklist?format=csv%2Fsplunk&gzip=false'
headers = {
	'accept': 'application/json',
	'X-RFToken': config['DEFAULT']['apitoken']
}

r = requests.request("GET", rf_url, headers=headers)
raw_data = r.content.decode('utf-8')
csv_data = csv.reader(raw_data.splitlines(), delimiter=',')

for data in csv_data:
	print(data[0])

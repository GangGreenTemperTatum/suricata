#!/usr/bin/env python3

# INSTRUCTIONS:
# $ python3 .csv_parse -h
# $ python3 csv_parse.py -f ~/Downloads/rf_ip_threatfeed_default_csv.csv >> ./parsed_iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").txt

# Cron would be something such as:
# # 0 * * * * * /usr/bin/python3 /opt/csv_parse.py /tmp/dir/

import csv
import argparse
import logging
from pathlib import Path

parser = argparse.ArgumentParser(
    description="This script takes csv information from an argument (file) and reads the 'Name' header",
)
parser.add_argument('-f','--file', action='store', required=True, dest='csv_file',
                    help='Path to csv file')
parser.add_argument('-v','--verbose', action='store_true', dest='verbose',
                    help='This boolean flag will trigger raw information to stdout')
args = parser.parse_args()

if args.verbose:
	logging.basicConfig(level=logging.DEBUG, format='[%(levelname)s] %(message)s')
else:
	logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

with open( args.csv_file, 'r' ) as data:
	reader = csv.DictReader(data)
	for line in reader:
		print(line['Name'])
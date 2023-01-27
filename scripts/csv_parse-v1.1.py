#!/usr/bin/env python3
# Cron would be something such as:
# # 0 * * * * * /usr/bin/python3 /opt/csv_parse.py /tmp/dir/
# $ python3 .csv_parse -h
# Example:
# $ python3 csv_parse.py -f ~/Downloads/rf_ip_threatfeed_default_csv.csv >> ./parsed_iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").txt
# $ $ ls -halt | grep risk
# -rw-r--r--@  1 X  Y    68K 26 Jan 11:34 parsed_iprisklist_2023_01_26_11_34_06_1674761646.txt

import csv
import argparse
import logging
from pathlib import Path
import os
import glob

parser = argparse.ArgumentParser(
    description="This script takes csv information and reads the 'Name' header",
)
parser.add_argument('-d','--directory', action='store', required=True, dest='dir',
                    help='Path to directory of csv files')
parser.add_argument('-v','--verbose', action='store_true', dest='verbose',
                    help='This boolean flag will trigger raw information to stdout')
args = parser.parse_args()

if args.verbose:
	logging.basicConfig(level=logging.DEBUG, format='[%(levelname)s] %(message)s')
else:
	logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

files = glob.glob(args.dir + "/*.csv")
csv_file = max(files, key=os.path.getctime)

with open( csv_file, 'r' ) as data:
	reader = csv.DictReader(data)
	for line in reader:
		print(line['Name'])
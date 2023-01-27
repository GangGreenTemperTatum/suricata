#!/usr/bin/env python3

# INSTRUCTIONS:
# $ python3 .csv_parse -h

# This script is improved from v1.0 and instead of taking an argument for a filename upon execution, reads the last modified file in a directory
# Cron would be something such as:
# # 0 * * * * * /usr/bin/python3 /opt/csv_parse.py /tmp/dir/
# # 0 * * * * * /usr/bin/python3 /opt/csv_parse.py /tmp/dir/ >> ./parsed_iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").txt

import csv
import argparse
import logging
import os
import glob

parser = argparse.ArgumentParser(
    description="This script takes csv information (reads the last modified file in the current directory) and reads the 'Name' header",
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
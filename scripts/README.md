# Scripting Suricata IoC Dataset Script Instructions:

The below instructions are manually ran for testing. Follow-up automation of this task on a schedule is done by [CRON](https://github.com/GangGreenTemperTatum/suricata/tree/main/cron) tasks.
>This same approach can be done for other types of acceptable [Suricata Datasets](https://suricata.readthedocs.io/en/suricata-6.0.0/rules/datasets.html) (example, "domains").. see my [config](https://github.com/GangGreenTemperTatum/suricata/tree/main/ids-af-packet-mode) files for examples.

* Add your `X-RFToken` authentication dependency to the HTTP header within a limited-access configuration file:

```
mkdir -p ~/.config/rf
nano ~/.config/rf/config.cfg
apitoken: <put token here>
```

* Run the [`rf_risklist_api_names_to_file.py`](https://github.com/GangGreenTemperTatum/suricata/blob/main/scripts/rf_risklist_api_names_to_file.py) Python script to initially grab the risklist from Recorded Future Threat Intel (in this example). The script as illustrated pulls the "`names`" column-values (excluding the header) and prints to line-separated values:

* When invoking the script, we are the piping the results to a file, rather that "STDOUT". Note, this may cause some problems with "CRON" syntax and expressions.

```
[]$ python3 ./rf_risklist_api_names_to_file.py >> ./iprisklist_$(date +"%Y_%m_%d_%H_%M_%S_%s").csv

[]$ ls -halt | grep iprisklist_2023_01_27_12_41_22_1674852082.csv

[]$ tail iprisklist_2023_01_27_12_41_22_1674852082.csv -n 2
==> iprisklist_2023_01_27_12_41_22_1674852082.csv <==
222.237.193.26
212.1.208.102
```

> Alternatively, run the [`/rf_risklist_api_curl_redirect_to_file_v1.1.sh`](https://github.com/GangGreenTemperTatum/suricata/blob/main/scripts/rf_risklist_api_curl_redirect_to_file_v1.1.sh) Shell script to perform the same API call and omit to "STDOUT"... This Shell script does not perform the same parsing techniques as the Python script and requires following up with the [`csv_parse-1.2.py`](https://github.com/GangGreenTemperTatum/suricata/blob/main/scripts/csv_parse-v1.2.py) Python script to use "`csv.DictReader`" to parse and extract a specific column's values:

```
[]$ ./rf_risklist_api_curl_redirect_to_file_v1.1.sh
[]$ tail unparsed_iprisklist_2023_01_27_13_10_04_1674853804.csv -n 1

# I am illustrating `csv_parse-1.0.py` (which compliments the above shell script) in this example for the purpose of testing as it takes an argument input (`-f`), rather than reading the last modified file in a directory:

[]$ python3 ./csv_parse-v1.0.py -h

[]]$ python3 ./csv_parse-v1.0.py -f unparsed_iprisklist_2023_01_27_13_10_04_1674853804.csv
[]$ ls -halt parsed_iprisklist_2023_01_27_13_10_04_1674853804.csv
[]$ python3 ./csv_parse-v1.0.py -f unparsed_iprisklist_2023_01_27_13_10_04_1674853804.csv >> parsed_iprisklist_2023_01_27_13_10_04_1674853804.csv

[]$ tail parsed_iprisklist_2023_01_27_13_10_04_1674853804.csv -n 2
==> parsed_iprisklist_2023_01_27_13_10_04_1674853804.csv <==
222.237.193.26
212.1.208.102
```

* Back to the original preferred approach, perform any additional [CRON](https://github.com/GangGreenTemperTatum/suricata/tree/main/cron) tasks, or scripts to encode the data into suitable format that Suricata accepts as a dataset.

Example: [`iterate_rf_ioc_iprisklist_file_base64_encode.sh`](https://github.com/GangGreenTemperTatum/suricata/blob/main/scripts/iterate_rf_ioc_iprisklist_file_base64_encode.sh)
> Again, see my other scripts and [CRON](https://github.com/GangGreenTemperTatum/suricata/tree/main/cron).

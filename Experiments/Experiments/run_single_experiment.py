#!/usr/bin/env python3
import configparser
import time
import sys
from pathlib import Path
sys.path.append('utils') # use the same utils
from experiments_map import get_experiment_number
from experiments import experiment_1, experiment_2, experiment_3, experiment_4, experiment_5, experiment_6, experiment_7, experiment_8, experiment_9, experiment_10, experiment_11, experiment_12, experiment_13, experiment_14, experiment_15, experiment_16, experiment_17

# Configure experiment number - argv[1]: use case name, argv[2]: experiment number concerning the use case
if len(sys.argv) < 3:
    print('Please provide use_case (1) and number of the experiment (2)')
    exit()

use_case = sys.argv[1]
number = sys.argv[2]
experiment_number = get_experiment_number(use_case, int(number))

# Configure Experiment
config = configparser.ConfigParser()
config.read('configs/shared_config.ini')
server = config.get('CONFIG', 'SERVER')
rulekeeper = config.getboolean('EXPERIMENTS', 'RULEKEEPER')
duration = config.get('EXPERIMENTS', 'DURATION')
threads = sys.argv[3]
number_clients = sys.argv[4]
current_time = time.strftime("%d%m%Y-%H%M")

print('Experiment ' + str(experiment_number) + ' from ' + use_case + '.')
print('RuleKeeper: ' + str(rulekeeper) + '; Duration: ' + duration + '; Threads: ' + threads + '; Clients: ' + number_clients + '.')

# We save the experiment results in a directory file with the experiment number inside a directory file for the use case
# Example: leb/1/timestamp.*
experiment_path = "results/" + use_case + "/" + str(number) + "/" + number_clients + "/"
Path(experiment_path).mkdir(parents=True, exist_ok=True)
path = experiment_path + str(rulekeeper) + '_' + current_time + '.txt'

if experiment_number == 1: experiment_1(server, threads, number_clients, duration, path)
if experiment_number == 2: experiment_2(server, threads, number_clients, duration, path)
if experiment_number == 3: experiment_3(server, threads, number_clients, duration, path)
if experiment_number == 4: experiment_4(server, threads, number_clients, duration, path)
if experiment_number == 5: experiment_5(server, threads, number_clients, duration, path)
if experiment_number == 6: experiment_6(server, threads, number_clients, duration, path)
if experiment_number == 7: experiment_7(server, threads, number_clients, duration, path)
if experiment_number == 8: experiment_8(server, threads, number_clients, duration, path)
if experiment_number == 9: experiment_9(server, threads, number_clients, duration, path)
if experiment_number == 10: experiment_10(server, threads, number_clients, duration, path)
if experiment_number == 11: experiment_11(server, threads, number_clients, duration, path)
if experiment_number == 12: experiment_12(server, threads, number_clients, duration, path)
if experiment_number == 13: experiment_13(server, threads, number_clients, duration, path)
if experiment_number == 14: experiment_14(server, threads, number_clients, duration, path)
if experiment_number == 15: experiment_15(server, threads, number_clients, duration, path)
if experiment_number == 16: experiment_16(server, threads, number_clients, duration, path)
if experiment_number == 17: experiment_17(server, threads, number_clients, duration, path)


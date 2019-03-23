#!/usr/bin/env python3
#
# This script will output info on all processes on the system.
# Not unlike ps for Linux, but will print out the data in structured
# format.
#

import argparse
import time
import sys

import psutil


#
# Parse our args
#
parser = argparse.ArgumentParser(description = "Better PS: Print highly structured ps output suitable for Splunk.")
parser.add_argument("--loops", metavar = "N", type = int, default = 360,
                    help="How many loops to run through?")
parser.add_argument("--interval", metavar = "N", type = int, default = 10,
                    help="How many seconds to pause between runs?")

args = parser.parse_args()
#print(args); sys.exit(1) # Debugging


#
# Get a list of all of our processes and their attributes.
#
def getProcesses():

	retval = {}

	for pid in psutil.pids():
		
		try:
			p = psutil.Process(pid)
			name = p.name()
			exe = p.exe()
			user = p.username()
			mem = p.memory_info()

		except psutil.AccessDenied:
			continue

		except psutil.ZombieProcess:
			continue

		except psutil.NoSuchProcess:
			continue

		except Exception as e:
			print("Caught exception: {}".format(e))
			continue

		retval[pid] = {
			"name": name,
			"exe": exe,
			"user": user,
			"rss": mem.rss,
			"vsz": mem.vms,
			"page_faults": mem.pfaults,
			"page_ins": mem.pageins,
			}

	return(retval)


#
# Print out our processes and timestamps.
#
def printProcesses(timestamp, processes):

	for pid, data in processes.items():
		print('{} pid="{}" user="{}" name="{}" exe="{}" rss="{}" vsz="{}" page_faults="{}" page_ins="{}" '.format(
			timestamp, pid, data["user"], data["name"], 
			data["exe"], data["rss"], data["vsz"], 
			data["page_faults"], data["page_ins"])
			)


loops = args.loops
while True:
	
	processes = getProcesses()
	timestamp = time.strftime("%Y-%m-%dT%H:%M:%S.000%z")

	printProcesses(timestamp, processes)

	loops -= 1

	if loops <= 0:
		break

	time.sleep(args.interval)




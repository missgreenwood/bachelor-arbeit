#!bin/bash


# Match measurement values from benchmark program with power meter 

# choose experiment suite to be matched
# HPL with 20 RPis powered -> objective = 'experiment no1'

# number of experiment suites per run: 32
# Choose min and max start time 
# Start time of first experiment suite: 1399814306
# Start time of last experiment suite: 1399815597
# Start time of first experiment suite from next run: 1399815676

# get experiment suite ids
SELECT id FROM ExperimentSuite WHERE objective = 'experiment no1' AND executionStartedAt >= 1399814306 AND executionStartedAt < 1399815676;

# selected ids: 71-86

# first idea: get all power measurements for that time span (if any)

# second idea: get only power measurements for that time span that match a hpl timestamp 


# HPL mit 19-4 RPis powered
# STREAM mit 20 RPis powered
# STREAM mit 19-4 RPis powered 
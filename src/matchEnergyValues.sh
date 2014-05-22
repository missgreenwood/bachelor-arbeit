#!/bin/bash


# Match measurement values from power meter with experiment suite id  

# number of experiment suites per run: 32

# 4 experiment setups: 

# HPL with 20 RPis powered 
## objective = 'experiment no1'
## experiment suite ids: 89-104 / (key id in table ExperimentSuite)

# HPL with 20-5 RPis powered 
## objective = 'experiment no2'
## experiment suite ids: 105-120 / (key id in table ExperimentSuite)

# STREAM with 20 RPis powered 
## objective = 'experiment no3'
## experiment suite ids: 1-16 / 44-55 (key id in table ExperimentSuite)

# STREAM with 20-5 RPis powered 
## objective = 'experiment no4'
## experiment suite ids: 17-32 / 56-71 (key id in table ExperimentSuite)
 
# for each experiment setup: 

## read in ids to match 
echo -n "Please enter first experiment suite id to match and press [ENTER]: " 
read first_expsuite
echo -n "Please enter last experiment suite id to match and press [ENTER]: "
read last_expsuite
for (( c=$first_expsuite; c<=$last_expsuite; c++ ))
do 
	# echo $c
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "SET @v1 := (SELECT executionStartedAt FROM ExperimentSuite WHERE id = $c);SET @v2 := (SELECT executionEndedAt FROM ExperimentSuite WHERE id = $c); SELECT `value` FROM MeasurementValue WHERE parameter = 'Power' AND "
done
## get start and end timestamps of selected experiment suites from table ExperimentSuite: keys executionStartedAt and executionEndedAt
## get power measurement values between selected start and end timestamps from table MeasurementValue: keys measuredAt and `parameter` = 'Power'





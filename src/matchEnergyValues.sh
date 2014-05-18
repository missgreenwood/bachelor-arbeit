#!bin/bash


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
## get power measurement values that match selected ids from table MeasurementValue



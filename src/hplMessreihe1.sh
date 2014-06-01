#!/bin/bash 

# Run HPL on 16 RPi-Nodes active, 20 RPi-Nodes powered
# Working directory: /srv/benchmarks/bin/hpl-2.1/messung3
# Input file: /srv/benchmarks/bin/hpl-2.1/messung3/HPL.dat
# Machinefile: /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest
# Executable: /srv/benchmarks/bin/hpl-2.1/messung3/xhpl

# create output file                                                                 
touch results/hpl-2.1_`date +%y%m%d`.txt 

# Set number of active RPis = 16, starttime = `date +%s`
n=16
echo "Number of active RPis: $n"
echo "Number of powered RPis: 20"
starttime=`date +%s`
echo "Start time: $starttime"

# Setup experiment suite in database (one experiment suite needed) 

ssh rpi-user@careme<<ENDSSH
# initialize experiment suite 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no1',$starttime)"
ENDSSH

# get experiment suite id
ssh rpi-user@careme<<ENDSSH
touch /tmp/myid.txt                                                                                                                                                 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT id FROM ExperimentSuite WHERE executionStartedAt=$starttime" > /tmp/myid.txt
ENDSSH

# read in experiment suite id from tmp file on careme 
myid=$(ssh rpi-user@careme "cat /tmp/myid.txt")

# remove tmp file from careme                                                                                                                                              
ssh rpi-user@careme "rm /tmp/myid.txt"

ssh rpi-user@careme<<ENDSSH
# insert number of active RPis                                                                                                                                             
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis','${n}',$myid)"

# insert number of powered RPis
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','20',$myid)"

# map load generator configuration to experiment suite                                                                                                                    
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (6,$myid)"            
ENDSSH

echo "Database setup complete"

# log number of active RPis/powered RPis to results/hpl-2.1_`date +%y%m%d`.txt
echo "Active RPis: $n/Powered RPis: 20" >> results/hpl-2.1_`date +%y%m%d`.txt

# log experiment suite id to results/hpl-2.1_`date +%y%m%d`.txt
echo "Experiment suite id: $myid" >> results/hpl-2.1_`date +%y%m%d`.txt

# start benchmark on 16 RPis, log to results/hpl-2.1_`date +%y%m%d`.txt
# mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest -wdir /srv/benchmarks/bin/hpl-2.1/messung3 /srv/benchmarks/bin/hpl-2.1/messung3/xhpl >> results/hpl-2.1_`date +%y%m%d`.txt

# get end time as unix timestamp
endtime=`date +%s`
echo "End time: $endtime"

# write end time of experiment suite to database
ssh rpi-user@careme<<ENDSSH
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "UPDATE ExperimentSuite SET executionEndedAt = $endtime WHERE id = $myid"
ENDSSH
    
echo "HPL finished on $n RPis active, 20 RPis powered" 

# Run HPL on 8 RPi-Nodes active, 20 RPi-Nodes powered
# Working directory: /srv/benchmarks/bin/hpl-2.1/messung2
# Input file: /srv/benchmarks/bin/hpl-2.1/messung2/HPL.dat
# Machinefile: /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest
# Executable: /srv/benchmarks/bin/hpl-2.1/messung2/xhpl

# Set number of active RPis = 8, starttime = `date +%s`
n=8
echo "Number of active RPis: $n"
echo "Number of powered RPis: 20"
starttime=`date +%s`
echo "Start time: $starttime"

# Setup experiment suite in database (one experiment suite needed) 

ssh rpi-user@careme<<ENDSSH
# initialize experiment suite 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no1',$starttime)"
ENDSSH

# get experiment suite id
ssh rpi-user@careme<<ENDSSH
touch /tmp/myid.txt                                                                                                                                                 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT id FROM ExperimentSuite WHERE executionStartedAt=$starttime" > /tmp/myid.txt
ENDSSH

# read in experiment suite id from tmp file on careme 
myid=$(ssh rpi-user@careme "cat /tmp/myid.txt")

# remove tmp file from careme                                                                                                                                              
ssh rpi-user@careme "rm /tmp/myid.txt"

ssh rpi-user@careme<<ENDSSH
# insert number of active RPis                                                                                                                                             
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis','${n}',$myid)"

# insert number of powered RPis
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','20',$myid)"
# map load generator configuration to experiment suite                                                                                                                    
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (6,$myid)"            
ENDSSH

echo "Database setup complete"

# log number of active RPis/powered RPis to results/hpl-2.1_`date +%y%m%d`.txt
echo "Active RPis: $n/Powered RPis: 20" >> results/hpl-2.1_`date +%y%m%d`.txt

# log experiment suite id to results/hpl-2.1_`date +%y%m%d`.txt
echo "Experiment suite id: $myid" >> results/hpl-2.1_`date +%y%m%d`.txt

# start benchmark on 8 RPis, log to results/hpl-2.1_`date +%y%m%d`.txt                        
# mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest -wdir /srv/benchmarks/bin/hpl-2.1/messung2 /srv/benchmarks/bin/hpl-2.1/messung2/xhpl >> results/hpl-2.1_`date +%y%m%d`.txt

# get end time as unix timestamp
endtime=`date +%s`
echo "End time: $endtime"

# write end time of experiment suite to database
ssh rpi-user@careme<<ENDSSH
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "UPDATE ExperimentSuite SET executionEndedAt = $endtime WHERE id = $myid"
ENDSSH
    
echo "HPL finished on $n RPis active, 20 RPis powered"

# Run HPL on 4 RPi-Nodes active, 20 RPi-Nodes powered
# Working directory: /srv/benchmarks/bin/hpl-2.1/messung1
# Input file: /srv/benchmarks/bin/hpl-2.1/messung1/HPL.dat
# Machinefile: /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest
# Executable: /srv/benchmarks/bin/hpl-2.1/messung1/xhpl

# Set number of active RPis = 4, starttime = `date +%s`
n=4
echo "Number of active RPis: $n"
echo "Number of powered RPis: 20"
starttime=`date +%s`
echo "Start time: $starttime"

# Setup experiment suite in database (one experiment suite needed) 
ssh rpi-user@careme<<ENDSSH
# initialize experiment suite 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no1',$starttime)"
ENDSSH

# get experiment suite id
ssh rpi-user@careme<<ENDSSH
touch /tmp/myid.txt                                                                                                                                                 
mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT id FROM ExperimentSuite WHERE executionStartedAt=$starttime" > /tmp/myid.txt
ENDSSH

# read in experiment suite id from tmp file on careme 
myid=$(ssh rpi-user@careme "cat /tmp/myid.txt")

# remove tmp file from careme                                                                                                                                              
ssh rpi-user@careme "rm /tmp/myid.txt"

ssh rpi-user@careme<<ENDSSH
# insert number of active RPis                                                                                                                                             
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis','${n}',$myid)"                                                                                                                                                          

# insert number of powered RPis                                                                                                                                           
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','20',$myid)"                                                                                                                                                           

# map load generator configuration to experiment suite                                                                                                                    
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (6,$myid)"            
ENDSSH

echo "Database setup complete"

# log number of active RPis/powered RPis to results/hpl-2.1_`date +%y%m%d`.txt
echo "Active RPis: $n/Powered RPis: 20" >> results/hpl-2.1_`date +%y%m%d`.txt

# log experiment suite id to results/hpl-2.1_`date +%y%m%d`.txt
echo "Experiment suite id: $myid" >> results/hpl-2.1_`date +%y%m%d`.txt

# start benchmark on 8 RPis, log to results/hpl-2.1_`date +%y%m%d`.txt 
# mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile_latest -wdir /srv/benchmarks/bin/hpl-2.1/messung1 /srv/benchmarks/bin/hpl-2.1/messung1/xhpl >> results/hpl-2.1_`date +%y%m%d`.txt

# get end time as unix timestamp
endtime=`date +%s`
echo "End time: $endtime"

# write end time of experiment suite to database                                                                                                                       
ssh rpi-user@careme<<ENDSSH
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "UPDATE ExperimentSuite SET executionEndedAt = $endtime WHERE id = $myid"                                            
ENDSSH
    
echo "HPL finished on $n RPis active, 20 RPis powered"



#!/bin/bash                                                                           

# Run STREAM on 20-1 RPi-Nodes, run again and shutdown RPi-Node n afterwards      
                                                                                      

# create output files                                                                 
touch results/STREAM_`date +%y%m%d`.txt results/STREAM_shutdown`date +%y%m%d`.txt

# loop over n RPis 
for host in pi20 pi19 pi18 pi16 pi15 pi12 pi11 pi10 pi08 pi07 pi06 pi03 pi01 
do
    n=${host/pi/}
    n=$(echo $n|sed 's/^0*//')
    echo "Number of active RPis: $n"
    echo "Number of powered RPis: 20"
    starttime=`date +%s`
    echo "Start time: $starttime"

# Setup experiment suite in database                                                                                                                                        
# One experiment suite for every program run needed

	ssh rpi-user@careme<<ENDSSH
	# initialize experiment suite                                                                                                                                               
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','judiths experiment no3',$starttime)"                                                                                                                                                              
ENDSSH

# get experiment suite id                                                                                                                                                   
	ssh rpi-user@careme<<ENDSSH                                                                                                                                                	                                                                                                                                                                            
	touch /tmp/myid.txt                                                                                                                                                                                                                                                                                                                                 
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT id FROM ExperimentSuite WHERE executionStartedAt=$starttime" > /tmp/myid.txt                                            
ENDSSH

# read in experiment suite id from tmp file on careme                                                                                                                       
	myid=$(ssh rpi-user@careme "cat /tmp/myid.txt")
# echo $myid                                                                                                                                                                

# remove tmp file from careme                                                                                                                                                                                                                                                                                                                          
	ssh rpi-user@careme "rm /tmp/myid.txt"
	ssh rpi-user@careme<<ENDSSH                                                                                                                                                
                                                                                                                                                                            
	# insert number of active RPis
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis','${n}',$myid)"                                                                                                                                                           

	# insert number of powered RPis                                 
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','14',$myid)"                                                                                                                                                            

	# map load generator configuration to experiment suite                                                                                                                     
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (7,$myid)"             
ENDSSH

	echo "Database setup complete"

# log number of active RPis/powered RPis to results/STREAM_`date +%y%m%d`.txt                                                                                                      
	echo "Active RPis: "$n"/Powered RPis: 20" >> results/STREAM_`date +%y%m%d`.txt

# start benchmark on n RPis, log to results/STREAM_`date +%y%m%d`.txt                                                                                                      
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/STREAM /srv/benchmarks/bin/STREAM/stream >> results/STREAM_`date +%y%m%d`.txt
	echo "STREAM finished on $n RPis active, 20 RPis powered"
done



# loop over n RPis 
for host in pi20 pi19 pi18 pi16 pi15 pi12 pi11 pi10 pi08 pi07 pi06 pi03 pi01 
do
    n=${host/pi/}
    n=$(echo $n|sed 's/^0*//')
    echo "Number of active RPis: $n"
    echo "Number of powered RPis: $n"
    starttime=`date +%s`
    echo "Start time: $starttime"

    # Setup experiment suite in database                                                                                                                                        
    # One experiment suite for every program run needed
	ssh rpi-user@careme<<ENDSSH
	    # initialize experiment suite                                                                                                                                               
	    mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','judiths experiment no4',$starttime)"                                                                                                                                                              
ENDSSH

# get experiment suite id                                                                                                                                                   
	ssh rpi-user@careme<<ENDSSH                                                                                                                                                	                                                                                                                                                                            
    	touch /tmp/myid.txt                                                                                                                                                                                                                                                                                                                                 
    	mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT id FROM ExperimentSuite WHERE executionStartedAt=$starttime" > /tmp/myid.txt                                            
ENDSSH

    # read in experiment suite id from tmp file on careme                                                                                                                       
    myid=$(ssh rpi-user@careme "cat /tmp/myid.txt")
    # echo $myid                                                                                                                                                                

    # remove tmp file from careme                                                                                                                                                                                                                                                                                                                          
    ssh rpi-user@careme "rm /tmp/myid.txt"
    
    ssh rpi-user@careme<<ENDSSH                                                                                                                                                	
	    # insert number of active RPis
    	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis','${n}',$myid)"                                                                                                                                                           

    	# insert number of powered RPis                                 
    	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','${n}',$myid)"                                                                                                                                                            

    	# map load generator configuration to experiment suite                                                                                                                     
    	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (7,$myid)"             
ENDSSH

	echo "Database setup complete"
# log number of active RPis/powered RPis to results/STREAM_`date +%y%m%d`.txt                                                                                                      
    echo "Active RPis: "$n"/Powered RPis: 20" >> results/STREAM_`date +%y%m%d`.txt

# start benchmark on n RPis, log to results/STREAM_`date +%y%m%d`.txt                                                                                                      
	mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/STREAM /srv/benchmarks/bin/STREAM/stream >> results/STREAM_`date +%y%m%d`.txt

# add unix timestamp to results file
	echo "Unixtime: `date +%s`" >> results/STREAM_`date +%y%m%d`.txt

	echo "STREAM finished on $n RPis active, $n RPis powered"
done

# create input file for database
touch results/STREAM_db`date +%y%m%d`.txt 


# find all lines in output file containing Copy|Scale|Add|Triad                                                                                                             
# extract all values, remove new lines, append to STREAM_db`date +%y%m%d`.txt                                                                                               
# grep -E "Copy|Scale|Add|Triad" STREAM_`date +%y%m%d`.txt | awk '{print $2,$3,$4,$5}'|tr '\n' ' ' >> STREAM_db`date +%y%m%d`.txt
# grep -E "Copy|Scale|Add|Triad" STREAM_shutdown`date +%y%m%d`.txt | awk '{print $2,$3,$4,$5}'|tr '\n' ' ' >> STREAM_db`date +%y%m%d`.txt

# write all values to database                                                                                                                                              

# ssh rpi-user@careme<<'ENDSSH'                                                                                                                                               
# for word in $(</srv/nfs-share/benchmarks/bin/STREAM_db`date +%y%m%d`.txt)                                                                                                   
# do                                                                                                                                                                          
# mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (\`value\`) VALUES (${word//[[:blank:]]})"                                            
# done                                                                                                                                                                        
# ENDSSH
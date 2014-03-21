#!/bin/bash                                                                           

# Run hplinpack on 20-4 RPi-Nodes, run again and shutdown RPi-Node n afterwards      
                                                                                     

# create output files                                                                 
touch results/hpl-2.1_`date +%y%m%d`.txt results/hpl-2.1_shutdown`date +%y%m%d`.txt

# loop over n RPis downto 4                                                           
for host in pi20 pi19 pi18 pi16 pi15 pi12 pi11 pi10 pi08 pi07 pi06 
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
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','myobjective',$starttime)"
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
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis
	','${n}',$myid)"                                                                                                                                                            
	                                                                                                                                                                            
	# insert number of powered RPis                                                                                                                                             
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPi
	s','14',$myid)"                                                                                                                                                             
	                                                                                                                                                                            
	# map load generator configuration to experiment suite                                                                                                                      
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (3,$myid)"              
ENDSSH

	echo "Database setup complete"

	# log number of active RPis/powered RPis to hpl-2.1_`date +%y%m%d`.txt
	echo "Active RPis: "$n"/Powered RPis: 20" >> hpl-2.1_`date +%y%m%d`.txt

	# start benchmark on n RPis, log to hpl-2.1_`date +%y%m%d`.txt                        
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/hpl-2.1 /srv/benchmarks/bin/hpl-2.1/xhpl >> hpl-2.1_`date +%y%m%d`.txt

	echo "HPlinpack finished on $n RPis active, 20 RPis powered" 
done 

# loop over n RPis downto 4                                                           
for host in pi20 pi19 pi18 pi16 pi15 pi12 pi11 pi10 pi08 pi07 pi06 
do
    n=${host/pi/}                                         
    n=$(echo $n|sed 's/^0*//')
    echo "Number of active RPis: $n"
	echo "Number of powered RPis: $n"
    starttime=`date +%s`
    echo "Start time: $starttime"

# Setup experiment suite in database
# One experiment suite for every program run needed 

# initialize experiment suite
	ssh rpi-user@careme<<ENDSSH                                                                                                                                                 
	# initialize experiment suite                                                                                                                                               
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','myobjective',$starttime\
	)"                                                                                                                                                                          
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
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfActiveRPis
	','${n}',$myid)"                                                                                                                                                            
	                                                                                                                                                                            
	# insert number of powered RPis                                                                                                                                             
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPi
	s','14',$myid)"                                                                                                                                                             
	                                                                                                                                                                            
	# map load generator configuration to experiment suite                                                                                                                      
	mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (3,$myid)"              
ENDSSH
	
	echo "Database setup complete"

	# log number of active RPis/powered RPis to hpl-2.1_`date +%y%m%d`.txt
	echo "Active RPis: "$n"/Powered RPis: 20" >> hpl-2.1_`date +%y%m%d`.txt

	# start benchmark on n RPis, log to hpl-2.1_`date +%y%m%d`.txt                        
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/hpl-2.1 /srv/benchmarks/bin/hpl-2.1/xhpl >> hpl-2.1_`date +%y%m%d`.txt
    echo "HPlinpack finished on $n RPis active, $n RPis powered"
done 

# create input file for database                                                                                                                                            
touch results/hpl-2.1_db`date +%y%m%d`.txt

# find all lines in first output file beginning with 'WR' (result lines) and print together with 3 following lines (timestamp lines)                                       
grep '^WR' results/hpl-2.1`date +%y+%m+%d`.txt -A 3 > results/hpl-2.1_db`date +%y%m%d`.txt

# find all lines in second output file beginning with 'WR' (result lines) and print together with 3 following lines (timestamp lines)                                      
grep '^WR' results/hpl-2.1_shutdown`date +%y%m%d`.txt -A 3 >> results/hpl-2.1_db`date +%y%m%d`.txt

# remove all empty lines                                                                                                                                                    
sed -i '/^$/d' results/hpl-2.1_db`date +%y%m%d`.txt

# remove all lines containing "start" (only "end" needed)                                                                                                                   
sed -i '/start/d' results/hpl-2.1_db`date +%y%m%d`.txt

# remove all lines containing only '--' (result from grep -A)                                                                                                               
sed -i '/--/d' results/hpl-2.1_db`date +%y%m%d`.txt

# transform database input file to lines containing space seperated values                                                                                                  
sed -i 's/ \{2,\}/ /g' results/hpl-2.1_db`date +%y%m%d`.txt
sed -i 'N;s/\n/ /' results/hpl-2.1_db`date +%y%m%d`.txt
                                                                                                                                              
ssh rpi-user@careme<<'ENDSSH'                                                                                                                                               
cat /srv/nfs-share/experimentsuite/results/hpl-2.1_db`date +%y%m%d`.txt | cut -d' ' -f6,7,12,13,14,15 | while read line                                                     
do                                                                                                                                                                          
    arr=($line)                                                                                                                                                             
    time=${arr[0]}                                                                                                                                                          
    echo "Time: $time"                                                                                                                                                      
    gflops=${arr[1]}                                                                                                                                                        
    echo "Gflops: $gflops"                                                                                                                                                  
    timestamp=${arr[@]:2}                                                                                                                                                   
    unixtime=$(date -d "${timestamp}" "+%s")                                                                                                                                
    echo $unixtime                                                                                                                                                          
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Time',$time,$unixtime)"                
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Gflops',$gflops,$unixtime)"             
done                                                                                                                                                                        
ENDSSH
                           
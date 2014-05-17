#!/bin/bash 

# Run Hplinpack on n downto 4 RPi-Nodes, run again and shutdown afterwards 

# create output files                                                                 
touch results/hpl-2.1_`date +%y%m%d`.txt results/hpl-2.1_shutdown`date +%y%m%d`.txt

# loop over n RPis downto 4                                                           
for host in pi20 pi19 pi18 pi17 pi16 pi15 pi14 pi13 pi12 pi11 pi10 pi09 pi08 pi07 pi06 pi05
do
# n := number of active RPis
    a=${host/pi/}                                         
    m=$(echo $a|sed 's/^0*//')
    n=$((m - 1))
    echo "Number of active RPis: $n"
    echo "Number of powered RPis: 20"
    starttime=`date +%s`
    echo "Start time: $starttime"

# Setup experiment suite in database
# One experiment suite for every program run needed 

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

# start benchmark on n RPis, log to results/hpl-2.1_`date +%y%m%d`.txt                        
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/hpl-2.1 /srv/benchmarks/bin/hpl-2.1/xhpl >> results/hpl-2.1_`date +%y%m%d`.txt

# get end time as unix timestamp
    endtime=`date +%s`
    echo "End time: $endtime"

# write end time of experiment suite to database                                                                                                                       
    ssh rpi-user@careme<<ENDSSH
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "UPDATE ExperimentSuite SET executionEndedAt = $endtime WHERE id = $myid"                                            
ENDSSH
    
    echo "HPlinpack finished on $n RPis active, 20 RPis powered" 
done 

# loop over n RPis downto 4                                                           
for host in pi20 pi19 pi18 pi17 pi16 pi15 pi14 pi13 pi12 pi11 pi10 pi09 pi08 pi07 pi06 pi05
do
    a=${host/pi/}                                         
# m := number of powered RPis 
    m=$(echo $a|sed 's/^0*//')
# n := number of active RPis
    n=$((m-1))
    echo "Number of active RPis: $n"
    echo "Number of powered RPis: $m"
    starttime=`date +%s`
    echo "Start time: $starttime"

# Setup experiment suite in database
# One experiment suite for every program run needed 

# initialize experiment suite
    ssh rpi-user@careme<<ENDSSH                                                                                                                                           
# initialize experiment suite                                                                                                                                             
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no2',$starttime)"
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
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuiteConfiguration (\\\`key\\\`,\\\`value\\\`,experimentSuiteId) VALUES ('NumberOfPoweredRPis','${m}',$myid)"                                                                                                                                                         

# map load generator configuration to experiment suite                                                                                                                    
 mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (6,$myid)"           
ENDSSH

    echo "Database setup complete"

# log number of active RPis/powered RPis to results/hpl-2.1_`date +%y%m%d`.txt
    echo "Active RPis: $n/Powered RPis: $m" >> results/hpl-2.1_shutdown`date +%y%m%d`.txt

# log experiment suite id to results/hpl-2.1_`date +%y%m%d`.txt                                                                                                             
    echo "Experiment suite id: $myid" >> results/hpl-2.1_shutdown`date +%y%m%d`.txt

# start benchmark on n RPis, log to results/hpl-2.1_shutdown`date +%y%m%d`.txt                        
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/hpl-2.1 /srv/benchmarks/bin/hpl-2.1/xhpl >> results/hpl-2.1_shutdown`date +%y%m%d`.txt

# get end time as unix timestamp                                                                                                                                            
    endtime=`date +%s`
    echo "End time: $endtime"

# write end time of experiment suite to database                                                                                                                            
    ssh rpi-user@careme<<ENDSSH
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "UPDATE ExperimentSuite SET executionEndedAt = $endtime WHERE id = $myid"
ENDSSH

    echo "HPlinpack finished on $n RPis active, $m RPis powered"
    ssh $host 'shutdown -hP 0'
# re-attach terminal to read new stream from STDIN
    term="/dev/$(ps -p$$ -o tty="")"
    exec < $term
    read -p "Please disconnect $host from mini usb. When finished press [Enter]"
done 

# create database input file                                                                                                                                               touch results/hpl-2.1_db`date +%y%m%d`.txt

# find all lines in first output file containing 'Experiment', 'WR' or 'end' and print to database input file                                                             
grep -E 'Experiment|WR|end' results/hpl-2.1_`date +%y%m%d`.txt > results/hpl-2.1_db`date +%y%m%d`.txt                                                                     

# find all lines in second output file containing 'Experiment', 'WR' or 'end' and print to database input file                                                             
grep -E 'Experiment|WR|end' results/hpl-2.1_shutdown`date +%y%m%d`.txt >> results/hpl-2.1_db`date +%y%m%d`.txt                                                            

# split into separate files before 'Experiment'                                                                                                                            
awk '/Experiment/{n++}{print >"out" n ".txt" }' results/hpl-2.1_db`date +%y%m%d`.txt                                                                                      

for file in out{1..32}.txt                                                                                                                                                
do

# get experiment suite id                                                                                                                                                  
    expsuiteid=$(cat $file | cut -f 4 -d " ")

# write experiment suite id to beginning of every line
    sed -i -e "s/^/$expsuiteid /" "$file"

# transform split files to lines containing space seperated values                                                                                                         
    sed -i 's/ \{2,\}/ /g' $file
    sed -i 'N;s/\n/ /' $file

# transform split files to lines containing space seperated values                                                                                                          
    sed -i 's/ \{2,\}/ /g' $file
    sed -i 'N;s/\n/ /' $file

    ssh rpi-user@careme<<'ENDSSH'
    cat /srv/nfs-share/experimentsuite/$file | cut -d' ' -f1,7,8,13,14,15,16,17 | while read line
    do
        arr=($line)
        time=${arr[1]}
	echo "Time: $time"
        gflops=${arr[2]}
        echo "Gflops: $gflops"
	timestamp=${arr[@]:3}
	# echo "Timestamp: $timestamp"                                                                                                                                     
        unixtime=$(date -d "${timestamp}" "+%s")
        echo "Unix timestamp: $unixtime"
        expsuiteid=${arr[0]}
        echo "Experiment suite id: $expsuiteid"
        mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Time',$time,$unixtime,expsuiteid)"
        mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Gflops',$gflops,$unixtime,$expsuiteid)"
    done
ENDSSH
done

# remove temporary files
rm out*

# change DB input file for gnuplot
# find all lines in first output file beginning with 'WR' (result lines) and print together with 3 following lines (timestamp lines)                                       
grep '^WR' results/hpl-2.1_`date +%y%m%d`.txt -A 3 > results/hpl-2.1_db`date +%y%m%d`.txt

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
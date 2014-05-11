#!/bin/bash                                                                           

# Run STREAM on 19 RPi-Nodes, run again and shutdown RPi-Node n

# create output files                                                                 
touch results/STREAM_`date +%y%m%d`.txt results/STREAM_shutdown`date +%y%m%d`.txt

# loop over n RPis 
for host in pi20 pi19 pi18 pi17 pi16 pi15 pi14 pi13 pi12 pi11 pi10 pi09 pi08 pi07 pi06 pi05 pi04 
do
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
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no3',$starttime)"                                                                                                                                                              
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
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (7,$myid)"             
ENDSSH

    echo "Database setup complete"

# start benchmark on n RPis, log to results/STREAM_`date +%y%m%d`.txt                                                                                                      
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/STREAM /srv/benchmarks/bin/STREAM/stream >> results/STREAM_`date +%y%m%d`.txt

# add unix timestamp to results file
    echo "Unixtime: `date +%s`" >> results/STREAM_`date +%y%m%d`.txt
    echo "STREAM finished on $n RPis active, 20 RPis powered"
done


# loop over n RPis 
for host in pi20 pi19 pi18 pi17 pi16 pi15 pi14 pi13 pi12 pi11 pi10 pi09 pi08 pi07 pi06 pi05 pi04   
do
    a=${host/pi/}
    m=$(echo $a|sed 's/^0*//')
    n=$((m - 1))
    echo "Number of active RPis: $n"
    echo "Number of powered RPis: $m"
    starttime=`date +%s`
    echo "Start time: $starttime"

# Setup experiment suite in database                                                                                                                                      
# One experiment suite for every program run needed
    ssh rpi-user@careme<<ENDSSH
# initialize experiment suite
mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO ExperimentSuite (granularityLevel,objective,executionStartedAt) VALUES ('Cluster Blackbox','experiment no4',$starttime)"                                                                                                                                                              
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
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO N2M_loadGConf2expSuite (loadGeneratorConfigurationId,experimentSuiteId) VALUES (7,$myid)"             
ENDSSH

    echo "Database setup complete"

# start benchmark on n RPis, log to results/STREAM_`date +%y%m%d`.txt                                                                                                      
    mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/STREAM /srv/benchmarks/bin/STREAM/stream >> results/STREAM_shutdown`date +%y%m%d`.txt

    if [ $host == pi03 ]; then 
	ssh root@pi01 'shutdown -hP 0'
    else 
	ssh root@$host 'shutdown -hP 0'
    fi 
    
# add unix timestamp to results file
    echo "Unixtime: `date +%s`" >> results/STREAM_shutdown`date +%y%m%d`.txt
    echo "STREAM finished on $n RPis active, $m RPis powered"
    term="/dev/$(ps -p$$ -o tty="")"
    exec < $term
    read -p "Please disconnect $host from mini usb. When finished press [Enter]. Attention: Do not disconnect pi03, but pi01 instead!"
done

# create input file for database 
touch results/STREAM_db`date +%y%m%d`.txt

# find all lines in first output file beginning with 'Copy' (first result line) and print together with 7 following lines
grep '^Copy' results/STREAM_`date +%y%m%d`.txt -A 7 > results/STREAM_db`date +%y%m%d`.txt

# find all lines in second output file beginning with 'Copy' (result lines) and print together with 7 following lines (timestamp lines)                                    
grep '^Copy' results/STREAM_shutdown`date +%y%m%d`.txt -A 7 >> results/STREAM_db`date +%y%m%d`.txt

# remove all lines containing only '--' (result from grep -A)                                                                                                              
sed -i '/--/d' results/STREAM_db`date +%y%m%d`.txt

# remove all lines beginning with blank                                                                                                                                    
sed -i '/^ /d' results/STREAM_db`date +%y%m%d`.txt

# insert new line delimiter before 'Copy'                                                                                                                                  
sed -i 's/Copy/|Copy/' results/STREAM_db`date +%y%m%d`.txt

# transform to lines containing space seperated values                                                                                                                     
sed -i 's/ \{2,\}/ /g' results/STREAM_db`date +%y%m%d`.txt

# transform whole file into one line (for read line)                                                                                                                       
sed -i ':a;N;$!ba;s/\n/ /g' results/STREAM_db`date +%y%m%d`.txt

# substitute '|' with '\n' (new line delimiter)                                                                                                                            
sed -i 's/|/\n/g' results/STREAM_db`date +%y%m%d`.txt

# remove empty first line                                                                                                                                                  
sed -i '/^$/d' results/STREAM_db`date +%y%m%d`.txt

ssh rpi-user@careme<<'ENDSSH'
cat /srv/nfs-share/experimentsuite/results/STREAM_db`date +%y%m%d`.txt | cut -d' ' -f2,3,7,8,12,13,17,18,22 | while read line
do
    arr=($line)                                                                                                                                                            
    copy_rate=${arr[0]}
echo "Copy/Rate: $copy_rate"
    copy_time=${arr[1]}
echo "Copy/Avg time: $copy_time"
    scale_rate=${arr[2]}       
echo "Scale/Rate: $scale_rate"                                                                                                                                            
    scale_time=${arr[3]}
echo "Copy/Avg time: $copy_time"
add_rate=${arr[4]}
echo "Add/Rate: $add_rate"
add_time=${arr[5]}
echo "Add/Avg time: $add_time"
    triad_rate=${arr[6]}     
echo "Triad/Rate: $triad_rate"                                                                                                                                            
    triad_time=${arr[7]}                                                                                                                                                   
echo "Triad/Avg time: $triad_time"
    unixtime=${arr[8]}           
echo "Timestamp: $unixtime"                                                                                                                                          
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Copy/Rate',$copy_rate,$unixtime)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Copy/Avg time',$copy_time,$unixtime)"  
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Scale/Rate',$scale_rate,$unixtime)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Scale/Avg time',$scale_time,$unixtime)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Add/Rate',$add_rate,$unixtime)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Add/Avg time',$add_time,$unixtime)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Triad/Rate',$triad_rate,$unixtime)" 
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt) VALUES ('Triad/Avg time',$triad_time,$unixtime)"
done
ENDSSH

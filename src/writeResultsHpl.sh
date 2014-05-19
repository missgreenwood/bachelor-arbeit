#!/bin/bash

# create database input file                                                                                                                                               
touch results/hpl-2.1_db`date +%y%m%d`.txt

# find all lines in first output file containing 'Experiment', 'WR' or 'end' and print to database input file                                                              
# result lines + experiment suite id line = 27664 lines                                                                                                                   
grep -E 'Experiment|WR|end' results/hpl-2.1_`date +%y%m%d`.txt > results/hpl-2.1_db`date +%y%m%d`.txt

# find all lines in second output file containing 'Experiment', 'WR' or 'end' and print to database input file                                                             
# result lines + experiment suite id line = 27664 lines                                                                                                                   
grep -E 'Experiment|WR|end' results/hpl-2.1_shutdown`date +%y%m%d`.txt >> results/hpl-2.1_db`date +%y%m%d`.txt

# split into separate files before 'Experiment'                                                                                                                            
# one split file per experiment suite = 32 files with 1279 lines each                                                                                                     
awk '/Experiment/{n++}{print >"out" n ".txt" }' results/hpl-2.1_db`date +%y%m%d`.txt

for file in out{1..32}.txt
do

# get experiment suite id                                                                                                                                                  
    expsuiteid=$(cat $file | cut -f4 -d " ")
    # echo "Experiment Suite id = $expsuiteid"                                                                                                                              
# write experiment suite id to beginning of every line                                                                                                                     
    sed -i -e "s/^/$expsuiteid /" "$file"

# remove first line (experiment suite id line, no longer needed)                                                                                                           
    sed -i '1d' $file

# transform split files to lines containing space seperated values                                                                                                         
    sed -i 's/ \{2,\}/ /g' $file
    sed -i 'N;s/\n/ /' $file

done

for file in out{1..32}.txt                                  
do
cat $file | cut -d' ' -f1,7,8,13,14,15,16,17 | while read line
do
arr=($line)
expsuiteid=${arr[0]}
echo "Experiment suite id: $expsuiteid"
time=${arr[1]}
echo "Time: $time"
gflops=${arr[2]}
echo "Gflops: $gflops"
timestamp=${arr[@]:3:7}
echo "Timestamp: $timestamp"
unixtime=$(date -d "${timestamp}" "+%s")
echo "Unix timestamp: $unixtime"
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Time',$time,$unixtime,$expsuiteid)"
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Gflops',$gflops,$unixtime,$expsuiteid)"
done
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

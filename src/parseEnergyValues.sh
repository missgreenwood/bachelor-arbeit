#!/bin/bash

# Parse energy values for DB rpiWerte

# export source file from database.sqlite as sources/LogValues.csv with delimiter ","
# source file: sources/LogValues.csv

# create destination file as ../sources/energyvalues_`date +%y%m%d`.txt
touch ../sources/energyvalues_`date +%y%m%d`.txt 

# read in source file line by line and write to destination file  
# remaining columns: 1 (timestamp), 4 (power in watt)

IFS=$','
cat ../sources/LogValues.csv | cut -d',' -f1,4 | while read line
do 
	arr=($line)
	timestamp=${arr[0]:1:19}

# convert column 1 to unix timestamp 
	unixtime=$(date -j -f '%Y-%m-%d %H:%M:%S' $timestamp +%s)
	echo $unixtime
	power=${arr[1]}                                                                                                                                                        
	echo $power
# write columns to destination file with delimiter " "
	echo "$unixtime $power" >> ../sources/energyvalues_`date +%y%m%d`.txt                                                                                                                                                   
done 

# upload destination file to pcheger12 
# upload destination file to directory /home/rpi-user on careme with 
# scp /users/stud/greif/Uploads/energyvalues_`date +%y%m%d`.txt rpi-user@10.153.7.253:/home/rpi-user
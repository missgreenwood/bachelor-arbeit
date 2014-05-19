#!/bin/bash

# Parse energy values for DB rpiWerte

# download source file from from pcheger12 
# export as csv file with delimiter ';'
# save as sources/LogValues.csv

# create destination file as ../sources/energyvalues_`date +%y%m%d`.txt
touch ../sources/energyvalues_`date +%y%m%d`.txt

# replace ',' with '.' and write to tmp file
sed 's/,/./g' ../sources/LogValues.csv > tmp1.txt

# replace ';' with ',' and write to tmp file 
sed 's/;/,/g' tmp1.txt > tmp2.txt

# delete first line in tmp file 
sed '1d' tmp2.txt > tmp3.txt

# read in source file line by line and write to destination file  
# remaining columns: 1 (timestamp), 3 (power in watt)

IFS=$','
cat tmp3.txt | cut -d',' -f1,3 | while read line
	do 
	arr=($line)
	timestamp=${arr[0]:0:19}
	echo $timestamp

# convert column 1 to unix timestamp 
# unixtime=$(date -j -f '%Y-%m-%d %H:%M:%S' $timestamp +%s)
	unixtime=$(date -j -f '%d.%m.%Y %H:%M:%S' $timestamp +%s)
	echo $unixtime
	power=${arr[1]}                                                                                                                                                        
	echo $power

# write columns to destination file with delimiter " "
	echo "$unixtime $power" >> ../sources/energyvalues_`date +%y%m%d`.txt
done 

# remove temporary files
rm tmp*

# upload destination file to pcheger12 
# upload destination file to directory /home/rpi-user/experimentsuite/results on careme with
# scp /users/stud/greif/Uploads/energyvalues_`date +%y%m%d`.txt rpi-user@10.153.7.253:/home/rpi-user/experimentsuite/results
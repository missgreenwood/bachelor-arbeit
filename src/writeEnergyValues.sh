#!/bin/bash 

# Write energy values from results/energyvalues_`date +%y%m%d`.txt into DB rpiWerte
# for each line in results/energyvalues_`date +%y%m%d`.txt insert into table MeasurementValue:

cat results/energyvalues_`date +%y%m%d`.txt | while read line
do 
	arr=($line)
	unixtime=${arr[0]}
	power=${arr[1]}
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (\`parameter\`,\`value\`,measuredAt,measuredBy) VALUES('Power',$power,$unixtime,7)"
done 

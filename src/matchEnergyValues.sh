#!/bin/bash


# Match measurement values from power meter with experiment suite id  

# number of experiment suites per run: 32

# 4 experiment setups: 

# HPL with 20 RPis powered 
## objective = 'experiment no1'
## experiment suite ids:  / (key id in table ExperimentSuite)

# HPL with 20-5 RPis powered 
## objective = 'experiment no2'
## experiment suite ids:  / (key id in table ExperimentSuite)

# STREAM with 20 RPis powered 
## objective = 'experiment no3'
## experiment suite ids:  / 189-204 (key id in table ExperimentSuite)

# STREAM with 20-5 RPis powered 
## objective = 'experiment no4'
## experiment suite ids: 205-220 / 56-71 (key id in table ExperimentSuite)
 
# for each experiment setup: 

## read in ids to match 
echo -n "Please enter first experiment suite id to match and press [ENTER]: " 
read first_expsuite
echo -n "Please enter last experiment suite id to match and press [ENTER]: "
read last_expsuite
for (( c=$first_expsuite; c<=$last_expsuite; c++ ))
do 
# get start and end timestamps of selected experiment suites from table ExperimentSuite: keys executionStartedAt and executionEndedAt
# get power measurement values between selected start and end timestamps from table MeasurementValue: keys measuredAt and `parameter` = 'Power'
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "SET @v1 := (SELECT executionStartedAt FROM ExperimentSuite WHERE id = $c);SET @v2 := (SELECT executionEndedAt FROM ExperimentSuite WHERE id = $c);SELECT \`value\` FROM MeasurementValue WHERE parameter = 'Power' AND measuredAt >= @v1 AND measuredAt <= @v2;" >> tmp.txt
# get number of active RPis	 
	mysql -u rpi-user -prpiWerte rpiWerte -Bse "SELECT \`value\` FROM ExperimentSuiteConfiguration WHERE experimentSuiteId = $c AND \`key\` = 'NumberOfActiveRPis'" >> tmp.txt
# write delimiter to end of input 
	echo '---' >> tmp.txt
done

# split into tmp files before delimiter
awk '/---/{n++}{print >"out" n ".txt" }' tmp.txt

# special treatment for out.txt (first split file)
# get content of last line (number of active RPis)
active_rpis=$(tail -1 out.txt)

# remove last line from file
sed -i '$ d' out.txt

# append number of active rpis to first line in tmp file 
read -r firstline < out.txt
echo "$firstline $active_rpis" >> results/energymatch`date +%y%m%d`.txt

# remove first line
sed -i '1d' out.txt

# write all other lines to result file
cat out.txt | while read line
do 
	echo $line >> results/energymatch`date +%y%m%d`.txt
done  



# same procedure for other split files 
for i in out{1..15}.txt
do 
	# get content of last line (number of active RPis)
	active_rpis=$(tail -1 $i)
	# remove last line from file 
	sed -i '$ d' $i
	# remove first line from file 
	sed -i '1d' $i 
	# append number of active rpis to first line in tmp file and write to result file results/energymatch`date +%y%m%d`.txt
	read -r firstline < $i
	echo "$firstline $active_rpis" >> results/energymatch`date +%y%m%d`.txt
	# write all other lines to result file 
	cat $i | while read line 
	do 
		echo $line >> results/energymatch`date +%y%m%d`.txt
	done
done 
	
# rm tmp files 
rm out*
rm tmp.txt

# download results/energymatch`date +%y%m%d`.txt from careme 





#!/bin/bash 

# Parse STREAM database input file STREAM_db`date +%y%m%d`.txt for gnuplot


# download database input file from careme to pcheger12: 
# scp rpi-user@10.153.7.253:/srv/nfs-share/experimentsuite/results/STREAM_db`date +%y%m%d`.txt /users/stud/greif/Downloads

# download database input file to localhost

# create result files and temporary files
touch ../sources/streamplot1.txt ../sources/streamplot2.txt ../sources/tmp1.txt ../sources/tmp2.txt

# set number of runs 
runs=16
echo "Number of runs: $runs" 


linecount=$(cat ../sources/STREAM_db`date +%y%m%d`.txt | wc -l)
# linecount=$(cat ../sources/STREAM_db140513.txt | wc -l)
echo "Linecount: $linecount"

# split after linecount/2 lines  
half=$((linecount / 2))
split -l $half ../sources/STREAM_db`date +%y%m%d`.txt
# split -l $half ../sources/STREAM_db140513.txt

# write to plot files sources/streamplot1.txt sources/streamplot2.txt
cat xaa > ../sources/streamplot1.txt
cat xab > ../sources/streamplot2.txt

# delete columns with unnecessary values
cat ../sources/streamplot1.txt | cut -d' ' -f2,3,7,8,12,13,17,18 > ../sources/tmp1.txt  
cat ../sources/streamplot2.txt | cut -d' ' -f2,3,7,8,12,13,17,18 > ../sources/tmp2.txt

splitter=$((half / runs))
echo "Number of lines per RPi per File: $splitter"

# split tmp file 1 into runs subfiles
split -l $splitter ../sources/tmp1.txt plot1

# split tmp file 2 into rpis subfiles
split -l $splitter ../sources/tmp2.txt plot2

# insert number of active RPis as last column in tmp split files
# write to plot files 
sed -e 's/$/ 19/' plot1aa > ../sources/streamplot1.txt
sed -e 's/$/ 18/' plot1ab >> ../sources/streamplot1.txt
sed -e 's/$/ 17/' plot1ac >> ../sources/streamplot1.txt
sed -e 's/$/ 16/' plot1ad >> ../sources/streamplot1.txt
sed -e 's/$/ 15/' plot1ae >> ../sources/streamplot1.txt
sed -e 's/$/ 14/' plot1af >> ../sources/streamplot1.txt
sed -e 's/$/ 13/' plot1ag >> ../sources/streamplot1.txt
sed -e 's/$/ 12/' plot1ah >> ../sources/streamplot1.txt
sed -e 's/$/ 11/' plot1ai >> ../sources/streamplot1.txt
sed -e 's/$/ 10/' plot1aj >> ../sources/streamplot1.txt
sed -e 's/$/ 9/' plot1ak >> ../sources/streamplot1.txt
sed -e 's/$/ 8/' plot1al >> ../sources/streamplot1.txt
sed -e 's/$/ 7/' plot1am >> ../sources/streamplot1.txt
sed -e 's/$/ 6/' plot1an >> ../sources/streamplot1.txt
sed -e 's/$/ 5/' plot1ao >> ../sources/streamplot1.txt
sed -e 's/$/ 4/' plot1ap >> ../sources/streamplot1.txt

sed -e 's/$/ 19/' plot2aa > ../sources/streamplot2.txt
sed -e 's/$/ 18/' plot2ab >> ../sources/streamplot2.txt
sed -e 's/$/ 17/' plot2ac >> ../sources/streamplot2.txt
sed -e 's/$/ 16/' plot2ad >> ../sources/streamplot2.txt
sed -e 's/$/ 15/' plot2ae >> ../sources/streamplot2.txt
sed -e 's/$/ 14/' plot2af >> ../sources/streamplot2.txt
sed -e 's/$/ 13/' plot2ag >> ../sources/streamplot2.txt
sed -e 's/$/ 12/' plot2ah >> ../sources/streamplot2.txt
sed -e 's/$/ 11/' plot2ai >> ../sources/streamplot2.txt
sed -e 's/$/ 10/' plot2aj >> ../sources/streamplot2.txt
sed -e 's/$/ 9/' plot2ak >> ../sources/streamplot2.txt
sed -e 's/$/ 8/' plot2al >> ../sources/streamplot2.txt
sed -e 's/$/ 7/' plot2am >> ../sources/streamplot2.txt
sed -e 's/$/ 6/' plot2an >> ../sources/streamplot2.txt
sed -e 's/$/ 5/' plot2ao >> ../sources/streamplot2.txt
sed -e 's/$/ 4/' plot2ap >> ../sources/streamplot2.txt

# # remove split files and tmp files 
rm ../sources/tmp1.txt ../sources/tmp2.txt plot* xaa xab
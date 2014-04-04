#!/bin/bash 

# Parse HPL database input file hpl-2.1_db`date +%y%m%d`.txt for gnuplot


# download database input file from careme to pcheger12: 
# scp rpi-user@10.153.7.253:/srv/nfs-share/experimentsuite/results/hpl-2.1_db`date +%y%m%d`.txt /users/stud/greif/Downloads

# download database input file to localhost

# create result files and temporary files
touch ../sources/hplplot1.txt ../sources/hplplot2.txt ../sources/tmp1.txt ../sources/tmp2.txt

# set number of usable rpis
rpis=16
echo "Usable RPis: $rpis" 

linecount=$(cat ../sources/hpl-2.1_db`date +%y%m%d`.txt | wc -l)
echo "Linecount: $linecount"

# split after linecount/2 lines  
half=$((linecount / 2))
split -l $half ../sources/hpl-2.1_db`date +%y%m%d`.txt

# write to plot files sources/hplplot1.txt sources/hplplot2.txt
cat xaa > ../sources/hplplot1.txt
cat xab > ../sources/hplplot2.txt

# delete columns with unnecessary values
cat ../sources/hplplot1.txt | cut -d' ' -f6,7 > ../sources/tmp1.txt  
cat ../sources/hplplot2.txt | cut -d' ' -f6,7 > ../sources/tmp2.txt

splitter=$((half / rpis))
echo "Number of lines per RPi per File: $splitter"

# split tmp file 1 into rpis subfiles
split -l $splitter ../sources/tmp1.txt plot1

# # split tmp file 2 into rpis subfiles
split -l $splitter ../sources/tmp2.txt plot2

# insert number of active RPis as last column in tmp split files
# write to plot files 
sed -e 's/$/ 19/' plot1aa > ../sources/hplplot1.txt
sed -e 's/$/ 18/' plot1ab >> ../sources/hplplot1.txt
sed -e 's/$/ 17/' plot1ac >> ../sources/hplplot1.txt
sed -e 's/$/ 16/' plot1ad >> ../sources/hplplot1.txt
sed -e 's/$/ 15/' plot1ae >> ../sources/hplplot1.txt
sed -e 's/$/ 14/' plot1af >> ../sources/hplplot1.txt
sed -e 's/$/ 13/' plot1ag >> ../sources/hplplot1.txt
sed -e 's/$/ 12/' plot1ah >> ../sources/hplplot1.txt
sed -e 's/$/ 11/' plot1ai >> ../sources/hplplot1.txt
sed -e 's/$/ 10/' plot1aj >> ../sources/hplplot1.txt
sed -e 's/$/ 9/' plot1ak >> ../sources/hplplot1.txt
sed -e 's/$/ 8/' plot1al >> ../sources/hplplot1.txt
sed -e 's/$/ 7/' plot1am >> ../sources/hplplot1.txt
sed -e 's/$/ 6/' plot1an >> ../sources/hplplot1.txt
sed -e 's/$/ 5/' plot1ao >> ../sources/hplplot1.txt
sed -e 's/$/ 4/' plot1ap >> ../sources/hplplot1.txt

sed -e 's/$/ 19/' plot2aa > ../sources/hplplot2.txt
sed -e 's/$/ 18/' plot2ab >> ../sources/hplplot2.txt
sed -e 's/$/ 17/' plot2ac >> ../sources/hplplot2.txt
sed -e 's/$/ 16/' plot2ad >> ../sources/hplplot2.txt
sed -e 's/$/ 15/' plot2ae >> ../sources/hplplot2.txt
sed -e 's/$/ 14/' plot2af >> ../sources/hplplot2.txt
sed -e 's/$/ 13/' plot2ag >> ../sources/hplplot2.txt
sed -e 's/$/ 12/' plot2ah >> ../sources/hplplot2.txt
sed -e 's/$/ 11/' plot2ai >> ../sources/hplplot2.txt
sed -e 's/$/ 10/' plot2aj >> ../sources/hplplot2.txt
sed -e 's/$/ 9/' plot2ak >> ../sources/hplplot2.txt
sed -e 's/$/ 8/' plot2al >> ../sources/hplplot2.txt
sed -e 's/$/ 7/' plot2am >> ../sources/hplplot2.txt
sed -e 's/$/ 6/' plot2an >> ../sources/hplplot2.txt
sed -e 's/$/ 5/' plot2ao >> ../sources/hplplot2.txt
sed -e 's/$/ 4/' plot2ap >> ../sources/hplplot2.txt

# remove split files and tmp files 
rm ../sources/tmp1.txt ../sources/tmp2.txt plot* xaa xab
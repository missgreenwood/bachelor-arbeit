#!/bin/bash 

# convert column 2 in hplplot1.txt hplplot2.txt from scientific notation to float: 
touch tmp1.txt tmp2.txt

# in hplplot1.txt, hplplot2.txt:

# find min col 1 (time):
echo "min time hplplot1: " 
echo | awk 'min=="" || $1 < min {min=$1} END{ print min}' FS=" " ../Gnuplot/hplplot1.txt

echo "min time hplplot2: " 
echo | awk 'min=="" || $1 < min {min=$1} END{ print min}' FS=" " ../Gnuplot/hplplot2.txt

# find max col 1 (time):
echo "max time hplplot1: " 
echo | awk 'max=="" || $1 > max {max=$1} END{ print max}' FS=" " ../Gnuplot/hplplot1.txt

echo "max time hplplot2: " 
echo | awk 'max=="" || $1 > max {max=$1} END{ print max}' FS=" " ../Gnuplot/hplplot2.txt

# find min col 2 (gflops):
# awk 'min=="" || $2 < min {min=$2} END{ print min}' FS=" " ../Gnuplot/tmp1.txt
 
# find max col 2 (gflops):
# awk 'max=="" || $2 > max {max=$2} END{ print max}' FS="|" ../Gnuplot/tmp2.txt


# avg spalte 1 (time):

# avg spalte 2 (gflops):

# avg spalte 1 (time):

# avg spalte 2 (gflops):


# fuer streamplot1.txt, streamplot2.txt:

# avg spalten 1 - 8   
#!/bin/bash 

# Alter energymatch1.txt and energymatch2.txt to fulfill input format for gnuplot

# save result files as tmp1.txt and tmp2.txt
# enter delimiter '---' after first and second experiment suite in both files
# result files for gnuplot: energymatch1.txt and energymatch2.txt

# split into tmp files before delimiter
awk '/---/{n++}{filename = "part1" n ".txt"; print >filename }' tmp1.txt

# split into tmp files before delimiter
awk '/---/{n++}{filename = "part2" n ".txt"; print >filename }' tmp2.txt

# special treatment for part1.txt (first split file)

# get line count 
linecount=$(cat part1.txt | wc -l)
echo "Linecount: $linecount"

# get divisor
divisor=$((bc << 16/$linecount))
echo $divisor

# echo "Divisor: $divisor" 

# add gnu value as third column



# move result files to Gnuplot
#!/bin/bash 

# Change power measurement match to correct gnuplot input format

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

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 4/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line and write to destination file energymatch1.txt
# add gnuplot_value as 3rd column
# @param gnuplot_value:	number of active rpis - diminuend; gnuplot_value -- 

gnuplot_value=$(bc <<< 'scale=3; 20 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

# IFS=$','
# cat ../sources/LogValues.csv | cut -d',' -f1,4 | while read line
cat part1.txt | cut -d' ' -f1 | while read line 
do 
	# echo $line
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch1.txt
done 

# 2nd split file

# get line count 
linecount=$(cat part11.txt | wc -l)
echo "Linecount: $linecount"

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 8/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line, skip line 1 
# append to destination file energymatch1.txt
# add gnuplot_value as 3rd column

gnuplot_value=$(bc <<< 'scale=3; 16 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

tail -n +2 part11.txt | cut -d' ' -f1 | while read line 
do 
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch1.txt
done

# 3rd split file 

# get line count 
linecount=$(cat part12.txt | wc -l)
echo "Linecount: $linecount"

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 4/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line, skip line 1 
# append to destination file energymatch1.txt
# add gnuplot_value as 3rd column

gnuplot_value=$(bc <<< 'scale=3; 8 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

tail -n +2 part12.txt | cut -d' ' -f1 | while read line
do 
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch1.txt
done

# special treatment for part2.txt (4th split file)

# get line count 
linecount=$(cat part2.txt | wc -l)
echo "Linecount: $linecount"

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 4/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line and write to destination file energymatch2.txt
# add gnuplot_value as 3rd column
# @param gnuplot_value:	number of active rpis - diminuend; gnuplot_value -- 

gnuplot_value=$(bc <<< 'scale=3; 20 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

# cat ../sources/LogValues.csv | cut -d',' -f1,4 | while read line
cat part2.txt | cut -d' ' -f1 | while read line 
do 
	# echo $line
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch2.txt
done 

# 5th split file

# get line count 
linecount=$(cat part21.txt | wc -l)
echo "Linecount: $linecount"

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 8/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line, skip line 1 
# append to destination file energymatch1.txt
# add gnuplot_value as 3rd column

gnuplot_value=$(bc <<< 'scale=3; 16 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

tail -n +2 part21.txt | cut -d' ' -f1 | while read line 
do 
	# echo $line
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch2.txt
done

# 6rd split file 

# get line count 
linecount=$(cat part22.txt | wc -l)
echo "Linecount: $linecount"

# get diminuend for number of active rpis value
diminuend=$(bc <<< 'scale=3; 4/'"$linecount"'')
echo "Diminuend: $diminuend"

# read in file line by line, skip line 1 
# append to destination file energymatch2.txt
# add gnuplot_value as 3rd column

gnuplot_value=$(bc <<< 'scale=3; 8 + '"$diminuend"'')
echo "Start value: $gnuplot_value"

tail -n +2 part22.txt | cut -d' ' -f1 | while read line
do 
	# echo $line
	arr=($line)
	power=${arr[0]}
	gnuplot_value=$(bc <<< 'scale=3; '"$gnuplot_value"' - '"$diminuend"'')
	echo "Gnuplot value: $gnuplot_value"
# write columns to destination file with delimiter " "
	echo "$power $gnuplot_value" >> energymatch2.txt
done

# remove tmp and split files 
tmp* part*

# add individual values for last line in file (4.000 as gnuplot_value needed)
# move result files to Gnuplot
#!/bin/bash 

# create input file for database 
touch results/STREAM_db`date +%y%m%d`.txt

# find all lines in first output file beginning with 'Copy' (first result line) and print together with 8 following lines
grep '^Copy' results/STREAM_`date +%y%m%d`.txt -A 8 > results/STREAM_db`date +%y%m%d`.txt

# find all lines in second output file beginning with 'Copy' (result lines) and print together with 8 following lines (timestamp lines)                                    
grep '^Copy' results/STREAM_shutdown`date +%y%m%d`.txt -A 8 >> results/STREAM_db`date +%y%m%d`.txt

# remove all lines containing only '--' (result from grep -A)                                                                                                              
sed -i '/--/d' results/STREAM_db`date +%y%m%d`.txt

# remove all lines beginning with blank                                                                                                                                    
sed -i '/^ /d' results/STREAM_db`date +%y%m%d`.txt

# insert new line delimiter before 'Copy'                                                                                                                                  
sed -i 's/Copy/|Copy/' results/STREAM_db`date +%y%m%d`.txt

# transform to lines containing space seperated values                                                                                                                     
sed -i 's/ \{2,\}/ /g' results/STREAM_db`date +%y%m%d`.txt

# transform whole file into one line (for read line)                                                                                                                       
sed -i ':a;N;$!ba;s/\n/ /g' results/STREAM_db`date +%y%m%d`.txt

# substitute '|' with '\n' (new line delimiter)                                                                                                                            
sed -i 's/|/\n/g' results/STREAM_db`date +%y%m%d`.txt

# remove empty first line                                                                                                                                                  
sed -i '/^$/d' results/STREAM_db`date +%y%m%d`.txt

cat results/STREAM_db`date +%y%m%d`.txt | cut -d' ' -f2,3,7,8,12,13,17,18,22,26 | while read line
do
    arr=($line)                                                                                                                                                            
    copy_rate=${arr[0]}
    echo "Copy/Rate: $copy_rate"
    copy_time=${arr[1]}
    echo "Copy/Avg time: $copy_time"
    scale_rate=${arr[2]}       
    echo "Scale/Rate: $scale_rate"                                                                                                                                            
    scale_time=${arr[3]}
    echo "Copy/Avg time: $copy_time"
    add_rate=${arr[4]}
    echo "Add/Rate: $add_rate"
    add_time=${arr[5]}
    echo "Add/Avg time: $add_time"
    triad_rate=${arr[6]}     
    echo "Triad/Rate: $triad_rate"                                                                                                                                            
    triad_time=${arr[7]}                                                                                                                                                   
    echo "Triad/Avg time: $triad_time"
    unixtime=${arr[8]}           
    echo "Timestamp: $unixtime"
    expsuiteid=${arr[9]}
    echo "Experiment Suite ID: $expsuiteid"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Copy/Rate',$copy_rate,$unixtime,$expsuiteid)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Copy/Avg time',$copy_time,$unixtime,$expsuiteid)"  
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Scale/Rate',$scale_rate,$unixtime,$expsuiteid)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Scale/Avg time',$scale_time,$unixtime,$expsuiteid)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Add/Rate',$add_rate,$unixtime,$expsuiteid)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Add/Avg time',$add_time,$unixtime,$expsuiteid)"
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Triad/Rate',$triad_rate,$unixtime,$expsuiteid)" 
    mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO MeasurementValue (parameter,\`value\`,measuredAt,measuredFor) VALUES ('Triad/Avg time',$triad_time,$unixtime,$expsuiteid)"
done
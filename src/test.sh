#!/bin/bash 

# for host in pi20 pi18 pi16 pi15 pi14 pi13 pi12 pi11 pi10 pi09 pi08 pi07 pi06 pi05 pi04
# do
#     n=${host/pi/}
#     n=$(echo $n|sed 's/^0*//')
#     n=$(($n - 4))
#     # echo "Number of usable RPis: $n"
#     echo "Number of active RPis: $n"
#     echo "Number of powered RPis: 16"
# done

for host in pi20 pi18 pi17 pi16 pi15 pi13 pi11 pi10 pi09 pi08 pi07 pi06 pi05 pi04 pi02 pi01
do
    n=${host/pi/}
    n=$(echo $n|sed 's/^0*//')
    n=$(($n - 4))
    # echo "Number of active RPis: $n"
    # echo "Number of powered RPis: 16"
    # starttime=`date +%s`
    # echo "Start time: $starttime"
    if [ $n > 0 ] 
    	then echo "groesser als null"
    fi 
done 
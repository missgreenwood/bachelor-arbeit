#!/bin/bash

# Start script for execution of n benchmark scripts on 20 RPi-Nodes

# remove old machinefile
# rm -f /srv/libraries/etc/mpich-3.0.4-shared/machinefile

# create new machinefile as /srv/libraries/etc/mpich-3.0.4-shared/machinefile
# for host in {pi0{1..9},pi{10..20}}
# do 
#	echo "$host" >> /srv/libraries/etc/mpich-3.0.4-shared/machinefile
# done 

# mount shared directory /srv on all RPis
for host in {pi0{1..9},pi{10..20}}
do 
	ssh root@$host 'mount /srv'
done

# navigate to execution directory
cd /srv/experimentsuite/ 

# loop over n benchmarks 
for benchmark in STREAM hpl-2.1
do 
	./$benchmark.sh  
done 
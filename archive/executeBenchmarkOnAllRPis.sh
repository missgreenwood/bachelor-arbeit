#!/bin/bash

# remove old machinefile
rm -f /srv/libraries/etc/mpich-3.0.4-shared/machinefile

# create new machinefile as /srv/libraries/etc/mpich-3.0.4-shared/machinefile
for host in {pi0{1..9},pi{10..20}}
do 
	echo "$host" >> /srv/libraries/etc/mpich-3.0.4-shared/machinefile
done 

# mount shared directory /srv on all RPis
for host in {pi0{1..9},pi{10..20}}
do 
	ssh $host 'mount /srv'
done

# optional: prepare database

# navigate to execution node 
ssh root@pi03

# prompt user for benchmark to be executed 
echo "Enter working directory for benchmark (example: \"hpl-2.1\"):"
read wdir 
cd /srv/benchmarks/bin/$wdir

# prompt user for parameter file
echo "Enter parameter file if required (example: \"HPL.dat\"). Make sure it is located in working directory."
read paramfile 

# prompt for working directory 
echo "Enter executable of benchmark (example: \"xhpl\"). Make sure it is located in working directory."
read executable 

touch output1.txt
touch output2.txt

# loop over n RPis: 
for host in {pi{20..10..-1},pi0{9..1..-1}}
do 
	n=${host:2}
	# start benchmark on n RPis, log to output1.txt
	mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/$wdir /srv/benchmarks/bin/$wdir/$executable >> output1.txt
	# write output to DB 
done

# loop over n RPis: 
for host in {pi{20..10..-1},pi0{9..1..-1}}
do 
	n=${host:2}
	# start benchmark on n RPis, log to output2.txt
	mpiexec -n $n -machinefile /srv/libraries/etc/mpich-3.0.4-shared/machinefile -wdir /srv/benchmarks/bin/$wdir /srv/benchmarks/bin/$wdir/$executable >> output2.txt
	# write output to DB 
	ssh $host 'shutdown -hP 0'
done 
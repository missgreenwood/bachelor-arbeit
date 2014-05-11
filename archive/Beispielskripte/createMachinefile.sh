#!/bin/bash

rm -f /srv/libraries/etc/mpich-3.0.4/machinefile
# remove old machinefile

for host in {2..6}
# for host in {pi0{1..9},pi{10..20}}
do
        echo "10.0.0.$host" >> /srv/libraries/etc/mpich-3.0.4/machinefile
        # echo "$host:1" >> /srv/libraries/etc/mpich-3.0.4/machinefile
        # das wäre für 1 Prozess pro Host, ist aber nicht nötig weil default 
done
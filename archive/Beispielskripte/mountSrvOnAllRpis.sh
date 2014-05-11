#!/bin/bash                                                                         

for host in pi03
do
        ssh $host 'mount /srv'
done

#!/bin/bash                                                                         

for host in pi{01..05}
do
        ssh $host 'shutdown -hP 0'
done
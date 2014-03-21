#!/bin/bash 

# Setup load generator configuration for STREAM  
# For documentation purpose 
# For new setup: change 'stream-config' into some other string

ssh rpi-user@careme<<'ENDSSH'                                                                                                                                               
# mysql -B: don't use history file, disable interactive behavior                                                                                                           
# mysql -s: silent mode                                                                                                                                                                
# mysql -e: execute query and exit

# define load generator                                                                                                                                                    
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO LoadGenerator (name,description) VALUES ('STREAM','Benchmark')"                                    

# define load generator configuration key                                                                                                                                  
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ENUM_LoadGeneratorConfigurationKey (\`value\`) VALUES ('stream-config')"                               

# assign load generator configuration key to load generator configuration                                                                                                  
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO LoadGeneratorConfiguration (\`key\`) VALUES ('stream-config')"                                            
ENDSSH 
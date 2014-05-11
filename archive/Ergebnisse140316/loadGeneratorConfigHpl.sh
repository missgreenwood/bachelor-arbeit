#!/bin/bash 

# Setup load generator configuration for hplinpack 
# For documentation purpose 
# For new setup: change 'hpl-config' into some other string

ssh rpi-user@careme<<'ENDSSH'                                                                                                                                               
# mysql -B: don't use history file, disable interactive behavior                                                                                                           
# mysql -s: silent mode                                                                                                                                                                
# mysql -e: execute query and exit

# define load generator                                                                                                                                                    
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO LoadGenerator (name,description) VALUES ('hpl-2.1','Benchmark')"                                    

# define load generator configuration key                                                                                                                                  
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO ENUM_LoadGeneratorConfigurationKey (\`value\`) VALUES ('hpl-config')"                               

# assign load generator configuration key to load generator configuration                                                                                                  
mysql --user=rpi-user --password=rpiWerte rpiWerte -Bse "INSERT INTO LoadGeneratorConfiguration (\`key\`) VALUES ('hpl-config')"                                            
ENDSSH 
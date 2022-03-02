#!/bin/bash

LOGFILE="/home/harsh/logs/sample_log.txt"
ADDRESS="harshlohana38@gmail.com" 

tail -f $LOGFILE | while read line;
do
#if any technical error send it to BBOS Dev team
if $(echo $line | grep -Eq "ERROR") 
then
    echo "$line" | mailx -s "[URGENT] - ERROR reported in logs" $ADDRESS
#if any BIDV error send it to BIDV concern team    
elif $(echo $line | awk '/ERROR/ && /BIDVConnectorUtil/')
 then
    echo "$line" | mailx -s "BIDV ERROR reported in logs" $ADDRESS
#if any TCV error send it to TCV concern team     
elif $(echo $line | awk '/ERROR/ && /TCVConnectorUtil/')
 then
    echo "$line" | mailx -s "TCV ERROR reported in logs" $ADDRESS    
fi
done
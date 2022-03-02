#!/bin/bash

#initializing variables
LOGFILE="/home/harsh/logs/sample_log.txt"
ADDRESS="harshlohana38@gmail.com"
OUTPUT="/home/harsh/logs/output.txt"
ZERO=0

#starting report
echo "---------------------------- ERROR REPORT --------------------------------------" >> $OUTPUT

#fetching current date
echo "Date : $(date +'%d-%m-%y')" >> $OUTPUT
echo "Log file : /home/harsh/logs/sample_log.txt" >> $OUTPUT

#capturing error and exception lines with line number
ERRORS=$(awk '/ERROR/ {print NR,$0}' $LOGFILE)
EXCEPTIONS=$(awk '/Exception/ {print NR,$0}' $LOGFILE)

#adding blank lines
echo >> $OUTPUT
echo >> $OUTPUT

#adding errors to output file
if [ $(grep -o 'ERROR' $LOGFILE | wc -l) -gt 0 ]
   then 
	echo "------- ERRORS ($(grep -o 'ERROR' $LOGFILE | wc -l)) -------" >> $OUTPUT
	echo "$ERRORS" >> $OUTPUT
	#adding blank lines
	echo >> $OUTPUT
fi

#adding exceptions to output file
if [ $(grep -o 'Exception' $LOGFILE | wc -l) -gt 0 ]
   then
	echo "------- EXCEPTIONS ($(grep -o 'Exception' $LOGFILE | wc -l)) -------" >> $OUTPUT
	echo "$EXCEPTIONS" >> $OUTPUT
	#adding blank lines
	echo >> $OUTPUT
fi

#Counting different type of exceptions,errors
SSL_EXCEPTION=$(grep -ow 'SSLException' $LOGFILE | wc -l)
SSL_HANDSHAKE_EXCEPTION=$(grep -ow 'SSLHandshakeException' $LOGFILE | wc -l)
CLASS_NOT_FOUND_EXCEPTION=$(grep -ow 'ClassNotFoundException' $LOGFILE | wc -l)

#adding stats to output file
echo "------- STATS -------" >> $OUTPUT

echo "SSL Exception : $SSL_EXCEPTION" >> $OUTPUT
echo "SSL Handshake Exception : $SSL_HANDSHAKE_EXCEPTION" >> $OUTPUT
echo "ClassNotFoundExcetion : $CLASS_NOT_FOUND_EXCEPTION" >> $OUTPUT

#sending mail
if [ $(grep -o 'ERROR' $LOGFILE | wc -l) -gt 0 ] || [ $(grep -o 'Exception' $LOGFILE | wc -l) -gt 0 ]
   then
 	cat $OUTPUT | mailx -s "URGENT - Errors/Exceptions reported in logs" $ADDRESS
fi

#clear contents for next report
cat /dev/null > $OUTPUT


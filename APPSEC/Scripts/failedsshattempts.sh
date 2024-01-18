#Simple script monitors for attempted ssh connections, and logs them in knownFailures log file and echos alert sound
#To run process in the background run the following command once in the directory of the script: "./failedsshattempts.sh &> /dev/null &""

echo "running..." > /dev/tty
while :
do
  logFile=$(cat /var/log/auth.log | grep "authentication failure")
  knownFailures=$(cat ./knownFailures)
    output=$(diff <(echo "$logFile") <(echo "$knownFailures"))
    if [ ! -z "$output" -a "output"!=" " ]; then
    echo "$output" > /dev/tty
    echo -e '\a' > /dev/tty
    echo "Failed ssh connection logged." > /dev/tty
    echo "$logFile" > ./knownFailures

fi

sleep 5

done
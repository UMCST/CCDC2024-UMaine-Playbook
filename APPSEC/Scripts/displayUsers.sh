#Script runs the W command and displays information about recently added and deleted users from the auth.log

echo current users: 
command w 
echo -----------

echo new users:
command sudo grep useradd /var/log/auth.log | grep "new user" > log.txt 
tail -n 2 log.txt 
echo ----------

echo deleted users: 
command sudo grep userdel /var/log/auth.log | grep "delete user" > log.txt 
tail -n 2  log.txt 
echo -----------
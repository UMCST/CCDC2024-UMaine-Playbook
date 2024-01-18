#Script alerts for successful ssh login
#Must be run as root
echo "notify-send -t 3000 \"User logged in\" \`whoami\`" > /etc/profile.d/notify_log.sh
echo "wall -n \"User logged in\" \`whoami\`" >> /etc/profile.d/notify_log.sh
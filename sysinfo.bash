OS=`hostnamectl | grep "Operating System"` #Get OS name useing hostnamectl and filtering the operating system line.
IP=`hostname -I` #Get the IP with hostnamectl, with the I argument.
Space=`df -hT / | awk '{print $4}' | tr -d '\n' | cut -c 5-` #Get the space, get the fourth data set, remove new lines, and then only get after the first 5 characters
echo -e "\n" #new line
echo "Report for $(hostname)" #Introductory message
echo "===============" #Divider
echo "FQDN: "`hostname -f` #Formatted output for fully qualified domain name
echo "Operating System name and version: $OS" #Formatted output for OS
echo  "IP Address: $IP" #Formatted output of IP addess
echo "Root Filesystem Free Space: $Space" #Formatted output of space left
echo "===============" #Divider
echo -e "\n" #new line

hasBridge = `lxc network show lxdbr0 | grep managed | awk '{print $2}'` #Returns true or false depending on if configured

if ! dpkg -s lxd >/dev/null 2>&1; then #Tests if LXD has been installed or not yet.
	sudo apt-get install lxd #If not, then install LCX
fi

if ["$hasBridge" = "true"]; then #Tests the previous hasBridge variable we got, to see if it's true or not.
	echo "lxd already configured" #If it's true, just output this text
else
	sudo lxd init #Otherwise, initialize LXD
	sudo lxc launch ubnutu:18.04 web #Launch an instance of LXD as web
	sudo lxc exec web -- apt update #Update the repositories
fi

lxc exec test -- sh -c "echo 172.0.0.1	COMP2101-S22" > /etc/hosts #Associate the COMP2101-S22 name with localhost

sudo lxc exec web -- apt install apache2 #Install Apache server in our container

sudo lxc exec web -- sudo --user ubuntu --login #login to the container
sudo usermod -a -G lxd ubuntu #Fix permission issues

sudo lxc config device add web myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80 #Start the webserver in the container

curl 127.0.0.1 && echo "You have successfully retrieved 127.0.0.1" #Try connecting to the container, returning a message if successful. 





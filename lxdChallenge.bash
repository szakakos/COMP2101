hasBridge = `lxc network show lxdbr0 | grep managed | awk '{print $2}'`

if ! dpkg -s lxd >/dev/null 2>&1; then
	sudo apt-get install lxd
fi

if ["$hasBridge" = "true"]; then
	echo "lxd already configured"
else
	sudo lxd init
	sudo lxc launch ubnutu:18.04 web
	sudo lxc exec web -- apt update
fi

lxc exec test -- sh -c "echo 172.0.0.1	COMP2101-S22" > /etc/hosts

sudo lxc exec web -- apt install apache2

sudo lxc exec web -- sudo --user ubuntu --login
sudo usermod -a -G lxd ubuntu

sudo lxc config device add web myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

curl 127.0.0.1 && echo "You have successfully retrieved 127.0.0.1"





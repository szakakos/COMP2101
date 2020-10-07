myhost=$(hostname)
echo "Your Host Name is " $myhost
echo "What's your student number?"; read $studentNum
newhost="pc $studentNum"
echo $newhost

if [$myhost-eq $newhost]
	echo "We are changing your host file to reflect the new name"
	sed -i "s/$myhost/$newhost/" /etc/hosts
	echo "we are changing your hostname to reflect your new name"
	hostname $newhost
fi
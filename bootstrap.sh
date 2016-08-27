#!/bin/bash


BT_Error=400
BT_Warning=300
BT_OK=200
BT_Die=1

BT_KeyPath=~/.ssh
BT_Ssh_KeyName=bootstrap_id-rsa

usage()
{
cat <<"USAGE"
    Usage: sudo bash bootstrap.sh            
    --
    @author Rolind Roy < hello@rolindroy.com >
       
USAGE
exit 0
}

bootstrap_handler()
{
	#$1 = Mode // Error | Warning | Ok
	#$2 = Message 
	#$3 = Die // 1 => Exit

	if [ $1 == $BT_OK ]; then 
		bootstrap_ok 
	elif [ $1 == $BT_Warning ]; then 
		bootstrap_warning 
	else 
		bootstrap_error 
	fi
	
	echo  -e "\t $2" 

	if [[ $3 -eq 1 ]]; then
		echo -e "bootstrap.sh exit with unkown error. exit 0"
		exit 0
	fi
}

bootstrap_error()
{
	echo -e "\e[31m Error : \e[0m" >&2;
}

bootstrap_warning ()
{
	echo -e "\e[36m Warning : \e[0m" >&2;
}

bootstrap_ok()
{
	echo -e "\e[32m Ok : \e[0m" >&2;
}

bootstrap_logger()
{
	echo -e "\e[34mBootstrap::\e[0m" $1 >&2;
}

bootstrap_logger "Installing and configuring ansible on localhost"
sudo apt-get -y install ansible || bootstrap_handler $BT_Error "Unable to Install ansible. Please fix the issue and try again." $BT_Die

sudo sed -i '1i localhost' /etc/ansible/hosts
BT_current_user=`who -m | awk '{print $1;}'`
if [ ! -f $BT_KeyPath/$BT_Ssh_KeyName ]; then
    ssh-keygen -t rsa -b 4096 -f $BT_KeyPath/$BT_Ssh_KeyName -C $BT_current_user || bootstrap_handler $BT_Error "Unable to create ssh key pair." $BT_Die
	cat $BT_KeyPath/$BT_Ssh_KeyName".pub" >> $BT_KeyPath/authorized_keys
fi

ansible all -m ping --private-key=$BT_KeyPath/$BT_Ssh_KeyName || bootstrap_handler $BT_Error "ansible -vvv all -m ping --private-key=$BT_KeyPath/$BT_Ssh_KeyName" $BT_Die

bootstrap_handler $BT_OK "Ansible successfully installed and configured."

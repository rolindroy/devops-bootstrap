#!/bin/bash

#*******************************************************************************************************************
#This is the Bootstrap project for setting up end-to-end DevOps CI/CD Integration process written by Rolind Roy.
#
#This projects contains bash scripts and ansible playbooks, 
#Docker that can be execute in any Debian based platform such as Ubuntu (14.04, 16.04). 
#It can be integrated "end-to-end" CI/CD Process that starts from setting up environments to Deployed on Web server.  
#
# ---   @author Rolind Roy < hello@rolindroy.com >
#*******************************************************************************************************************


BT_Error=400
BT_Warning=300
BT_OK=200
BT_Die=1

BT_KeyPath=~/.ssh
BT_Ssh_KeyName=bootstrap_id-rsa

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

bootstrap_out()
{
	securityKey=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
	echo -e "\e[34mBootstrap:: bootstrap.sh
********************************************************************************
 DevOps Bootstrap script for Continuous Integration successfully completed.!				
							
 Jenkins Server : 					
	http://$1:7070			
				
 Sonar					
	http://$1:9000		
	UserName : admin			
	Password : admin			
						
 Please use the below security key to "Unlock Jenkins".

 Security Key : \e[0m \e[32;1m $securityKey \e[0m \e[34m
 
 If sonar isn\’t start automatically, Please use below command to start sonar console.
 
 \e[0m \e[32;1m sh /usr/local/sonar/bin/linux-x86-64/sonar.sh console \e[0m \e[34m

 --
	@author Rolind Roy < hello@rolindroy.com >	
 
********************************************************************************
	 \e[0m" >&2;
}

bootstrap_logger "Getting Public Ip from dns server."
bt_public_ip=`dig +short myip.opendns.com @resolver1.opendns.com` || bootstrap_handler $BT_Warning "Unable to find public IP"
bootstrap_logger "Installing Curl"
sudo apt-get -y install curl || bootstrap_handler $BT_Error "Unable to Install curl. Please fix the issue and try again." $BT_Die

bootstrap_logger "Installing and configuring ansible on localhost"
sudo apt-get -y install software-properties-common && sudo apt-add-repository ppa:ansible/ansible -y 
sudo apt-get update
sudo apt-get -y install ansible || bootstrap_handler $BT_Error "Unable to Install ansible. Please fix the issue and try again." $BT_Die

sudo sed -i '1i localhost' /etc/ansible/hosts
BT_current_user=`whoami`
bootstrap_logger "Current working user : $BT_current_user"
if [ ! -f $BT_KeyPath/$BT_Ssh_KeyName ]; then
    bootstrap_logger "Creating ssh pair."
    ssh-keygen -t rsa -b 4096 -f $BT_KeyPath/$BT_Ssh_KeyName -N '' -C $BT_current_user || bootstrap_handler $BT_Warning "Unable to create ssh key pair." $BT_Die
    sudo cat $BT_KeyPath/$BT_Ssh_KeyName".pub" >> $BT_KeyPath/authorized_keys
fi

bootstrap_logger "Ensure ansible is installed and configured"
ansible all -m ping --private-key=$BT_KeyPath/$BT_Ssh_KeyName || bootstrap_handler $BT_Error "ansible -vvvv all -m ping --private-key=$BT_KeyPath/$BT_Ssh_KeyName" $BT_Die

bootstrap_handler $BT_OK "\e[32m Ansible successfully installed and configured. \e[0m"; 

bootstrap_logger "Running ansible-playbook bootstrap-setup.yml"
ansible-playbook -i hosts bootstrap-setup.yml --extra-vars "ubuntu_user=$BT_current_user" || bootstrap_handler $BT_Error "Execute ansible-playbook -vvvv -i hosts bootstrap-setup.yml --extra-vars \"ubuntu_user=$BT_current_user\"" $BT_Die

sudo sh /usr/local/sonar/bin/linux-x86-64/sonar.sh console > /dev/null 2>&1 & 

bootstrap_logger "Waiting to run sonar console. It may take a while... Please wait. " && sleep 30s

sudo service jenkins restart

bootstrap_out $bt_public_ip

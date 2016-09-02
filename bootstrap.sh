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
    Usage: bash bootstrap.sh            
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

bootstrap_out()
{
	securityKey= `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
	echo -e "\e[34mBootstrap:: bootstrap.sh
##########################################################
 DevOps Bootstrap script for Continuous Integration- 	
 successfully completed. !				
							
 Jenkins Server : 					
	http://<Ip_address>:7070			
	UserName : admin				
	Password : admin@123				
 Sonar					
	http://<Ip_address>:9000		
	UserName : admin			
	Password : admin			
						
 Please use the below security key to "Unlock Jenkins".

 Security Key : ${bold} $securityKey ${normal}

 --
	@author Rolind Roy < hello@rolindroy.com >	
 
##########################################################
	 \e[0m" $1 >&2;
}

bootstrap_logger "Installing Curl"
sudo apt-get -y install curl || bootstrap_handler $BT_Error "Unable to Install curl. Please fix the issue and try again." $BT_Die

bootstrap_logger "Installing and configuring ansible on localhost"
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

bootstrap_logger "Dowloading files to install and configure java"
ansible-galaxy install geerlingguy.java -f -p ./roles/
mv ./roles/geerlingguy.java ./roles/java

bootstrap_logger "Dowloading files to install and configure Mysql Database"
ansible-galaxy install geerlingguy.mysql -p ./roles/
mv ./roles/geerlingguy.mysql ./roles/mysql

bootstrap_logger "Running ansible-playbook bootstrap-setup.yml"
ansible-playbook -i hosts bootstrap-setup.yml || bootstrap_handler $BT_Error "Execute ansible-playbook -vvvv -i hosts bootstrap-setup.yml" $BT_Die

bootstrap_out

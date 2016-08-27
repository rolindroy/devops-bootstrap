#!/bin/bash


BT_Error=400
BT_Warning=300
BT_OK=200
BT_Die=1

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


# sudo apt-get install vir || bootstrap_handler $BT_Warning "vir not found" $BT_Die

echo -e "working"
# DevOps Bootstrap project for CI/CD
This is the Bootstrap project for setting up end-to-end DevOps CI/CD Integration process build with Shell and Ansible.

This project aims to cover entire process of DevOps Lifecycle of continues integration that starts from "checkout code" to "Deploy and release" with the help of ["DevOps Sample Java Project"](https://github.com/rolindroy/devops-ci-deployment). 


Currently the project support only Debian based environments. 
It will install and configure the following on an Ubuntu (14.04/16.04)

  
  - Ansible
  - Docker
  - Jenkins
  - Java (Open JDK 8.0)
  - Apache Maven
  - SonarQube
  - Mysql


## Requirements

Requires `git`, `curl`, `wget` to be installed on the server.


## Dependencies

  - geerlingguy.java
  - geerlingguy.mysql

## How to execute

    - bash bootstrap.sh
  `bootstrap.sh` is written in shell, this script will install and configure all the dependencies which needed to execute ansible  playbook `bootstrap-setup.yml` and It will invoke ansible playbook automatically.
  
  `bootstrap-setup.yml ` is ansible playbook which will install and configure “End-to-End CI/CD Life cycle”.
  
  Once the script is executed, will be able to access the server by using following credentials.
   
    - Jenkins Server : 					
	      - http://<IP_Address>:7070							
    - Sonar					
	      - http://<IP_Address>:9000		
	      - UserName : admin			
	      - Password : admin
	      
  Make sure that all the login process are completed. If you are not able to see the jenkins job in the server please reload configuration from disk.
  
  Step 1: Restart jenkins from terminal `sudo service jenkins restart`
  
  Step 2: Reload configuration from disk.
  
  ![alt tag](https://raw.githubusercontent.com/rolindroy/devops-bootstrap/master/ImageContent/reload.jpg)
  
  once the configuration is reloaded, You could able to see the sample job here.
  
  ![alt tag](https://raw.githubusercontent.com/rolindroy/devops-bootstrap/master/ImageContent/job.png)
  
  Once the build is successful, You are able to access the web application using following url
  	
	- http://<IP_Address>:8080/CounterWebApp/
	
  ![alt tag](https://raw.githubusercontent.com/rolindroy/devops-bootstrap/master/ImageContent/tomcat.png)

  
  
## License

Unlicensed

## Author Information

This project was created in 2016 by 
	[Rolind Roy](http://rolindroy.com) ,
	[Naresh Babu](https://github.com/narezchand) and
	[Shifa Mariam](https://github.com/shifamariam) 
	
Thank You for using this Project.

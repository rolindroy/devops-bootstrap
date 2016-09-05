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
  - Nexus


## Requirements

Requires `git`, `curl`, `wget` to be installed on the server.


## Dependencies

  - geerlingguy.java
  - geerlingguy.mysql

## How to execute

    - bash bootstrap.sh

## License

Unlicensed

## Author Information

This project was created in 2016 by [Rolind Roy](http://rolindroy.com) | hello@rolindroy.com

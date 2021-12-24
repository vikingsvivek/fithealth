#!/bin/bash

###constants
IS_JDK11_INSTALLED=0
TOMCAT_INSTALL_STATUS=0
TOMCAT_SERVICE_STATUS=0
TOMCAT_SERVICE_SETUP_STATUS=0
###Functions here
function checkJDK11Install(){
	local JDK11_STATUS=$(dpkg -s openjdk-11-jdk)
	if [[ $JDK11_STATUS == *"install ok installed"* ]]; then
		IS_JDK11_INSTALLED=1;
	fi
}

function checkAndInstallTomcat(){
	echo "INFO: USER_HOME : $HOME"
	if [ -d $HOME/middleware/apache-tomcat-10.0.14/ ]; then
		echo "INFO: Tomcat server is already installed"
	else	
		echo "INFO: Tomcat server is not installed, installing.."
		sudo mkdir -p $HOME/middleware
		cd $HOME/middleware
		sudo wget --no-check-certificate https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.14/bin/apache-tomcat-10.0.14.tar.gz
		sudo gunzip apache-tomcat-10.0.14.tar.gz
		sudo tar -xvf  apache-tomcat-10.0.14.tar
		sudo rm -rf apache-tomcat-10.0.14.tar
		local TOMCAT_INSTALL_STATUS=$?
		return $TOMCAT_INSTALL_STATUS;
	fi
}

function checkTomcatServiceStatus(){
	sudo systemctl status tomcat
	TOMCAT_SERVICE_STATUS=$?
	#if [[ $TOMCATSERVICE_STATUS -eq 0 ]]; then
	#	TOMCAT_SERVICE_STATUS=0;
	#else 
	#	TOMCAT_SERVICE_STATUS=1;
	#fi
}

function configureTomcatService(){
	echo "INFO: USER_HOME : $HOME"
	sudo cp /tmp/tomcat.service  /etc/systemd/system/tomcat.service
	sudo sed -i "s|#USER_HOME#|$HOME|g" /etc/systemd/system/tomcat.service
	
	sudo systemctl daemon-reload
	sudo systemctl restart tomcat 
	TOMCAT_SERVICE_SETUP_STATUS=$?
}

## Main Block
sudo apt update -y

### STEP1: check JDK status & Installing if not done
checkJDK11Install
if [ $IS_JDK11_INSTALLED -eq 0 ]; then
	echo "INFO: Installing JDK11"
	sudo apt install -y openjdk-11-jdk
	JDK11_INSTALLATION_STATUS=$?;
	if [ $JDK11_INSTALLATION_STATUS -eq 0 ]; then
		echo "INFO: JDK11 installation successful."
	else 
		echo "ERROR: JDK11 installation failed,exiting.."
		exit 100
	fi
else 
	echo "INFO: JDK11 already installed, Skipping"
fi 

##STEP2: check Tomcat & install
checkAndInstallTomcat
if [ $TOMCAT_INSTALL_STATUS -eq 0 ]; then
	echo "INFO: Tomcat server installation is done/already installed. Skipping"
else 
	echo "ERROR: Tomcat Server installation failed with some error. Exiting"
	exit 101;
fi 

##STEP3: check tomcat service status
checkTomcatServiceStatus
if [ $TOMCAT_SERVICE_STATUS -ne 0 ]; then
	echo "INFO: Tomcat service not configured, configuring it"
	configureTomcatService
	if [ $TOMCAT_SERVICE_SETUP_STATUS -eq 0 ]; then
		echo "INFO: Tomcat service setup successful"
	else 
		echo "ERROR: Tomcat service setup failed, Exiting"
		exit 102
	fi
else 
	echo "INFO: Tomcat service is already configured., Skipping"
fi

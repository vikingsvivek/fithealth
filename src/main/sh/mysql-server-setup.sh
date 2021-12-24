#!/bin/bash


source /tmp/expect_mysql_secure_installation.sh
##### Funcation Definitions here

function checkMySQLInstalled() {
	local MYSQL_STATUS=$(dpkg -s mysql-server-8.0)

	if [[ $MYSQL_STATUS == *"install ok installed"* ]]; then 
		return 1
	fi
}

function installMySQL(){
	installDebConfigUtils
	changeRootUserPassword
	echo "INFO: Installing MYSQL-SERVER"
	sudo apt install -y mysql-server-8.0
	local MYSQL_INSTALL_STATUS=$?
	return $MYSQL_INSTALL_STATUS;
}


function installDebConfigUtils() {
	DEBCONF_STATUS=$(dpkg -s debconfig-utils)

	if [[ $DEBCONF_STATUS == *"install ok installed"* ]]; then 
		echo "INFO: debconfig-utils already installed skipping."
	else 
		echo "INFO: Installing debconfig-utils."
		sudo apt install -y debconf-utils
	fi
}

function changeRootUserPassword(){
	#echo "mysql-server-8.0 mysql-server/root_password password welcome123" | sudo debconf-set-selections
	#echo "mysql-server-8.0 mysql-server/root_password_again password welcome123" | sudo debconf-set-selections
	
	 sudo debconf-set-selections <<< "mysql-server-8.0 mysql-server/root_password password welcome123"
	 sudo debconf-set-selections <<< "mysql-server-8.0 mysql-server/root_password_again password welcome123"
	export DEBIAN_FRONTEND="noninteractive"
	
	echo "INFO: changed the root user password "
}

function mysqlSecureInstalltion() {
	echo "INFO: doing mysql_secure_installation"
	expect_mysql_secure_install
	EXPECT_MYSQL_INSTALL_STATUS=$?;
}



#### Main Block

##STEP 1: INSTALL MYSQL SERVER
sudo apt update -y
checkMySQLInstalled
MYSQL_STATUS_CHECK=$?

echo "MYSQL_STATUS: $MYSQL_STATUS_CHECK"

if [ $MYSQL_STATUS_CHECK -eq 0 ]; then
	installMySQL
	MYSQL_INSTALL_STATUS=$?
	echo "MYSQL_INSTALL_STATUS: $MYSQL_INSTALL_STATUS"
	if [ $MYSQL_INSTALL_STATUS -eq 0 ]; then
		checkAndInstallExpect
		mysqlSecureInstalltion
	else 
		echo "ERROR: MYSQL Installation failed"
		exit 100
	fi
else
	echo "INFO: MYSQL-SERVER already installed, skipping"
fi


###STEP3: MY_SQL_SECURE_INSTALL with expect script

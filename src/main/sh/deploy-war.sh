#!/bin/bash

###Functions here
function deployWar(){
	sudo systemctl stop tomcat
	echo "USER_HOME : $HOME"
	sudo rm -rf $HOME/middleware/apache-tomcat-10.0.14/fithealth*
	sudo cp /vagrant/target/fithealthapp.war $HOME/middleware/apache-tomcat-10.0.14/webapps
	sudo systemctl start tomcat
	local WAR_DEPLOY_STATUS=$?
	return $WAR_DEPLOY_STATUS
}


##MAIN block

deployWar
DEPLOY_WAR_STATUS=$?
echo "DEPLOY_STATUS: $DEPLOY_WAR_STATUS"
if [ $DEPLOY_WAR_STATUS -ne 0 ]; then
	echo "ERROR:  Fithealth War deployment failed.."
	exit 103
else 
	echo "INFO: Fithealth War deployed successfully."
fi

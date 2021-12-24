#!/usr/bin/expect -f 

##### Funcation Definitions here
function checkAndInstallExpect(){
	EXPECT_STATUS=$(dpkg -s expect)
	echo "EXPECT_STATUS: $EXPECT_STATUS"
	if [[ $EXPECT_STATUS == *"install ok installed"* ]]; then
		echo "INFO: expect already installed, skipping."
	else 
		sudo "INFO: Installing expect"
		sudo apt install -y expect
	fi
}


function expect_mysql_secure_install(){
	expect -c 'set timeout -1
	spawn mysql_secure_installation
	expect "Enter password for user root:"
	send -- "welcome123\r"
	expect "Press y|Y for Yes, any other key for No:"
	send -- "No\r"
	expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
	send -- "No\r"
	expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
	send -- "Y\r"
	expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
	send -- "Y\r"
	expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
	send -- "Y\r"
	expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
	send -- "Y\r" 
	expect eof'
	
	local EXPECT_MYSQL_INSTALL_STATUS=$?
	return $EXPECT_MYSQL_INSTALL_STATUS;
}

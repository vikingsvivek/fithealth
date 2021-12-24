
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  #config.vm.box = "hashicorp/precise64"
  config.vm.define "dbserver" do |dbserver|
	dbserver.vm.boot_timeout = 10000
    dbserver.vm.network "private_network", ip:"192.168.12.39", virtualbox_intnet:"fithealth_nw_1" 
    dbserver.vm.provider "virtualbox" do |dbprovider|
      dbprovider.name="fithealth-db-server-machine"
      dbprovider.cpus=2
      dbprovider.memory=2048
    end
	## Below is not needed as by default, vagrant copies all files from project root to /vagrant shared directory
	## But we might need to use this way as all places the src/main location will be hardcoded which is suscipltible for code change, also update the paths in scripts accordingly
	#dbserver.vm.provision "copy-mysql-secure-installation-expect-script", type: "file", source: "./src/main/sh/mysql-server-setup.sh", destination: #"/tmp/"
    dbserver.vm.provision "mysql-server", type: "shell", path: "./src/main/sh/mysql-server-setup.sh"
	dbserver.vm.provision "configure-mysql-remote-access", type: "shell", path: "./src/main/sh/configure_remote_access.sh"
  end
  config.vm.define "webserver" do |webserver|
	webserver.vm.boot_timeout = 10000
	webserver.vm.network "private_network", ip:"192.168.12.38", virtualbox_intnet:"fithealth_nw_1" 
	webserver.vm.network "forwarded_port", host:8080, guest:8080
	webserver.vm.provider "virtualbox" do |webprovider|
      webprovider.name="fithealth-web-server-machine"
	  #webprovider.cpus=2
	  #webprovider.memory=2048
    end
	webserver.vm.provision "setup-web-server", type: "shell", path: "./src/main/sh/web-server-setup.sh"
	webserver.vm.provision "deploy-web-app", type: "shell", path: "./src/main/sh/deploy-war.sh", run: "always"
  end

end

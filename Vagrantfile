# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-windows-2016"
    config.vm.box = "windows_2016_virtualbox.box"
    config.vm.communicator = "winrm"

    # Admin user name and password
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"

    config.vm.guest = :windows
    config.windows.halt_timeout = 15

    config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
    config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", auto_correct: true

    config.vm.network "forwarded_port", guest: 1433, host: 1433, auto_correct: true
    config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    #config.vm.synced_folder "../App/", "C:/App" 
    #config.vm.synced_folder "../for_sql/", "C:/sql"
    config.vm.provision "shell", path: "./scripts/Aps/CloningRepo.ps1"
    config.vm.provision "shell", path: "./scripts/Aps/CreateWebApp.ps1"
    


    config.vm.provider :virtualbox do |v, override|
        #v.gui = true
        v.customize ["modifyvm", :id, "--memory", 4096]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end

end

# Windows Server 2016 Template for Packer

### Introduction

This repository contains Windows Server 2016 template that can be used to create boxes for Vagrant using Packer.

### Packer Version

Packer 1.3.5

### Windows Version

Windows Server 2016

### VirtualBox Version

VirtualBox 6.0.6

### Git Version

Git 2.21.0

### MS SQL Server Version

MS SQL Server 17.9.1

### Product Keys

The `Autounattend.xml` files are configured to work correctly with trial ISOs (which will be downloaded and cached for you the first time you perform a `packer build`). If you would like to use retail or volume license ISOs, you need to update the `UserData`>`ProductKey` element as follows:

* Uncomment the `<Key>...</Key>` element
* Insert your product key into the `Key` element

### Windows Updates

The scripts in this repo will install all Windows updates – by default – during Windows Setup. This is a _very_ time consuming process, depending on the age of the OS and the quantity of updates released since the last service pack. You might want to do yourself a favor during development and disable this functionality, by commenting out the `WITH WINDOWS UPDATES` section and uncommenting the `WITHOUT WINDOWS UPDATES` section in `Autounattend.xml`:

```xml
<!-- WITHOUT WINDOWS UPDATES -->
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1 -AutoStart</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<!-- END WITHOUT WINDOWS UPDATES -->
<!-- WITH WINDOWS UPDATES -->
<!--
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c a:\microsoft-updates.bat</CommandLine>
    <Order>98</Order>
    <Description>Enable Microsoft Updates</Description>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1</CommandLine>
    <Description>Install Windows Updates</Description>
    <Order>100</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
-->
<!-- END WITH WINDOWS UPDATES -->
```

Doing so will give you hours back in your day, which is a good thing.

### OpenSSH / WinRM

Currently, [Packer](http://packer.io) has a single communicator that uses SSH. This means we need an SSH server installed on Windows - which is not optimal as we could use WinRM to communicate with the Windows VM. In the short term, everything works well with SSH; in the medium term, work is underway on a WinRM communicator for Packer.

If you have serious objections to OpenSSH being installed, you can always add another stage to your build pipeline:

* Build a base box using Packer
* Create a Vagrantfile, use the base box from Packer, connect to the VM via WinRM (using the [vagrant-windows](https://github.com/WinRb/vagrant-windows) plugin) and disable the 'sshd' service or uninstall OpenSSH completely
* Perform a Vagrant run and output a .box file

### Using .box Files With Vagrant

The generated box files include a Vagrantfile template that is suitable for
use with Vagrant 2.2.4, which includes native support for Windows and uses
WinRM or SSH to communicate with the box.

### Getting Started

Trial version of Windows 2016 is used by default. This image can be used for 180 days without activation.

Alternatively -if you have access to [MSDN](http://msdn.microsoft.com) or [TechNet](http://technet.microsoft.com/) - you can download retail or volume license ISO images and place them in the `iso` directory. If you do, you should supply appropriate values for `iso_url` (e.g. `./iso/<path to your iso>.iso`) and `iso_checksum` (e.g. `<the md5 of your iso>`) to the Packer command. For example, to use the Windows 2016 retail ISO:

1. Download the Windows Server 2016 (x64) - DVD (English) ISO (`14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO`)
2. Verify that `14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO` has an MD5 hash of `70721288bbcdfe3239d8f8c0fae55f1f`
3. Clone this repo to a local directory
4. Move `14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO` to the `iso` directory
5. Run:
    
    ```
    packer build \
        -var iso_url=./iso/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO \
        -var iso_checksum=70721288bbcdfe3239d8f8c0fae55f1f windows_2016.json
    ```

### Variables

The Packer templates support the following variables:

| Name                | Description                                                      |
| --------------------|------------------------------------------------------------------|
| `iso_url`           | Path or URL to ISO file                                          |
| `iso_checksum`      | Checksum (see also `iso_checksum_type`) of the ISO file          |
| `iso_checksum_type` | The checksum algorithm to use (out of those supported by Packer) |
| `autounattend`      | Path to the Autounattend.xml file                                |

# GUID

### All actions were performed on Windows Server 2016 x64.

1. Install Git from the link `https://git-scm.com/`

2. install chocolatey using powershell command:
`Set-ExecutionPolicy Bypass -Scope Process -Force; 
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

3. Run command In PowerShell: 

3.1. `choko install packer` to install packer

3.2. `choco install virtualbox` to install virtualbox

3.3. `choco install vagrant` to install vagrant

4. Check compatibility virtualbox and packer choco upgrade virtualbox

5. Download this build using the command:
`git clone https: //github.com/studentota2lvl? tab = repositories`

6. Download `SQLServer2017-x64-ENU-Dev.iso`, and place it in a folder one level higher.
7. Download NET Framework `NDP472-DevPack-ENU.exe` and move to the folder with SQLServer2017-x64-ENU-Dev.iso.
8. Move `Git-2.21.0-64-bit.exe` to the folder with SQLServer2017-x64-ENU-Dev.iso.
9. The directory structure should be as follows: 
		<br/>├───app (synced folder for your app)
		<br/>├───for_sql (synced folder for SQL database)
		<br/>├───packer-windows
		<br/>├───Git-2.21.0-64-bit.exe
		<br/>├───NDP472-DevPack-ENU.exe
		<br/>└───SQLServer2017-x64-ENU-Dev.iso
		
10. From Windows PowerShell go to folder packer-windows and run command `packer build windows_2016.json`
11. After the box is successfully created, you can edit the Vagrantfile to customisation the parameters of the virtual machine:
	<br/>`config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true` - port forvarding.
	<br/>`config.vm.synced_folder "../App/", "C:/App"` - synced folder.
	<br/>`config.vm.provision "shell", path: "./scripts/Aps/CloningRepo.ps1"` - provision scripts.
	<br/>`v.customize ["modifyvm", :id, "--memory", 4096]` - memory quantity.
    <br/>`v.customize ["modifyvm", :id, "--cpus", 2]` - quantity of CPU.

12. After editing run in PowerShell command `vagrant up` from folder packer-windows

### Contributing

Pull requests welcomed.
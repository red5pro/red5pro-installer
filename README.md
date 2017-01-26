# red5pro-installer
Installer for Red5 Pro Server


## INTRODUCTION
---

The Red5pro install is a shell script, designed to make Red5pro installation simple and more efficient by automating most of the tasks related to getting a new Red5pro installation running.

The script presents a collection menu driven options to help achieve various red5pro setup tasks. Additionally it also takes care of installing the software depencencies required to get Red5pro working. The script in intended to work on supported linux flavors and mac.



## REQUIREMENTS
---

This script is 'currently' designed to work with linux systems. You need to have a linux distribution supported by 'Red5Pro' (ex: ubuntu, centos).

The script requires super user privileges to execute and carry out subtasks. Hence you must execute the script as a super user on your linux system (sudo...).


## USAGE
---

**To execute the script :** 
>> Script is located at : `Linux/rpro-utils.sh`
* Copy the script and conf.ini (script configuration file) to a location from where it can be executed such as : `/home/{username}/`.
* Navigate to directory location in the linux terminal (shell)
* Assign executable permissions to the script by issuing the following command in terminal : `sudo chmod +x ./rpro-utils.sh`

---

##### UBUNTU

* Execute the script by issuing the following command : `sudo ./rpro-utils.sh`

##### CENTOS

* Execute the script by issuing the following command : `sudo  bash./rpro-utils.sh`

>> Use the menu driven interface sequentially and follow instructiosn carefully for best results.

---

## PROGRAM OPTIONS
===

#### INITIALIZTION

As the script runs in the terminal, it detects the operating system details such as Distribution (OS name), Version (OS version), Kernel type (64/32 bit), User's hoem directory, Red5pro default backup directory (located inside the home directory) and the default install location (the current directory).

The detected information is printed on screen an d then the menu which allows you to select a operation mode is rendered. The program supports two modes of operation : 

* Basic Mode: Provides most of the options for new installations.
* Advance Mode: Provides advance options for managing a existing red5pro installation.


![Main Menu](Linux/images/main_menu.png?raw=true "Main Menu")


__You can select a menu option by typing the number that represents that option and pressing [ ENTER ]__


#### BASIC MODE


The basic mode provides all the options, commonly required to setup a new red5pro installation and other operatison such as starting / stopping red5.  Thew basic menu option allows you to:


![Basic Mode](Linux/images/basic_mode.png?raw=true "Basic Mode")



#### INSTALL LATEST RED5PRO


Allows you to install Red5pro from red5pro.com website. You must have an existing account on red5pro.com to use this option. Before proceesding, the script checks for a few basic requirements : 

* Java : Java (JRE / JDK 1.8 or greater is required to install Red5pro)
* unzip : Unzip utility is required to unpack zip archives.

Depending on whether the softwares are found in the os distribution, the script helps you install them using the platform specific installation method. (ie: Ubuntu uses apt-get, where as CentOS uses yum to install softwares. )

Once the requirements are met the script proceeds to 'obtaining the latest Red5pro from Red5pro.com'. At this point, it prompts you for site credentials (email  & password). This information is posted to the website to help authenticate your download. If authentication succeeds, it begins downloading the latest red5pro archive file from red5pro.com. 


__* If an existing script is found, the script tried to stop red5 in case it was running before it can continue.__

__* If there is an existing red5pro installation found at the location, the files wil be backed up to the default backup location__


Once the download completes, the program extracts the archive file's content and copies the red5pro files into the install location. It prompts for a confirmation before starting the install.

The script prompts to determine if a autostart service is required for the red5pro installation. If user selects 'yes', The program creates a linux startup script for the current OS platform. Thsi script helsp red5pro start automatically with operating system startup.


#### INSTALL RED5PRO FROM ZIP

This option lets you install Red5pro from a pre downlaoded zip. In case you have a older Red5pro that you wish to install or if you do not want to have the program download the latest red5pro for you.

The script checks the basic red5pro requirements as with the first option (INSTALL LATEST RED5PRO). Once requiremenst are met, it prommpts you for the full absolute path of the red5pro zip file. 

__The archive should have been downloaded from red5pro.com. Using a archive from a different source will not work__

The program extracts the archive file's content and copies the red5pro files into the install location. The rest of the process is exactly the same as for the first option (INSTALL LATEST RED5PRO).



#### REMOVE RED5PRO INSTALLATION

This option lets you remove an existing red5pro installation. Removal deletes all the files and removes red5pro startup script if it exists.

On selection of this option, the program loosk for existing red5pro installation in the install location. If an installation is found, the user will be prompted to confirm the removal action. If user confirms it (by pressing Y + [ ENTER ] ), the script deletes the red5pro installation as well as any red5pro service installed on the OS.






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

### PROGRAM OPTIONS
===

###### INITIALIZTION

As the script runs in the terminal, it detects the operating system details such as Distribution (OS name), Version (OS version), Kernel type (64/32 bit), User's hoem directory, Red5pro default backup directory (located inside the home directory) and the default install location (the current directory).

The detected information is printed on screen an d then the menu which allows you to select a operation mode is rendered. The program supports two modes of operation : 

* Basic Mode: Provides most of the options for new installations.
* Advance Mode: Provides advance options for managing a existing red5pro installation.


![Main Menu](Screenshots/main_menu.png?raw=true "Main Menu")




# red5pro-installer
Installer for Red5 Pro Server


## INTRODUCTION
---

The Red5pro install is a shell script, designed to make Red5pro installation simple and more efficient by automating most of the tasks related to getting a new Red5pro installation running.

The script presents a collection menu driven options to help achieve various red5pro setup tasks. Additionally it also takes care of installing the software dependencies required to get Red5pro working. The script in intended to work on supported linux flavors.




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

**CentOs is currently not supported**


##### SPECIAL NOTE

__On linux you can hit `CTRL + C` in the terminal at anytiem to interrupt/abort a script execution.__


---

## PROGRAM CONFIGURATION FILE -> CONF.INI
===

The configuration file `conf.ini` is located in the same location as the program itself. It contains the basic configuration information needed for the installer script to run. Some of the configuration can be changed and some are fixed. Given below is the content of the `conf.ini` file.

```

# JAVA REQUIREMENTS
# -------------------
MIN_JAVA_VERSION="1.8"


# JAVA DOWNLOAD LOCATIONS FOR CENTOS
# ---------------------------------------------------------------------------
JAVA_JRE_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jdk/8u102-b14/"
JAVA_32_FILENAME="jre-8u102-linux-i586.rpm"
JAVA_64_FILENAME="jre-8u102-linux-x64.rpm"


# Backup Folder => [ located in home directory ]
# ----------------------------------------------
DEFAULT_BACKUP_FOLDER=red5pro_backups


# Download folder name => [ Resolved in current directory ]
# ----------------------------------------------
RED5PRO_DEFAULT_DOWNLOAD_FOLDER_NAME=tmp


# Red5pro install location
# ----------------------------------------
DEFAULT_RPRO_INSTALL_LOCATION=/usr/local
DEFAULT_RPRO_FOLDER_NAME=red5pro

# Logging settings
# ----------------------------------------
LOG_FILE_NAME=rpro_installer.log
LOGGING=true

# CUSTOM URL LOCATION
# ---------------------------------------
RED5PRO_DOWNLOAD_URL=

# INSTALLER CLEANUP
# ---------------------------------------
RED5PRO_INSTALLER_OPERATIONS_CLEANUP=1

# MINIMUM PERCENTAGE OF SYSTEM MEMORY TO ALLOCATE
# ---------------------------------------
RED5PRO_MEMORY_PCT=80

# SERVICE TYPE [ init.d (1) or jsvc (2)
# ---------------------------------------
SERVICE_VERSION=2


# SSL INSTALLER
# ---------------------------------------
RED5PRO_SSL_LETSENCRYPT_FOLDER_NAME=letsencrypt
RED5PRO_SSL_LETSENCRYPT_GIT=https://github.com/letsencrypt/letsencrypt
RED5PRO_SSL_LETSENCRYPT_EXECUTABLE=letsencrypt-auto
RED5PRO_SSL_DEFAULT_HTTP_PORT=80
RED5PRO_SSL_DEFAULT_HTTPS_PORT=443
RED5PRO_SSL_DEFAULT_WS_PORT=8081
RED5PRO_SSL_DEFAULT_WSS_PORT=8083


```


##### CONFIGURAION OPTIONS:

* `MIN_JAVA_VERSION` : Minimim version of java (JRE/JDK) that is required by the installer to install Red5pro on the system. This value should not be changed by the user.


* `JAVA_JRE_DOWNLOAD_URL` : Base url of the latest rpm package(s) required for java installation on CentOs. This value should not be changed by the user.This attribute is deprecated.


* `JAVA_32_FILENAME` : Filename of the 32 bit java rpm package for CentOs .This attribute is deprecated.


* `JAVA_64_FILENAME` : Filename of the 64 bit java rpm package for CentOs.This attribute is deprecated.


* `DEFAULT_BACKUP_FOLDER` : Name of the default red5pro backup directory. This is always expected to be inside the hoem directory.The program creates the directory if it does not exist.


* `DEFAULT_RPRO_FOLDER_NAME` : Name of the default red5pro install directory (install location). The program always installs red5pro in the current directory, where the script is run from.

* `LOG_FILE_NAME` : Name of installer log file. Defaults to `rpro_installer.log`.

* `LOGGING` : Boolean flag to enable or disable logging. Defaults to `true`

* `RED5PRO_DOWNLOAD_URL` : Custom Red5 Pro archive URL for installation (optional). 
>This will be used if you install Red5 Pro from URL

* `RED5PRO_INSTALLER_OPERATIONS_CLEANUP` : Whether to clean up the downloaded Red5 Pro archive file from installer's `tmp` directory. `1` to enable and `0` to disable. Defaults to `1`.

* `RED5PRO_MEMORY_PCT` : How much (percentage) of system memory to allocate for JVM to Run Red5 Pro. Defaults to `80`.

* `SERVICE_VERSION` : Which version  of daemon service initialization to use for Red5 Pro instalaltion. Installing service allows you to auto start Red5 Pro with system startup and manage start/stop/restart more efficiently.`Classic` (1) style uses `init.d` whereas `Modern` (2) style uses `jsvc` for linux service management. Defaulst to `Modern` (2).

* `RED5PRO_SSL_LETSENCRYPT_FOLDER_NAME` : The Letsencrypt SSL installer directory name. This is created in the installer directory.

* `RED5PRO_SSL_LETSENCRYPT_GIT` : Letsencrypt SSL installer GIT repo URL

* `RED5PRO_SSL_LETSENCRYPT_EXECUTABLE` : The Letsencrypt SSL installer executable 

* `RED5PRO_SSL_DEFAULT_HTTP_PORT` : Red5 Pro default HTTP port. This is used by the SSL installer to configure the HTTP port value.

* `RED5PRO_SSL_DEFAULT_HTTPS_PORT` : Red5 Pro default HTTPS port. This is used by the SSL installer to configure the HTTPS port value.

* `RED5PRO_SSL_DEFAULT_WS_PORT` : Red5 Pro default unsecure websocket port. This is used by the SSL installer to configure the unsecure websocket port value.

* `RED5PRO_SSL_DEFAULT_WSS_PORT` : Red5 Pro default secure websocket port. This is used by the SSL installer to configure the secure websocket port value.


---

## PROGRAM OPTIONS
===

<br>
### INITIALIZATION

As the script runs in the terminal, it detects the operating system details such as Distribution (OS name), Version (OS version), Kernel type (64/32 bit), User's home directory, Red5pro default backup directory (located inside the home directory) and the default install location (the current directory).

The detected information is printed on screen and then the menu which allows you to select a operation mode is rendered. The program supports two modes of operation : 


* Basic Mode: Provides most of the options for new installations.
* Utility Mode: Provides utilities for doing more with the Red5 Pro installation


__You can select a menu option by typing the number that represents that option and pressing [ ENTER ]__


===


### BASIC MODE


The basic mode provides all the options, commonly required to setup a new red5pro installation and other operations such as starting / stopping red5.  The basic menu option allows you to:




#### 1. INSTALL LATEST RED5PRO


Allows you to install Red5pro from red5pro.com website. You must have an existing account on red5pro.com to use this option. Before proceesding, the script checks for a few basic requirements : 

* Java : Java (JRE / JDK 1.8 or greater is required to install Red5pro)
* unzip : Unzip utility is required to unpack zip archives.


Once the requirements are met the script proceeds to 'obtaining the latest Red5pro from Red5pro.com'. At this point, it prompts you for site credentials (email  & password). This information is posted to the website to help authenticate your download. If authentication succeeds, it begins downloading the latest red5pro archive file from red5pro.com. 


__* If an existing script is found, the script tried to stop red5 in case it was running before it can continue.__

__* If there is an existing red5pro installation found at the location, the files will be backed up to the default backup location__


The program then  extracts the archive file's content and copies the red5pro files into the install location.

Depending on whether the softwares are found in the os distribution, the script helps you install them using the platform specific installation method. (ie: Ubuntu uses apt-get, where as CentOS uses yum to install softwares. )

The script prompts to determine if a autostart service is required for the red5pro installation. If user accepts, The program creates a linux startup script for the current OS platform. This script helps red5pro start automatically with operating system.


#### 2. INSTALL RED5PRO FROM URL

This option lets you install Red5pro from a arbitrary Red5 Pro server archive located anywhere on the internet or LAN. In case you have a custom version of Red5 Pro that you wish to install you shoudl use this option. The only thing to remember is that the archive format (folder level in the archives) should be compatible with the installer. 

> Basically the rule of the thumb is that your archive should extract to a single folder containi9ng all the Red5 Pro server files.

The script checks the basic red5pro requirements as with the first option (INSTALL LATEST RED5PRO). Once requirements are met, it prompts you for the full qualified URL of the red5pro server archive (From S3 bucket or dropbox etc). 

The program extracts the archive file's content and copies the red5pro files into the install location. The rest of the process is exactly the same as for the first option (INSTALL LATEST RED5PRO).




#### 3. REMOVE RED5PRO INSTALLATION

This option lets you remove an existing red5pro installation. Removal deletes all the files and removes red5pro startup script if it exists.

On selection of this option, the program looks for existing red5pro installation in the install location. If an installation is found, the user will be prompted to confirm the removal action. If user confirms it (by pressing Y + [ ENTER ] ), the script deletes the red5pro installation as well as any red5pro service installed on the OS.




#### 4. ADD / UPDATE RED5PRO LICENSE

This option navigates to a sub-menu which allows us to view, install and update a red5pro license.


__1. ADD / UPDATE LICENSE :__  Provides option to add a new license or update one if it already exists. The program looks for an existing red5pro installation and then the LICENSE.KEY file at expected location. If a file is found it allows you to enter a red5pro license code from the terminal interface.

__2. VIEW LICENSE :__  Provides option to view an existing red5pro license via the LICENSE.KEY file. The program looks for an existing red5pro installation and then the LICENSE.KEY file at expected location. If a file is found it displays the content of the file on terminal.



#### 5. START RED5PRO

This option allows you to start Red5pro. On selecting this option, the program first checks to see if a Red5pro service is installed on the system or not. If a red5pro service is found, it attempts to start red5 using the service. If no service is found it attempts to start red5 using 'red5.sh' script located at the red5 install location.


#### 6. STOP RED5PRO

This option allows you to stop Red5pro. On selecting this option, the program first checks to see if a Red5pro service is installed on the system or not. If a red5pro service is found, it attempts to stop red5 using the service. If no service is found it attempts to stop red5 using 'red5.sh' script located at the red5 install location.


===


### UTILITY MODE



#### 1. CHECK EXISTING RED5 PRO INSTALLATION

Check the default install location for an existing Red5 Pro installation and displays the version if found.


#### 2. WHICH JAVA AM I USING ?

Selecting this option lets you see the current java version on your system. If java is not found, the program will print a message to notify the same.


#### 3. INSTALL RED5PRO SERVICE

This option lets you install red5 service. On selecting this option, the program first checks to see if red5pro in installed. If red5pro is not installed the operation exits. If red5pro installation is found the program attempts to register it as a service. If red5pro service is already installed on the OS, it prompts the user to overwrite it. If user selects to overwrite (By selecting 'y' + ENTER), the service will be re-installed else the operation exists.


#### 4. UNINSTALL RED5PRO SERVICE

This option lets you uninstall red5 service. On selecting this option, the program first checks to see if red5pro in installed. Next it checks to see if service is installed. If red5pro is not installed the operation exits. If red5pro installation is found the program attempts to unregister it as a service. If red5pro service does not exist on the OS, the operation exits. If service is found it is removed.




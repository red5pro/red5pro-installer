# red5pro installer
Installer for Red5 Pro Server


## INTRODUCTION

The Red5pro installer is a shell script, designed to make Red5pro installation simple and more efficient by automating most of the tasks related to getting a new Red5pro installation running.

The script presents a collection menu driven options to help achieve various red5pro setup tasks. Additionally it also takes care of installing the software dependencies required to get Red5pro working.
## REQUIREMENTS

This script is 'currently' designed to work with specific flavours of linux only. You need to have a linux distribution supported by `Red5Pro` (ex: ubuntu 16.xx or centos 7.x).

The script requires super user privileges to execute and carry out subtasks. Hence you must execute the script as a super user on your linux system (sudo...). 

__NOTE__ : The entire content provided in the 'Linux' directory of this repo is `required`.

## USAGE

**To execute the script :** 
>> Script is located at : `Linux/rpro-utils.sh`
* Copy the script and conf.ini (script configuration file) to a location from where it can be executed such as : `/home/{username}/`.
* Navigate to directory location in the linux terminal (shell)
* Assign executable permissions to the script by issuing the following command in terminal : `sudo chmod +x ./rpro-utils.sh`

##### UBUNTU

* Execute the script by issuing the following command : `sudo ./rpro-utils.sh`

##### CENTOS

**CentOs is currently not supported**

##### SPECIAL NOTE

__On linux you can hit `CTRL + C` in the terminal at anytiem to interrupt/abort a script execution.__

## PROGRAM CONFIGURATION FILE -> CONF.INI

The configuration file `conf.ini` is located in the same location as the program itself. It contains the basic configuration information needed for the installer script to run. Some of the configuration can be changed and some are fixed. Given below is the content of the `conf.ini` file.

```ini
# JAVA REQUIREMENTS
# -------------------
MIN_JAVA_VERSION="1.8"


# JAVA DOWNLOAD LOCATIONS FOR CENTOS (Deprecated)
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
RED5PRO_LOG_FILE_NAME=rpro_installer.log
RED5PRO_LOGGING=true

# CUSTOM URL LOCATION
# ---------------------------------------
RED5PRO_DOWNLOAD_URL=

# INSTALLER CLEANUP
# ---------------------------------------
RED5PRO_INSTALLER_OPERATIONS_CLEANUP=1

# MINIMUM PERCENTAGE OF SYSTEM MEMORY TO ALLOCATE TO JVM
# ---------------------------------------
RED5PRO_MEMORY_PCT=80

# INSTALL RED5PRO AS SERVICE BY DEFAULT
# ---------------------------------------
RED5PRO_INSTALL_AS_SERVICE=true

# SERVICE TYPE [ init.d (1) or jsvc (2)
# ---------------------------------------
RED5PRO_SERVICE_VERSION=2


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

* `MIN_JAVA_VERSION`: Minimim version of java (JRE/JDK) that is required by the installer to install Red5pro on the system. This value should not be changed by the user.
* `JAVA_JRE_DOWNLOAD_URL`: Base url of the latest rpm package(s) required for java installation on CentOs. This value should not be changed by the user.This attribute is deprecated.
* `JAVA_32_FILENAME`: Filename of the 32 bit java rpm package for CentOs .This attribute is deprecated.
* `JAVA_64_FILENAME`: Filename of the 64 bit java rpm package for CentOs.This attribute is deprecated.
* `DEFAULT_BACKUP_FOLDER`: Filepath of the Red5 Pro backup directory (if there is an existing Red5 Pro installation that is being upgraded; default is `red5pro_backups`)
* `DEFAULT_RPRO_INSTALL_LOCATION`: Red5 Pro install directory path (default is `/usr/local`)
* `DEFAULT_RPRO_FOLDER_NAME`: Name of the Red5 Pro folder (default is `red5pro`)
* `RED5PRO_LOG_FILE_NAME`: Name of installer log file. Defaults to `rpro_installer.log`.
* `RED5PRO_LOGGING`: Boolean flag to enable or disable logging. Defaults to `true`
* `RED5PRO_DOWNLOAD_URL`: Custom Red5 Pro archive URL for installation (must be modified with the download URL of your server if you choose that installation option)
* `RED5PRO_INSTALLER_OPERATIONS_CLEANUP`: Choose whether or not to remove the downloaded Red5 Pro zip file after installation is finished. Set to `1` to remove the zipfile and `0` to leave it in place. (Default value is `1`).
* `RED5PRO_INSTALL_AS_SERVICE` : Determines whether the installation process of Red5 Pro is followed by Red5 Pro service installation automatically by default or not. Setting the value to `false` disables service installation prompt during normal Red5 Pro installation. Defaults to `true`.
* `RED5PRO_MEMORY_PCT`: How much (percentage) of system memory to allocate for JVM to Run Red5 Pro. Defaults to `80`.
* `RED5PRO_SERVICE_VERSION`: The default installation will set up Red5 Pro service using `systemctl` (option `2`). If you prefer to use the older method (`/etc/init.d`) change this value to `1`.
* `RED5PRO_SSL_LETSENCRYPT_FOLDER_NAME` : The Letsencrypt SSL installer directory name. This is created in the installer directory.
* `RED5PRO_SSL_LETSENCRYPT_GIT`: Letsencrypt SSL installer GIT repo URL
* `RED5PRO_SSL_LETSENCRYPT_EXECUTABLE`: The Letsencrypt SSL installer executable 
* `RED5PRO_SSL_DEFAULT_HTTP_PORT`: Red5 Pro default HTTP port. This is used by the SSL installer to configure the HTTP port value (`5080` is the default)
* `RED5PRO_SSL_DEFAULT_HTTPS_PORT`: Red5 Pro default HTTPS port. This is used by the SSL installer to configure the HTTPS port value (`443` is the default)
* `RED5PRO_SSL_DEFAULT_WS_PORT`: Red5 Pro default unsecure websocket port. This is used by the SSL installer to configure the unsecure websocket port value (`8081` is the default).
* `RED5PRO_SSL_DEFAULT_WSS_PORT`: Red5 Pro default secure websocket port. This is used by the SSL installer to configure the secure websocket port value (`8083` is the default).


## PROGRAM OPTIONS

### INITIALIZATION

As the script runs in the terminal, it detects the operating system details such as Distribution (OS name), Version (OS version), Kernel type (64/32 bit), User's home directory, Red5pro default backup directory (located inside the home directory) and the default install location (the current directory).

The detected information is printed on screen and then the menu which allows you to select a operation mode is rendered. The program supports two modes of operation : 

* Basic Mode: Provides most of the options for new installations.
* Utility Mode: Provides utilities for doing more with the Red5 Pro installation

__You can select a menu option by typing the number that represents that option and pressing [ ENTER ]__

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

Depending on whether the softwares are found in the os distribution, the script helps you install them using the platform specific installation method. (ie: Ubuntu uses apt-get, where as CentOS uses yum to install softwares.

The script prompts to determine if a autostart service is required for the red5pro installation. If user accepts, The program creates a linux startup script for the current OS platform. This script helps red5pro start automatically with operating system.

#### 2. INSTALL RED5PRO FROM URL

This option lets you install Red5pro from a arbitrary Red5 Pro server archive located anywhere on the internet or LAN. In case you have a custom version of Red5 Pro that you wish to install you shoudl use this option. The only thing to rememberr is that the archive content structure should be match the one provided on Red5Pro.com.

As long as the archive structure matches, you can host the file anywhere on the internet. This feature is specifically useful when installing pre-customized Red5 Pro distributions.

The script checks the basic red5pro requirements as with the first option (INSTALL LATEST RED5PRO). Once requirements are met, it prompts you for the full qualified URL of the red5pro server archive (From S3 bucket or dropbox etc). 

The program extracts the archive file's content and copies the red5pro files into the install location. The rest of the process is exactly the same as for the first option (INSTALL LATEST RED5PRO).

#### 3. REMOVE RED5PRO INSTALLATION

This option lets you remove an existing red5pro installation. Removal deletes all the files and removes red5pro service (if it exists).

On selection of this option, the program looks for existing red5pro installation in the install location. If an installation is found, the user will be prompted to confirm the removal action. If user confirms it (by pressing Y + [ ENTER ] ), the script deletes the red5pro installation as well as any red5pro service installed on the OS.

#### 4. ADD / UPDATE RED5PRO LICENSE

This option navigates to a sub-menu which allows us to view, install and update a red5pro license.

__1. ADD / UPDATE LICENSE :__  Provides option to add a new license or update one if it already exists. The program looks for an existing red5pro installation and then the LICENSE.KEY file at expected location. If a file is found it allows you to enter a red5pro license code from the terminal interface.

__2. VIEW LICENSE :__  Provides option to view an existing red5pro license via the LICENSE.KEY file. The program looks for an existing red5pro installation and then the LICENSE.KEY file at expected location. If a file is found it displays the content of the file on terminal.

#### 5. SSL CERT INSTALLER (Letsencrypt)

This option allows you to install a free SSL certificate (Obtained via letsencrypt CA), on your Red5 Pro instance. Prior to using this option you need to make sure you have a valid DNS name that points to your instance.

#### 6. START RED5PRO

This option allows you to start Red5pro. On selecting this option, the program first checks to see if a Red5pro service is installed on the system or not. If a red5pro service is found, it attempts to start red5 using the service. If no service is found it attempts to start red5 using 'red5.sh' script located at the red5 install location.

#### 7. STOP RED5PRO

This option allows you to stop Red5pro. On selecting this option, the program first checks to see if a Red5pro service is installed on the system or not. If a red5pro service is found, it attempts to stop red5 using the service. If no service is found it attempts to stop red5 using 'red5.sh' script located at the red5 install location.

#### 8. RESTART RED5PRO

This option allows you to restart Red5pro.This option is available only if you Red56 Pro is installed as a service.

#### 9. INSTALL AS SERVICE OR REMOVE SERVICE

This option allows you to install or uninstall Red5 Pro service. If Red5 Pro service was registered during installation, the option is labeled as `REMOVE SERVICE`, otherwise as `INSTALL AS SERVICE`.


### UTILITY MODE

#### 1. CHECK EXISTING RED5 PRO INSTALLATION

Check the default install location for an existing Red5 Pro installation and displays the version if found.

#### 2. WHICH JAVA AM I USING ?

Selecting this option lets you see the current java version on your system. If java is not found, the program will print a message to notify the same.

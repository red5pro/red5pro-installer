# Red5pro installer
Installer for Red5 Pro Server

> **NOTE**: As of Red5 Pro release 12.0, the installer can only be run on Ubuntu. If you have a downloaded server distribution version older than 12.0, then it can be run on Ubuntu 16.04, 18.04 or 20.04; for version 12.0 or higher please choose Ubuntu 22.04


## INTRODUCTION

The Red5 Pro installer is a shell script that will install a single server Red5 Pro instance.
The script presents a collection of menu-driven options to help achieve various Red5 Pro setup tasks including SSL certificate via Letsencrypt, adding/changing license key, and managing the red5pro service. You may also check your Red5 Pro installation and verify which version of Java you are running.

## REQUIREMENTS

As of release 12.0, `Red5Pro Server` requires Ubuntu 22.04.

__NOTE 1__ : The entire content provided in the 'installer' directory of this repo is `required`.

__NOTE 2__ : This installer cannot be used to deploy more than one installation of Red5 Pro on the same instance. To install a new distribution you need to uninstall the previous one.


## USAGE

From your server's command line enter the following commands:

1. `git clone https://github.com/red5pro/red5pro-installer`
2. `cd red5pro-installer`
3. `sudo chmod +x *.sh`
4. `sudo ./red5proInstaller.sh`

> `sudo` is required to initialize your script as a superuser. This may not be required on systems where you are logged in as `root`(superuser).

You are now running the installer!

* Press 1 then Enter to open the installer menu.
* Press 1 then Enter again to install the latest red5pro build.
* (Press 2 if you have a custom build of red5pro)

> On linux you can hit `CTRL + C` in the terminal anytime to interrupt/abort a script execution.

### INITIALIZATION

As the script runs in the terminal, it detects the operating system details such as Distribution (OS name), Version (OS version), Kernel type (64/32 bit), User's home directory, Red5pro default backup directory (located inside the home directory) and the default install location (the current directory).

The detected information is printed on screen and then the menu which allows you to select an operation mode is rendered. The program supports two modes of operation:

* Basic Mode: Provides most of the options for new installations.
* Utility Mode: Provides utilities for doing more with the Red5 Pro installation

__You can select a menu option by typing the number that represents that option and pressing [ ENTER ]__

### BASIC MODE

The basic mode provides all the options commonly required to setup a new Red5 Pro installation and other operations such as starting / stopping the red5pro service.  The basic menu option allows you to:

#### 1. INSTALL LATEST RED5PRO

Allows you to install Red5 Pro from the [https://www.red5.net](https://www.red5.net) website. You must have an existing account on red5.net to use this option. Before proceeding, the script checks for a few basic requirements:

* Java: Java (JRE / JDK 1.8 is required to install Red5pro)
* unzip: Unzip utility is required to unpack zip archives.

Once the requirements are met the script proceeds to 'obtaining the latest Red5pro from red5.net'. At this point, it prompts you for site credentials (email  & password). This information is posted to the website to help authenticate your download. If authentication succeeds, it begins downloading the latest Red5 Pro archive file from red5.net.

__* If an existing script is found, the script tries to stop Red5 Pro, in case it was running, before it can continue.__

__* If there is an existing Red5 Pro installation found at the location, the files will be backed up to the default backup location__

The program then extracts the archive file's content and copies the Red5 Pro files into the install location.

Depending on whether the libraries are found in the OS distribution, the script helps you install them using the platform specific installation method. (ie: Ubuntu uses apt-get, where as CentOS uses yum to install libraries).

The script prompts to determine if an autostart service is required for the Red5 Pro installation. If user accepts, The program creates a startup script for the current OS platform. This script helps Red5 Pro start automatically with the operating system.

[![Installing Red5 Pro from site](https://img.youtube.com/vi/WcHQWRbFpII/0.jpg)](https://www.youtube.com/watch?v=WcHQWRbFpII)

**ScreenCast**

#### 2. INSTALL RED5PRO FROM URL

This option lets you install Red5 Pro from an arbitrary Red5 Pro server archive located anywhere on the internet or LAN. In case you have a custom version of Red5 Pro that you wish to install you should use this option. As long as the archive structure matches, you can host the file anywhere on the internet. This feature is specifically useful when installing pre-customized Red5 Pro builds.

Here, the script checks the basic Red5 Pro requirements as with the first option (INSTALL LATEST RED5PRO). Once requirements are met, it prompts you for the fully qualified URL of the Red5 Pro server archive (From S3 bucket or dropbox etc). Please verify that the file is publicly accessible. You MUST link DIRECTLY to the archive, not to a directory containing it.

Custom archives should be in one of two forms:

* Single level archive: An archive created from inside the `red5pro` root directory, by selecting/adding all the files to archive. ie `{archive.zip} => red5.sh`.

* Two level archive: An archive created from outside the `red5pro` root directory matching the archive structure that is available from red5pro.com.ie `{archive.zip} => {red5profolder} => red5.sh`.

The program extracts the archive file's content and copies the Red5 Pro Server files into the install location. The rest of the process is exactly the same as for the first option (INSTALL LATEST RED5PRO).

[![Installing Red5 Pro from custom url](https://img.youtube.com/vi/GKagGx9k6zs/0.jpg)](https://www.youtube.com/watch?v=GKagGx9k6zs)

**ScreenCast**

#### 3. REMOVE RED5PRO INSTALLATION

This option lets you remove an existing Red5 Pro installation. Removal deletes all the files and removes the red5pro service (if it exists).

On selection of this option, the program looks for existing Red5 Pro installation in the install location. If an installation is found, the user will be prompted to confirm the removal action. If user confirms it (by pressing Y + [ ENTER ] ), the script deletes the red5pro installation as well as any red5pro service installed on the OS.

[![Removing Red5 Pro](https://img.youtube.com/vi/7DF7ek84QgE/0.jpg)](https://www.youtube.com/watch?v=7DF7ek84QgE)

**ScreenCast**

#### 4. ADD / UPDATE RED5PRO LICENSE

This option navigates to a sub-menu which allows us to view, install and update a Red5 Pro license.

__1. ADD / UPDATE LICENSE :__  Provides option to add a new license or update one if it already exists. The program looks for an existing Red5 Pro Server installation and then the LICENSE.KEY file at expected location. If a file is found it allows you to enter a red5pro license code from the terminal interface.

__2. VIEW LICENSE :__  Provides option to view an existing Red5 Pro Server license via the LICENSE.KEY file. The program looks for an existing Red5 Pro Server installation and then the LICENSE.KEY file at expected location. If a file is found it displays the content of the file on terminal.


[![Updating / Viewing License](https://img.youtube.com/vi/4qxP8BOd3LA/0.jpg)](https://www.youtube.com/watch?v=4qxP8BOd3LA)

**ScreenCast**

#### 5. SSL CERT INSTALLER (Letsencrypt)

This option allows you to install a free SSL certificate (Obtained via letsencrypt CA), on your Red5 Pro instance. Prior to using this option you need to make sure you have a valid DNS name that points to your instance.

The installer script uses the [Red5 Pro SSL page](https://www.red5.net/docs/installation/ssl/overview/) as guide to create a SSL installation automation.

> Installer supports newer builds (>=5.4.0 and onwards) as well as older builds (<=5.3.x) by checking for websocket implementation using the presence of the `websocket-x.x.x.jar` file in the plugins directory. New websocket implementation uses websockets classes from the tomcat plugin and the `websocket-x.x.x.jar` is no longer present in the newer builds.

**Prerequisites for SSL Installation:**

* `Domain Name`: You should have a valid domain / subdomain name for which the SSL certificate is to be requested.
* `DNS A record`: You should have a valid DNS type `A` record created for your domain management panel, that maps the public IP of the instance where Red5 Pro is running to the domain / subdomain name.
* `Port Allowance`: Standard SSL port (443) as well as http port (80) must be open for the certificate generation to be successful.

[![Letsencrypt SSL Installation](https://img.youtube.com/vi/9vCRvr4HRM4/0.jpg)](https://www.youtube.com/watch?v=9vCRvr4HRM4)

**ScreenCast**

#### 6. START RED5PRO

This option allows you to start the Red5 Pro Server. On selecting this option, the program first checks to see if a red5pro service is installed on the system or not. If a red5pro service is found, it attempts to start Red5 Pro Server using the service. If no service was installed it attempts to start the Red5 Pro Server using 'red5.sh' script located at the Red5 Pro Server install location.

[![Letsencrypt SSL Installation](https://img.youtube.com/vi/0Rjir1xiiv8/0.jpg)](https://www.youtube.com/watch?v=0Rjir1xiiv8)

**ScreenCast**

#### 7. STOP RED5PRO

This option allows you to stop the Red5 Pro Server. On selecting this option, the program first checks to see if a red5pro service is installed on the system or not. If a red5pro service is found, it attempts to stop the Red5 Pro Server using the service. If no service was installed it attempts to stop Red5 Pro using 'red5.sh' script located at the Red5 Pro Server install location.

[![Letsencrypt SSL Installation](https://img.youtube.com/vi/_Lanh0K-NUM/0.jpg)](https://www.youtube.com/watch?v=_Lanh0K-NUM)

**ScreenCast**

#### 8. RESTART RED5PRO

This option allows you to restart the Red5 Pro Server.This option is available only if Red5 Pro is installed as a service.

#### 9. INSTALL SERVICE OR REMOVE SERVICE

This option allows you to install or uninstall Red5 Pro service. If Red5 Pro service was registered during installation, the option displays `REMOVE SERVICE`, otherwise as `INSTALL AS SERVICE`. Selecting `REMOVE SERVICE` will remove the installed red5pro service, whereas selecting `INSTALL SERVICE` will install the red5pro service.

---

### UTILITY MODE

#### 1. CHECK EXISTING RED5 PRO INSTALLATION

Check the default install location for an existing Red5 Pro Server installation and displays the version if found.

#### 2. WHICH JAVA AM I USING ?

Selecting this option lets you see the current java version on your system. If java is not found, the program will print a message to notify the same.

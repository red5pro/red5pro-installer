#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------

alias cls='printf "\033c"'
DEFAULT_RPRO_PATH=/usr/local/red5pro
SERVICE_LOCATION=/etc/init.d
SERVICE_NAME=red5pro 
SERVICE_INSTALLER=/usr/sbin/update-rc.d
MODE=0




main()
{
	
	welcome_menu
	read_welcome_menu_options
}





pause()
{

	printf "\n"
	read -r -p 'Press any [ Enter ] key to continue...' key

	echo $MODE

	if [ "$MODE" -eq  1 ]; then
 	show_advance_menu
	else
 	show_simple_menu
	fi
}




pause_license()
{

	printf "\n"
	read -r -p 'Press any [ Enter ] key to continue...' key

	show_licence_menu
}











check_java()
{
	java_check_success=0

	for JAVA in "${JAVA_HOME}/bin/java" "${JAVA_HOME}/Home/bin/java" "/usr/bin/java" "/usr/local/bin/java"
		do
			if [ -x "$JAVA" ]
			then
			break
		fi
	done


	if [ ! -x "$JAVA" ]; then
	  	echo "Unable to locate Java. Please set JAVA_HOME environment variable."
	else
		JAVA_VER=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
		JAVA_VERSION=`echo "$(java -version 2>&1)" | grep "java version" | awk '{ print substr($3, 2, length($3)-2); }'`

		java_version_into="Your current java version is $JAVA_VERSION"

		if [ "$JAVA_VER" -ge 17 ]; then
		java_check_success=1
		echo "$java_version_into , which meets Red5pro requirements."
		else
		java_check_success=0
		echo "java_version_into , which is too old..."
		fi
	fi


	if [ $# -gt 0 ]; then
		pause		
	fi
}




check_unzip()
{
	unzip_check_success=0

	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unzip|grep "install ok installed")

	if [ -z "$PKG_OK" ]; then
	unzip_check_success=1
	echo "Unzip utility found."
	else
	unzip_check_success=0
	echo "Unzip utility was found"		
	fi
}



install_java()
{
	apt-get update
	apt-get install default-jre

	default_jre="$(which java)";
	echo "JRE installed at $default_jre"	
}



install_unzip()
{
	apt-get update
	apt-get install unzip

	install_unzip="$(which unzip)";
	echo "Unzip installed at $install_unzip"
}



add_update_java()
{
	install_java
}




download_latest()
{
	clear

	latest_rpro_download_success=0
	rpro_zip=""

	echo "Downloading latest Red5pro from red5pro.com"
	
	# create tmp directory
	dir=`sudo mktemp -d` && cd $dir

	cd $dir

	# echo $dir

	echo "Please enter your red5pro.com login details"
	
	echo "Enter Email : "
	read rpro_email

	echo "Enter Password : "
	read rpro_passcode
	# read -s rpro_passcode

	# TODO => simple validate

	wget --save-cookies cookies.txt --keep-session-cookies --post-data="email=$rpro_email&password=$rpro_passcode" "https://account.red5pro.com/login"	
	wget --load-cookies cookies.txt --content-disposition -p  https://account.red5pro.com/download/red5

	rpro_zip=""
	search_dir="$dir/account.red5pro.com/download"
	for file in $search_dir/*.zip
	do
		rpro_zip="${file%%.zip}"
		latest_rpro_download_success=1
		break	
	done

	
	rpro_zip="${rpro_zip}.zip"
	# echo $rpro_zip
	# sleep 15
	
}



auto_install_rpro()
{

	# Checking java
	echo "Checking java requirements"
	sleep 2
	check_java

	
	if [ "$java_check_success" -eq 0 ]; then
		echo "Installing latest java runtime environment..."
		sleep 2

		install_java
	fi 


	# Checking unzip
	echo "Checking other requirements"
	sleep 2
	check_unzip

	if [ "$unzip_check_success" -eq 0 ]; then
		echo "Installing latest java runtiem environment..."
		sleep 2

		install_unzip
	fi 


	# Download red5 zip from red5pro.com
	echo "Preparing to install Red5Pro from Red5pro.com"
	sleep 2
	download_latest

	if [ "$latest_rpro_download_success" -eq 0 ]; then
		echo "Failed to download latest Red5pro distribution from Red5pro.com. Please contact support!"
		pause
	fi


	if [ -z "$rpro_zip" ]; then
		echo "Downloaded file could not be found or is invalid. Exiting now!"
		pause
	fi


        # echo $rpro_zip
	# sleep 15


	# Installing red5 from zip downloaded  from red5pro.com

	echo "Installing Red5Pro"
	sleep 2
	install_rpro_zip $rpro_zip

	if [ "$red5_zip_install_success" -eq 0 ]; then
		echo "Failed to install Red5pro distribution. Something went wrong!! Try again or contact support!"
		pause
	fi
	
}



install_from_url()
{
	if [ $# -eq 0 ]; then
		echo "Enter accessible url of Red5pro zip"	
		read rpro_url
	else
		rpro_url=$1
	fi
	

	url_rpro_download_success=0
	echo "Attempting to download Red5pro zip from $rpro_url"
	

	# create tmp directory
	dir=`sudo mktemp -d` && cd $dir
	cd $dir


	# Pull zip from url
	wget -O $dir/rpro.zip -p --content-disposition -p  $rpro_url



	if [ -f "$dir/rpro.zip" ]; then
		url_rpro_download_success=1
		install_rpro_zip "$dir/rpro.zip"
	else
		echo "Problem downloading Red5pro from $rpro_url"
		pause
	fi	
}




register_rpro_as_service()
{
	check_current_rpro 1

	if [ "$rpro_exists" -eq 1 ]; then


		if [ -f "$SERVICE_LOCATION/$SERVICE_NAME" ]; then
		echo "Service already exists. Do you wish to re-install ?" 
		read -r -p "Are you sure? [y/N] " response

		case $response in
		[yY][eE][sS]|[yY]) 
		register_rpro_service
		;;
		*)
		echo "Install cancelled"
		;;
		esac

		else
		register_rpro_service
		fi
	fi

	pause
}



unregister_rpro_as_service()
{
	check_current_rpro 0

	if [ "$rpro_exists" -eq 1 ]; then

		if [ ! -f "$SERVICE_LOCATION/$SERVICE_NAME" ]; then
			echo "Service does not exists. Nothing to remove" 
		else
			unregister_rpro_service
		fi

	fi

	pause
}




install_rpro_zip()
{
	red5_zip_install_success=0

			
	clear
	echo "Installing red5pro from zip"

	if [ $# -eq 0 ]; then
		echo "Enter the full path to Red5pro zip"
		read rpro_zip_path
	else 
		rpro_zip_path=$1
	fi
	

	if [ ! -f "$rpro_zip_path" ]; then
		echo "Invalid archive file path $rpro_zip_path"
		pause;
	fi


	filename=$(basename "$rpro_zip_path")
	extension="${filename##*.}"
	filename="${filename%.*}"


	case "$extension" in 
	zip|tar|gz*) 
	    # All ok
	    ;;	
	*)
	    echo "Invalid archive type $extension"
	    pause
	    ;;
	esac
	


	echo "Attempting to install red5pro from zip"
	dir=`mktemp -d` && cd $dir
	unzip_dest="$dir/$filename"


	check_current_rpro 1
	
	if [ "$rpro_exists" -eq 1 ]; then
	
		echo "Seems like an existing Red5pro installation was found. If you continue this will be replaced"
		sleep 1
		echo "Warning! All file(s) and folder(s) at $DEFAULT_RPRO_PATH will be removed permanently"
		read -r -p "Are you sure? [y/N] " response

		case $response in
		[yY][eE][sS]|[yY]) 
		# remove rpro service
		unregister_rpro_service
		# check remove folder
		rm -rf $DEFAULT_RPRO_PATH
		;;
		*)
		echo "Uninstall cancelled"
		pause
		;;
		esac
	fi


		
	echo "Unpacking archive to install location -------"
	
	if ! unzip $rpro_zip_path -d $unzip_dest; then
		echo "Failed to extract zip. Possible invalid archive"
		pause;
	fi


	if [ ! -d "$unzip_dest" ]; then
		echo "Could not create output directory."
		pause;
	fi


	# Move to actual install location 
	rpro_loc=$DEFAULT_RPRO_PATH
	mv -v $unzip_dest/* $rpro_loc

	# DEFAULT_RPRO_PATH=/usr/local/red5pro

	echo "Setting permissions -----------"
	sleep 1

	chmod 755 $rpro_loc
	
	chmod +x $rpro_loc/red5.sh

	chmod +x $rpro_loc/red5-shutdown.sh


	# set path
	echo "Setting RED5_HOME"
	sleep 1
	export RED5_HOME=$rpro
 

	# clear tmp directories - IMPORTANT
	echo "cleaning up ----"
	sleep 1

	rm -rf $dir
	rm -rf $unzip_dest

	sleep 1	

	if [ ! -d "$rpro_loc" ]; then
		echo "Could not install Red5pro at $rpro_loc"
	else
		echo "All done! ----"
		echo "Red5pro installed at  $rpro_loc"
		red5_zip_install_success=1
	fi


	# Installing red5 service
	echo "For Red5pro to autostart with operating system, it needs to be registered as a service"
	read -r -p "Do you want to register Red5pro service now? [y/N] " response

	case $response in
	[yY][eE][sS]|[yY]) 
		
		echo "Registering Red5pro as a service"
		sleep 2
		register_rpro_service
		
		if [ "$rpro_service_install_success" -eq 0 ]; then
		echo "Failed to register Red5pro service. Something went wrong!! Try again or contact support!"
		pause
		fi
	;;
	*)
	;;
	esac

	
	# All Done
	echo "Red5pro service is now installed on your system. You can start / stop it with from the menu".
	pause;
	

}



register_rpro_service()
{

	rpro_service_install_success=0

	echo "Preparing to install service..."
	sleep 2


#######################################################

service_script="#!/bin/sh
### BEGIN INIT INFO
# chkconfig: 2345 85 85
# description: Red5 Pro streaming server
# Provides:          Red5 Pro
# Required-Start:    \$local_fs \$network
# Required-Stop:     \$local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Red5Pro
# processname: red5
### END INIT INFO

PROG=red5
RED5_HOME=/usr/local/red5pro 
DAEMON=\$RED5_HOME/\$PROG.sh
PIDFILE=/var/run/\$PROG.pid

start() {
  echo \"Starting Red5pro..\"
  # check to see if the server is already running
  if netstat -an | grep ':5080' > /dev/null 2>&1 ; then
    echo \"Red5 is already started...\"
    while netstat -an | grep ':5080' > /dev/null 2>&1 ; do
      # wait 5 seconds and test again
      sleep 5
    done
  fi
  cd \${RED5_HOME} && ./red5.sh > /dev/null 2>&1 &
}

stop() {
  cd \${RED5_HOME} && ./red5-shutdown.sh > /dev/null 2>&1 &
  echo \"Shutting down Red5pro... It may take upto 30 seconds for shutdown to complete...\"
}


case \"\$1\" in
  start)
    start
    exit 1
  ;;
  stop)
    stop
    exit 1
  ;;
  restart)
    stop
    start
    exit 1
  ;;
  **)
    echo \"Usage: \$0 {start|stop|restart}\" 1>&2
    exit 1
  ;;

esac"

#######################################################

	echo "Writing service script"
	sleep 1

	touch $SERVICE_LOCATION/$SERVICE_NAME

	# write script to file
	echo "$service_script" > /etc/init.d/red5pro

	# make service file executable
	chmod +x $SERVICE_LOCATION/$SERVICE_NAME


	echo "Registering service \"$SERVICE_NAME\""
	sleep 1

	$SERVICE_INSTALLER $SERVICE_NAME -f defaults

	echo "Enabling service \"$SERVICE_NAME\""
	sleep 1

	$SERVICE_INSTALLER $SERVICE_NAME enable


	echo "Red5Pro service installed successfully!"
	rpro_service_install_success=1
}





unregister_rpro_service()
{
	rpro_service_remove_success=0
	
	prog="red5"

	echo "Preparing to remove service..."
	sleep 2


	if [ -f "$SERVICE_LOCATION/$SERVICE_NAME" ];	then
	

		# 1. Terminate service if running

		# 2. check PID file and check pid
		

		echo "Disabling service \"$SERVICE_NAME\""
		sleep 1

		update-rc.d $SERVICE_NAME disable

		echo "Removing service \"$SERVICE_NAME\""
		sleep 1

		update-rc.d $SERVICE_NAME remove

		rm $SERVICE_LOCATION/$SERVICE_NAME

		echo "Service removed successfully"
		rpro_service_remove_success=0
	
	else
		echo "Red5pro service was not found"
	fi
}





start_red5pro_service()
{

	if [ ! -f "$SERVICE_LOCATION/$SERVICE_NAME" ];	then
		echo "It seems Red5Pro service was not installed. Please register Red5pro service from the menu for best results."
		echo " Attempting to start using \"red5.sh\""
		exec $DEFAULT_RPRO_PATH/red5.sh &
	else
		echo "Red5Pro service was found at $SERVICE_LOCATION/$SERVICE_NAME"
		echo " Attempting to start service"
		"$SERVICE_LOCATION/$SERVICE_NAME" start /dev/null 2>&1 &
	fi

	pause
}



# needs repair

stop_red5pro_service()
{
	$proc="red5"

	if [ ! -f "$SERVICE_LOCATION/$SERVICE_NAME" ];	then
		echo "It seems Red5Pro service was not installed. Please register Red5pro service from the menu for best results."
		echo " Attempting to start using \"red5-shutdown.sh\""

		exec $DEFAULT_RPRO_PATH/red5-shutdown.sh /dev/null 2>&1 &
	else
		echo "Red5Pro service was found at $SERVICE_LOCATION/$SERVICE_NAME."
		echo " Attempting to stop service"

		"$SERVICE_LOCATION/$SERVICE_NAME" stop /dev/null 2>&1 &
	fi

	pause
}





is_red5_running()
{	
    PIDFILE="/var/run/red5.pid"
}




remove_rpro_installation()
{
	echo "Looking for Red5Pro at default location..."
	sleep 2

	if [ ! -d $DEFAULT_RPRO_PATH ]; then
  		echo "No Red5pro installation found at default location : $DEFAULT_RPRO_PATH"
	else
		red5pro_ini="$DEFAULT_RPRO_PATH/conf/red5.ini" 

		if [ ! -f $red5pro_ini ]; then
		echo "There were files found at default location : $DEFAULT_RPRO_PATH, but the installation might be broken !. I could not locate version information"
		else
		echo "Red5pro installation found at default location : $DEFAULT_RPRO_PATH"
		echo "Warning! All file(s) and folder(s) at $DEFAULT_RPRO_PATH will be removed permanently"
		read -r -p "Are you sure? [y/N] " response

		case $response in
		[yY][eE][sS]|[yY]) 
		# remove rpro service
		unregister_rpro_service
		# check remove folder
		rm -rf $DEFAULT_RPRO_PATH
		unset RED5_HOME
		if [ ! -d "$DEFAULT_RPRO_PATH" ]; then
			echo "Red5 installation ws removed"
		fi
		;;
		*)
		echo "Uninstall cancelled"
		;;
		esac
		fi
	fi


	if [ $# -eq 0 ]; then
		pause		
	fi

	
}






check_current_rpro()
{
	rpro_exists=0
	echo "Looking for Red5Pro at default location..."
	sleep 2

	if [ ! -d $DEFAULT_RPRO_PATH ]; then
  		echo "No Red5pro installation found at default location : $DEFAULT_RPRO_PATH"
	else
		red5pro_ini="$DEFAULT_RPRO_PATH/conf/red5.ini" 

		if [ ! -f $red5pro_ini ]; then
		echo "There were files found at default location : $DEFAULT_RPRO_PATH, but the installation might be broken !. I could not locate version information"
		rpro_exists=1
		else
		rpro_exists=1
		echo "Red5pro installation found at default location : $DEFAULT_RPRO_PATH"

		pattern='server.version*'
		replace=""
		while IFS= read line
		do
			case "$line" in
			$pattern) echo "Red5pro build info :" $line | sed -e "s/server.version=/${replace}/g";;
			*) continue ;;
			esac
		
		done <"$red5pro_ini"

		fi
	fi

	if [ $# -eq 0 ]; then
		pause		
	fi
}





check_license()
{
	if [ $1 -eq 1]; then
		echo "Enter the full path to Red5pro installation"
		read rpro_path
	else
		rpro_path=$DEFAULT_RPRO_PATH
	fi



	lic_file=$rpro_path/LICENSE.KEY

	if [ ! -f $lic_file ]; then
  		echo "No license file found!. Please install a license."
	else
		value=`cat $lic_file`
		echo "Current license : $value"
	fi
	
	pause_license;	
}




set_update_license()
{

	if [ $1 -eq 1 ]; then
		echo "Enter the full path to Red5pro installation"
		read rpro_path
	else
		rpro_path=$DEFAULT_RPRO_PATH
	fi
	

	lic_file=$rpro_path/LICENSE.KEY
	lic_new=1

	if [ ! -f $lic_file ]; then
  		echo "Installing license code : Please enter new license code and press [ Enter ]."
		if [ ! -f "$lic_file" ] ; then
         		# if not create the file
         		touch "$lic_file"
	     	fi
	else
		lic_new=0
		cat $lic_file | while read line
		do
		echo "a line: $line"
		done
		echo "Updating license : Please enter new license code and press [ Enter ]."
	fi

	read license_code

	license_code=$(echo $license_code | tr '[a-z]' '[A-Z]')
	printf $license_code > $lic_file;

	if [ $lic_new -eq 1 ]; then
	echo "license installed"
	else
	echo "License updated"
	fi
	
	pause_license;	
}



set_red5_home()
{
	echo "TO DO"
}



prepare_autoscale_image()
{


echo "Preparing to configure autoscaling image"
sleep 1

echo "This process will convert your current Red5pro installation to a autoscale image compatible installation."
echo "WARNING : The process caanot be reversed!"

read -r -p "Do you wish to continue? [y/N] " response

case $response in
[yY][eE][sS]|[yY]) 
break;
;;
*)
echo "Process cancelled"
pause
;;
esac



echo "[ ----------------------------------------------------------------------- ]"
echo "[ -----------  STEP #1 : PREPARING AUTOSCALE CONFIGURATION  ------------- ]"
echo "[ ----------------------------------------------------------------------- ]"
echo "\n"


echo "Enter streammanager Host / IP. \n[ For load balanced streammanagers provide load balancer IP instead ]"
read sm_ip

echo "Enter red5pro instance reporting speed \n[ How fast should Red5pro instance report statistics to streammanager. Defaults to '10000'(ms) ]"
read sm_report_speed

autoscale_xml='<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:lang="http://www.springframework.org/schema/lang"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd 
	http://www.springframework.org/schema/lang http://www.springframework.org/schema/lang/spring-lang-3.0.xsd 
	http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd">

    <bean name="config" class="com.red5pro.clustering.autoscale.Configuration" >	
        <!-- Disable plugin -->	
        <property name="active" value="true"/> 
        
        <!--Stream manager hosted uri. use the host of your stream manager.  -->	
	 	<property name="cloudWatchHost" value="http://'$sm_ip':5080/streammanager/cloudwatch"/>
	 	
	 	<!-- Value in milliseconds for interval to report back to cloudwatch. 
	 	5000 to 30000 are acceptable values. 
	 	Lower is more agressive. -->
	 	<property name="reportingSpeed" value="'$sm_report_speed'"/>
    </bean>
     
</beans>'


	echo "Writing configuration to disk"
	sleep 1


	# write script to file
	echo "$autoscale_xml" > $DEFAULT_RPRO_PATH/conf/autoscale.xml
	

	echo "Autoscale configuration written to disk"
	echo "Step # 1 compled successfully"



echo "[ ------------------------------------------------------------------- ]"
echo "[ ----------  STEP #2 : REMOVING UNWANTED APPLICATIONS   ------------ ]"
echo "[ ------------------------------------------------------------------- ]"
echo "\n"


echo "Please wait..."
sleep 2



if [ -d "$DEFAULT_RPRO_PATH/webapps/secondscreen" ]; then
	echo "Deleting webapp secondscreen"
	sleep 1
	rm -rf $DEFAULT_RPRO_PATH/webapps/secondscreen
fi



if [ -d "$DEFAULT_RPRO_PATH/webapps/template" ]; then
	echo "Deleting webapp template"
	sleep 1
	rm -rf $DEFAULT_RPRO_PATH/webapps/template
fi



if [ -d "$DEFAULT_RPRO_PATH/webapps/vod" ]; then
	echo "Deleting webapp vod"
	sleep 1
	rm -rf $DEFAULT_RPRO_PATH/webapps/vod
fi



if [ -d "$DEFAULT_RPRO_PATH/webapps/streammanager" ]; then
	echo "Deleting webapp streammanager"
	sleep 1
	rm -rf $DEFAULT_RPRO_PATH/webapps/streammanager
fi



echo "[ ------------------------------------------------------------------- ]"
echo "[ -----------  STEP #3 : CHECKING AUTO STARTUP OPTIONS   ------------ ]"
echo "[ ------------------------------------------------------------------- ]"
echo "\n"

echo "Checking red5pro service status..."
 
if [ ! -f "$SERVICE_LOCATION/$SERVICE_NAME" ]; then

	register_rpro_service;

	if [ "$rpro_service_install_success" -eq 1 ]; then
		echo "Service configured successfully"
	else
		echo "Service could not be configured. Contact support!"
	fi
fi



echo "Your Red5Pro instalaltion is now ready to be converted into an autoscaling image.To convert this installation to image, please refer to  your cloud platform guide. Thank you!"

}




############################ AUTOSCALING MENU ############################################


show_autoscaling_services_menu()
{
	autoscaler_menu
	autoscaler_menu_read_options
}



autoscaler_menu()
{
	printf "\033c"

	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " ---------- AUTOSCALE SERVICES ---------- "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. PREPARE RED5PRO FOR AUTOSCALE IMAGE"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "2. BACK TO MAIN MENU"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "0. Exit"
	echo "                             "
}





autoscaler_menu_read_options(){
	local choice
	read -p "Enter choice [ 1 - 2 | 0 to exit] " choice
	case $choice in
		1) prepare_autoscale_image ;;
		# 2) rpro_to_autoscale_streammanager ;;
		2) 
		if [ $MODE -eq  1]; then 
		show_advance_menu 
		else 
		show_simple_menu 
		fi 
		;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}



############################ LICENSE MENU ############################################


show_licence_menu()
{
	licence_menu
	license_menu_read_options
}



licence_menu()
{
	printf "\033c"

	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " ----------- MANAGE LICENSE ------------- "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. ADD / UPDATE LICENSE"
	echo "2. VIEW LICENSE"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "3. BACK TO MAIN MENU"
	echo "			  "   
}





license_menu_read_options(){
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) set_update_license 0 ;;
		2) check_license 0 ;;
		3) 
		if [ $MODE -eq  1]; then 
		show_advance_menu 
		else 
		show_simple_menu 
		fi 
		;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}



############################ ADVANCE OPERATION METHODS ################################



show_advance_menu()
{
	advance_menu
	advance_menu_read_options
}


advance_menu()
{

	printf "\033c"

	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "-------------- ADVANCE MODE --------------"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. WHICH JAVA AM I USING ?"
	echo "2. ADD / UPDATE JAVA"
	echo "3. INSTALL RED5PRO FROM URL [ EXPERIMENTAL ]"
	echo "4. INSTALL RED5PRO SERVICE"
	echo "5. UNINSTALL RED5PRO SERVICE"
	echo "6. CHECK RED5 PROCESS"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "7. BACK TO MODE SELECTION"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "0. Exit"
	echo "                             "

}


#add_update_rpro_license



advance_menu_read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 | 0 to exit]] " choice
	case $choice in
		1) check_java 1 ;;
		2) add_update_java ;;
		3) install_from_url ;;
		4) register_rpro_as_service ;;
		5) unregister_rpro_as_service ;;
		6) is_red5_running ;;
		7) main ;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}




############################ SIMPLE OPERATION METHODS ################################




show_simple_menu()
{
	simple_menu
	simple_menu_read_options
}





simple_menu()
{

	printf "\033c"

	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " RED5PRO SUPER UTILS - BASIC MODE         "
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. CHECK EXISTING RED5PRO INSTALLATION"
	echo "2. INSTALL RED5PRO (From red5pro.com)"
	echo "3. INSTALL RED5PRO FROM ZIP"
	echo "4. REMOVE RED5PRO INSTALLATION"
	echo "5. ADD / UPDATE RED5PRO LICENSE"
	echo "6. RED5PRO AUTOSCALING SERVICES"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "------ RED5PRO SERVICE OPTIONS -----------"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "7. --- START RED5PRO"
	echo "8. --- STOP RED5PRO"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "9. BACK TO MODE SELECTION"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "0. Exit"
	echo "                             "

}








simple_menu_read_options(){
	local choice
	read -p "Enter choice [ 1 - 9 | 0 to exit] " choice
	case $choice in
		1) check_current_rpro ;;
		2) auto_install_rpro ;;
		3) install_rpro_zip ;;
		4) remove_rpro_installation ;;
		5) show_licence_menu ;;
		6) show_autoscaling_services_menu ;;
		7) start_red5pro_service ;;
		8) stop_red5pro_service ;;
		9) main ;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}









welcome_menu()
{

	printf "\033c"

	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " RED5PRO UTILITIES - W E L C O M E   M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "                             "
	echo "1. BASIC MODE (Recommended)"
	echo "                             "
	echo "2. ADVANCE MODE"
	echo "                             "
	echo "0. Exit"
	echo "                             "
}




read_welcome_menu_options()
{
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) simple_usage_mode ;;
		2) advance_usage_mode ;;
		0) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}



simple_usage_mode()
{

	MODE=0

	simple_menu
	simple_menu_read_options
}




advance_usage_mode()
{
	MODE=1
	
	advance_menu
	advance_menu_read_options
}




# Start application
main


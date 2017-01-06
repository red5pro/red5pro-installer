#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------

# rpro_path=/usr/local/red5pro




checkJava()
{
	JAVA_VER=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
	JAVA_VERSION=`echo "$(java -version 2>&1)" | grep "java version" | awk '{ print substr($3, 2, length($3)-2); }'`

	echo "Your current java version is " . $JAVA_VERSION

	if [ "$JAVA_VER" -ge 17 ]; then
	echo ", which meets the requirements."
	else
	echo ", which is too old..."
	fi

	simple_pause
	show_menus
}


checkUnzip()
{
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unzip|grep "install ok installed")

	if [ -z "$PKG_OK" ]; then
	echo "No unzip found"
	else
	echo "unzip was found"		
	fi

	simple_pause
	show_menus
}


install_java()
{
	update_apt="sudo apt-get update";
	eval $update_apt	

	install_default_java="sudo apt-get install default-jre";
	eval $install_default_java


	default_jre="$(which java)";
	echo "JRE installed at " . $default_jre	

	simple_pause
	show_menus
}



install_unzip()
{
	update_apt="sudo apt-get update";
	eval $update_apt	

	install_unzip="sudo apt-get install unzip";
	eval $install_unzip

	install_unzip="$(which unzip)";
	echo "Unzip installed at " . $install_unzip

	simple_pause
	show_menus
}




check_wget()
{
	PKG_CURL_OK=$(dpkg-query -W --showformat='${Status}\n' wget|grep "install ok installed")

	if [ -z "$PKG_CURL_OK" ]; then
	echo "No wget found"
	else
	echo "wget was found"		
	fi

	simple_pause
	show_menus
}




install_wget()
{
	update_apt="sudo apt-get update";
	eval $update_apt	

	install_curl="sudo apt-get install wget";
	eval $install_curl

	install_curl="$(which wget)";
	echo "wget installed at " . $install_curl
	
	simple_pause
	show_menus
}




check_license(){


	echo "Enter the full path to Red5pro installation"
	read rpro_path

	lic_file=$rpro_path/LICENSE.KEY

	if [ ! -f $lic_file ]; then
  		echo "No license file found!. Please install a license."
	else
		value=`cat $lic_file`
		echo "Current license : $value"
	fi
	
	simple_pause	
	install_rpro	
}


simple_pause(){

	read -r -p 'Press any [ Enter ] key to continue...' key
}


set_update_license()
{
	clear
	echo "Updating red5pro license"


	echo "Enter the full path to Red5pro installation"
	read rpro_path

	lic_file=$rpro_path/LICENSE.KEY
	lic_new=1

	if [ ! -f $lic_file ]; then
  		echo "Installing license code : Please enter new license code."
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
		echo "Updating license : Please enter new license code."
	fi

	read license_code

	license_code=$(echo $license_code | tr '[a-z]' '[A-Z]')
	lic_install="sudo printf $license_code > $lic_file";
	eval $lic_install;

	if [ $lic_new -eq 1 ]; then
	echo "license installed"
	else
	echo "License updated"
	fi
	
	simple_pause	
	install_rpro
}


install_rpro() 
{
	rpro_menu
	read_rpro_options
}



rpro_menu()
{

	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo " RED5 INSTALLER - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Check Red5pro Installation"
	echo "2. Install From Zip"
	echo "3. Install Latest"
	echo "4. Register Service"
	echo "5. UnRegister Service"
	echo "6. Check license"
	echo "7. Set / Update license"
	echo "8. Main Menu"
	echo "9. Exit"

}



read_rpro_options()
{
	local choice
	read -p "Enter choice [ 1 - 9] " choice
	case $choice in
		1) find_rpro ;;
		2) Install_rpro_zip ;;
		3) download_latest ;;
		4) register_rpro_service ;;
		5) unregister_rpro_service ;;
		6) check_license ;;
		7) set_update_license ;;
		8) main ;;
		9) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}



find_rpro()
{
	echo "Looking for Red5pro installation"

	simple_pause	
	install_rpro
}


Install_rpro_zip()
{
	clear
	echo "Installing red5pro from zip"


	echo "Enter the full path to Red5pro zip"
	read rpro_zip_path

	
	filename=$(basename "$rpro_zip_path")
	extension="${filename##*.}"
	filename="${filename%.*}"


	echo "Attempting to install red5pro from zip"
	dir=`mktemp -d` && cd $dir
	unzip_dest="$dir/$filename"


	sleep 1	
	echo "Unpacking archive to install location -------"
	unzip_rpro="sudo unzip $rpro_zip_path -d $unzip_dest"
	eval  $unzip_rpro


	# Move to actual install location 
	rpro_loc=/usr/local/red5pro
	mv_rpro="sudo mv -v $unzip_dest/* $rpro_loc"
	eval  $mv_rpro


	echo "Setting permissions -----------"
	sleep 1

	permit_red5_location="sudo chmod 755 /usr/local/red5pro"
	eval  $permit_red5_location
	
	permit_red5="sudo chmod +x /usr/local/red5pro/red5.sh"
	eval  $permit_red5

	permit_red5_shutdown="sudo chmod +x /usr/local/red5pro/red5-shutdown.sh"
	eval  $permit_red5_shutdown	


	# clear tmp directories
	echo "cleaning up ----"
	sleep 1
	clr_tmp="sudo rm -rf $dir"
	eval $clr_tmp;

	clr_tmp2="sudo rm -rf $unzip_dest"
	eval $clr_tmp2;

	sleep 1
	echo "All done! ----"
	echo "Red5pro installed at  $rpro_loc"

	
	echo "Please wait as i return you to the menu"
	sleep 4

	simple_pause
	rpro_menu
}




register_rpro_service()
{

location=/etc/init.d/red5pro

echo "Preparing to install service..."
sleep 2

prep_script_file="sudo touch $location"
eval $prep_script_file;

#####################

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
  # check to see if the server is already running
  if netstat -an | grep ':5080'; then
    echo \"Red5 is already started...\"
    while netstat -an | grep ':5080'; do
      # wait 5 seconds and test again
      sleep 5
    done
  fi
  cd \${RED5_HOME} && ./red5.sh &
}

stop() {
  cd \${RED5_HOME} && ./red5-shutdown.sh
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

###############################

echo "Writing service script"
sleep 1

create_service_file='echo "$service_script"  >> $location';
eval $create_service_file;


###############################

echo "Registering service \"red5pro\""
sleep 1

reg_service="sudo update-rc.d red5pro defaults"
eval $reg_service;

echo "Enabling service \"red5pro\""
sleep 1

enable_service="sudo update-rc.d red5pro enable"
eval $enable_service;


echo "Red5Pro service installed successfully!"

simple_pause	
install_rpro
}




unregister_rpro_service()
{
	location=/etc/init.d/red5pro

	echo "Preparing to remove service..."
	sleep 2


	if [ -f "$location" ];	then
	
		service=red5pro

		# first pass stop
		if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
		then
		echo "Red5pro service is running!.Please wait as i attempt to stop it"
		stop_service="sudo /etc/init.d/red5pro stop"
		eval $stop_service;
		sleep 5
		fi


		# second pass stop
		if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
		then
		echo "Red5pro service is running!.Please wait as i attempt to stop it"
		stop_service="pkill -9 red5pro"
		eval $stop_service;
		sleep 5
		fi
		

		echo "Disabling service \"red5pro\""
		sleep 1

		disable_service="sudo update-rc.d red5pro disable"
		eval $disable_service;

		echo "Removing service \"red5pro\""
		sleep 1

		remove_service="sudo update-rc.d red5pro remove"
		eval $remove_service;	

		rm_file="sudo rm $location"
		eval $rm_file

		echo "Service removed successfully"
	
	else
		echo "Red5pro service was not found"
	fi

	simple_pause	
	install_rpro
}



download_latest()
{

	echo "Installing red5pro from red5pro.com"
	
	# create tmp directory
	dir=`sudo mktemp -d` && cd $dir

	wget_cd="cd $dir"
	eval $wget_cd

	echo $dir

	wget_login="wget --save-cookies cookies.txt --keep-session-cookies --post-data=\"email=rajdeeprath@gmail.com&password=charity\" \"https://account.red5pro.com/login\""	
	eval $wget_login;

	wget_get_rpro="wget --load-cookies cookies.txt --content-disposition -p  https://account.red5pro.com/download/red5"
	eval $wget_get_rpro;

	rpro_zip=
	search_dir="$dir/account.red5pro.com/download"
	for file in $search_dir/*.zip
	do
		rpro_zip="${file%%.zip}"
		break	
	done

	simple_pause
	rpro_menu
}


pause()
{
  read -p "Press [Enter] key to continue..." fackEnterKey
}





main(){
	show_menus
	read_options
}
 



# function to display main menu
show_menus() 
{
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Check Java"
	echo "2. Check unzip"
	echo "3. Install java"
	echo "4. Install unzip"
	echo "5. Check wget"
	echo "6. Install wget"
	echo "7. Install Red5pro"
	echo "8. Exit"
}





# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 8] " choice
	case $choice in
		1) checkJava ;;
		2) checkUnzip ;;
		3) install_java ;;
		4) install_unzip ;;
		5) check_wget ;;
		6) install_wget ;;
		7) install_rpro ;;
		8) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}








 
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------

main


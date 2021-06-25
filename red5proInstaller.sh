#!/bin/bash

RED5_HOME="/usr/local/red5pro"
CURRENT_DIRECTORY=$(pwd)
RPRO_SERVICE_LOCATION="/lib/systemd/system/red5pro.service"
MIN_JAVA_VERSION="11"
RED5PRO_DEFAULT_DOWNLOAD_NAME="red5pro_latest.zip"
RPRO_SERVICE_NAME="red5pro.service"

TEMP_FOLDER="$CURRENT_DIRECTORY/tmp"
rpro_zip="$TEMP_FOLDER/$RED5PRO_DEFAULT_DOWNLOAD_NAME"

PACKAGES_DEFAULT=(language-pack-en jsvc ntp git unzip libvdpau1)
PACKAGES_1604=(default-jre libva1 libva-drm1 libva-x11-1)
PACKAGES_1804=(libva2 libva-drm2 libva-x11-2)
PACKAGES_2004=(libva2 libva-drm2 libva-x11-2)
JDK_8=(openjdk-8-jre-headless)
JDK_11=(openjdk-11-jdk)

######################################################################################
#################################### LOGGERS #########################################
######################################################################################

log_i() {
    #log
    printf "\033[0;32m[INFO] --- %s \033[0m\n" "${@}"
}
log_w() {
    #log
    printf "\033[0;35m[WARN] --- %s \033[0m\n" "${@}"
}
log_e() {
    #log
    printf "\033[0;31m[ERROR] --- %s \033[0m\n" "${@}"
}
log() {
    echo -n "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

cls()
{
    printf "\033c"
}

pause()
{
    printf "\n"
    read -r -p 'Press any key to continue...' key
    $current_menu
}

######################################################################################
################################### MAIN MENU ########################################
######################################################################################

main()
{
    current_menu="main"
    welcome_menu
    read_welcome_menu_options
}

welcome_menu()
{
    cls
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[44m RED5 PRO INSTALLER - MAIN MENU \e[m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    
    echo -e "* Distribution: \e[36m$RPRO_OS_NAME\e[m"
    echo -e "* Version: \e[36m$RPRO_OS_VERSION\e[m"
    echo -e "* Kernel: \e[36m$os_bits\e[m"
    echo -e "* Total Memory: \e[36m$total_mem (MB)\e[m"
    echo -e "* Free Memory: \e[36m$free_mem  (mb)\e[m"
    echo -e "* Home directory: \e[36m$USER_HOME\e[m"
    echo -e "* BackUp directory: \e[36m$RPRO_BACKUP_HOME\e[m"
    echo -e "* Install directory: \e[36m$RED5_HOME\e[m"
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    
    if [[ $RPRO_OS_NAME == *"Ubuntu"* ]]; then
        echo "                             		"
        echo "1. BASIC MODE (Recommended)		"
        echo "                             		"
        echo "2. UTILITY MODE				"
        echo "                             		"
        echo "X. Exit					"
        echo "                             		"
    else
        log_e "Your Operating system is not supported, please use Ubuntu 16.04, 18.04 or 20.04."
        printf "\n"
        read -r -p 'Press any key to exit...'
        exit
    fi
}

read_welcome_menu_options()
{
    
    local choice
    read -p "Enter choice [ 1 - 2 | X to exit] " choice
    case $choice in
        1) show_simple_menu ;;
        2) show_utility_menu ;;
        [xX])  exit 0;;
        *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && main ;;
    esac
}

######################################################################################
############################### SIMPLE USAGE MENU ####################################
######################################################################################

show_simple_menu()
{
    current_menu="show_simple_menu"
    previous_menu="show_simple_menu"
    simple_menu
    simple_menu_read_options
}

simple_menu()
{
    cls
    check_current_rpro 1
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[44m RED5 PRO INSTALLER - BASIC MODE \e[m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "1. --- INSTALL LATEST RED5 PRO		"
    echo "2. --- INSTALL RED5 PRO FROM URL (UPLOADED ARCHIVE)	"
    echo "3. --- INSTALL RED5 PRO FROM LOCAL STORAGE	"
    
    if [[ $rpro_exists -eq 1 ]]; then
        
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "4. --- REMOVE RED5 PRO INSTALLATION	"
        echo "5. --- ADD / UPDATE RED5 PRO LICENSE	"
        echo "6. --- SSL CERT INSTALLER (Letsencrypt) 		"
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        if is_service_installed; then
            echo "7. --- START RED5 PRO			"
            echo "8. --- STOP RED5 PRO			"
            echo "9. --- RESTART RED5 PRO			"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            echo "10. --- REMOVE SERVICE			"
        else
            #printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            echo "7. --- INSTALL SERVICE			"
        fi
        
    fi
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "0. --- BACK"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "X. --- Exit				"
    echo "                             		"
    
}

simple_menu_read_options(){
    
    local choice
    
    if [[ $rpro_exists -eq 1 ]]; then
        if is_service_installed; then
            read -p "Enter choice [ 1 - 10 | 0 to go back | X to exit ] " choice
        else
            read -p "Enter choice [ 1 - 7 | 0 to go back | X to exit ] " choice
        fi
    else
        read -p "Enter choice [ 1 - 3 | 0 to go back | X to exit ] " choice
    fi
    
    if [[ $rpro_exists -eq 0 ]]; then
        case $choice in
            1) cls && auto_install_rpro "latest" ;;
            2) cls && auto_install_rpro "url" ;;
            3) cls && auto_install_rpro "local" ;;
            0) cls && main ;;
            [xX])  exit 0;;
            *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_simple_menu ;;
        esac
        
    else
        if is_service_installed; then
            case $choice in
                1) cls && auto_install_rpro "latest" ;;
                2) cls && auto_install_rpro "url" ;;
                3) cls && auto_install_rpro "local" ;;
                4) cls && remove_rpro_installation ;;
                5) cls && show_licence_menu ;;
                6) cls && rpro_ssl_installer_main ;;
                7) cls && start_red5pro_service && $current_menu ;;
                8) cls && stop_red5pro_service && $current_menu ;;
                9) cls && stop_red5pro_service && start_red5pro_service && $current_menu ;;
                10) cls && unregister_rpro_service && $current_menu ;;
                0) cls && main ;;
                [xX])  exit 0;;
                *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_simple_menu ;;
            esac
        else
            case $choice in
                1) cls && auto_install_rpro "latest" ;;
                2) cls && auto_install_rpro "url" ;;
                3) cls && auto_install_rpro "local" ;;
                4) cls && remove_rpro_installation ;;
                5) cls && show_licence_menu ;;
                6) cls && rpro_ssl_installer_main ;;
                7) cls && register_rpro_service && $current_menu ;;
                0) cls && main ;;
                [xX])  exit 0;;
                *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_simple_menu ;;
            esac
        fi
    fi
    
}

######################################################################################
############################ LICENSE MENU ############################################
######################################################################################

show_licence_menu()
{
    current_menu="show_licence_menu"
    licence_menu
    license_menu_read_options
}

licence_menu()
{
    cls
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[44m ----------- MANAGE LICENSE ------------- \e[m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "1. ADD OR UPDATE LICENSE"
    echo "2. VIEW LICENSE"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "0. BACK"
    echo "			  "
}

license_menu_read_options(){
    
    local choice
    read -p "Enter choice [ 1 - 2 | 0 to go back ] " choice
    
    case $choice in
        1) set_update_license 0 ;;
        2) check_license 0 ;;
        0) $previous_menu ;;
        *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_licence_menu ;;
    esac
}

######################################################################################
############################### UTILITY USAGE MENU ###################################
######################################################################################

show_utility_menu()
{
    current_menu="show_utility_menu"
    previous_menu="show_utility_menu"
    advance_menu
    advance_menu_read_options
}

advance_menu()
{
    cls
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[44m RED5 PRO INSTALLER - UTILITY MODE \e[m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "1. --- CHECK EXISTING RED5 PRO INSTALLATION"
    echo "2. --- WHICH JAVA AM I USING ?		 "
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "0. --- BACK					 "
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "X. --- Exit					 "
    echo "                             		 	 "
    
}

advance_menu_read_options(){
    
    local choice
    
    read -p "Enter choice [ 1 - 2 | 0 to go back | X to exit ] " choice
    
    case $choice in
        1) cls && check_current_rpro 0 ;;
        2) cls && check_java 1 ;;
        0) cls && main ;;
        [xX])  exit 0;;
        *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_utility_menu ;;
    esac
}

###################################################################################
############################## SYSTEM DETECT ######################################
###################################################################################

detect_system()
{
    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        RPRO_OS_NAME=$DISTRIB_ID
        RPRO_OS_VERSION=$DISTRIB_RELEASE
        elif [ -f /etc/debian_version ]; then
        RPRO_OS_NAME=Debian  # XXX or Ubuntu??
        RPRO_OS_VERSION=$(cat /etc/debian_version)
        elif [ -f /etc/redhat-release ]; then
        . /etc/os-release
        RPRO_OS_NAME=$ID
        RPRO_OS_VERSION=$VERSION
    else
        RPRO_OS_NAME=$(uname -s)
        RPRO_OS_VERSION=$(uname -r)
    fi
    
    case $(uname -m) in
        x86_64) os_bits="64 Bit";;
        i*86) os_bits="32 Bit" ;;
        *) os_bits="Not defined" ;;
    esac
    
    total_mem=$(awk '/MemTotal/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
    total_mem=$(printf "%.0f" $total_mem)
    
    free_mem=$(awk '/MemFree/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
    free_mem=$(printf "%.0f" $free_mem)
}


###################################################################################
################################ INSTALL PACKAGES #################################
###################################################################################

check_linux_and_java_versions(){
    #. /etc/lsb-release
    log_i "Checking the required JAVA version..."
    sleep 2
    jdk_version="jdk8"
    
    red5pro_service_file="$RED5_HOME/red5pro.service"
    
    if grep -q "java-8-openjdk-amd64" $red5pro_service_file ; then
        log_i "Found required JAVA version: java-8-openjdk-amd64"
        jdk_version="jdk8"
    else
        if grep -q "java-11-openjdk-amd64" $red5pro_service_file ; then
            log_i "Found required JAVA version: java-11-openjdk-amd64"
            jdk_version="jdk11"
        else
            log_e "Not found JAVA version in the file $red5pro_service_file"
            
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            echo -e "\e[35mPlease choose JAVA version manualy! \e[m"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            echo "1. --- JAVA 8"
            echo "2. --- JAVA 11"
            echo "X. --- Exit"
            echo " "
            
            read -p "Enter choice [ 1 - 2 | X to exit ] " choice
            case $choice in
                1) jdk_version="jdk8" ;;
                2) jdk_version="jdk11" ;;
                [xX]) pause ;;
                *)
                    log_i "Operation cancelled"
                    pause
                ;;
            esac
        fi
    fi
    
    case "${RPRO_OS_VERSION}" in
        16.04)
            if [[ $jdk_version == "jdk11" ]]; then
                log_e "Ubuntu 16.04 is not supporting Java version 11. Please use Ubuntu 18.04 or higher!!!"
                pause
            else
                PACKAGES=("${PACKAGES_1604[@]}")
            fi
        ;;
        18.04)
            case "${jdk_version}" in
                jdk8) PACKAGES=("${PACKAGES_1804[@]}" "${JDK_8[@]}") ;;
                jdk11) PACKAGES=("${PACKAGES_1804[@]}" "${JDK_11[@]}") ;;
                *) log_e "JDK version is not supported $jdk_version"; pause ;;
            esac
        ;;
        20.04)
            case "${jdk_version}" in
                jdk8) PACKAGES=("${PACKAGES_2004[@]}" "${JDK_8[@]}") ;;
                jdk11) PACKAGES=("${PACKAGES_2004[@]}" "${JDK_11[@]}") ;;
                *) log_e "JDK version is not supported $jdk_version"; pause ;;
            esac
        ;;
        *) log_e "Linux version is not supported $RPRO_OS_VERSION"; pause ;;
    esac
}

install_pkg(){
    
    for i in {1..3};
    do
        
        local install_issuse=0;
        apt-get -y update --fix-missing &> /dev/null
        
        for index in ${!PACKAGES[*]}
        do
            log_i "Install utility ${PACKAGES[$index]}"
            apt-get install -y ${PACKAGES[$index]} &> /dev/null
        done
        
        for index in ${!PACKAGES[*]}
        do
            PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ${PACKAGES[$index]}|grep "install ok installed")
            if [ -z "$PKG_OK" ]; then
                log_i "${PACKAGES[$index]} utility didn't install, didn't find MIRROR !!! "
                install_issuse=$(($install_issuse+1));
            else
                log_i "${PACKAGES[$index]} utility installed"
            fi
        done
        
        if [ $install_issuse -eq 0 ]; then
            break
        fi
    done
    if [ $i -ge 3 ]; then
        log_e "Something wrong with packages installation!!! Exit."
        pause
    fi
}

###################################################################################
################################ INSTALL RED5PRO ##################################
###################################################################################

auto_install_rpro()
{
    log_i "Starting Red5 Pro auto-installer"
    
    if [ "$rpro_exists" -eq 1 ]; then
        
        log_w "An existing Red5 Pro installation was found at install destination.If you continue this will be replaced. The old installation will be backed up to $RPRO_BACKUP_HOME"
        sleep 1
        echo "Warning! All file(s) and folder(s) at $RED5_HOME will be removed permanently"
        read -r -p "Do you wish to continue? [y/N] " response
        case $response in
            [yY][eE][sS]|[yY])
                backup_rpro
                if [ $rpro_backup_success -eq 0 ]; then
                    log_e "Failed to create a backup of your existing Red5 Pro installation"
                    pause
                fi
                unregister_rpro_service
                rm -rf $RED5_HOME
            ;;
            *)
                log_i "Operation cancelled"
                pause
            ;;
        esac
    fi
    
    case $1 in
        latest) download_latest ;;
        url) download_from_url ;;
        local) download_from_local ;;
    esac
    
    PACKAGES=("${PACKAGES_DEFAULT[@]}")
    install_pkg
    
    RED5ARCHIVE=$(ls $TEMP_FOLDER/red5pro*.zip | xargs -n 1 basename);
    RED5ARCHIVE_PATH=$TEMP_FOLDER/$RED5ARCHIVE
    
    if [ -f $RED5ARCHIVE_PATH ] ; then
        find "$TEMP_FOLDER" -type f -not \( -name '*zip' \) -delete
    else
        log_e "Oops!! Seems like the archive was not downloaded or not found on the disk."
        pause
    fi
    
    log_i "Installing Red5 Pro from $RED5ARCHIVE"
    sleep 2
    install_rpro_zip
    
    if [ "$red5_zip_install_success" -eq 0 ]; then
        log_e "Failed to install Red5 Pro distribution. Something went wrong!! Try again or contact support!"
    fi
    
    pause
}

download_latest()
{
    local rpro_form_valid=1
    local try_login_response
    
    log_i "Preparing to install Red5 Pro from 'red5pro.com'"
    sleep 2
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "Please enter your 'red5pro.com' login details"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    
    echo "Enter Email : "
    read rpro_email
    
    echo "Enter Password : "
    read -s rpro_passcode
    
    if ! isEmailValid "${rpro_email}"; then
        rpro_form_valid=0
        log_w "Invalid email string!"
    fi
    
    if [ -z "$rpro_passcode" ] && [ "$rpro_passcode" == " " ]; then
        rpro_form_valid=0
        log_w "Invalid password string!"
    fi
    
    # if all params are valid
    if [ "$rpro_form_valid" -eq "1" ]; then
        
        log_i "Attempting to log in with your credentials"
        
        # POST to site
        wget --server-response --save-cookies cookies.txt --keep-session-cookies --post-data="email=$rpro_email&password=$rpro_passcode" "https://account.red5pro.com/login" 2>$TEMP_FOLDER/wsession.txt
        wget_status=$(< $TEMP_FOLDER/wsession.txt)
        
        # Check http code
        if [[ $wget_status == *"HTTP/1.1 200"* ]]; then
            
            if [[ $wget_status != *"Invalid"* ]]; then
                
                log_i "Attempting to download latest Red5 Pro archive file to $TEMP_FOLDER"
                
                wget --load-cookies cookies.txt --content-disposition -p  https://account.red5pro.com/download/red5 -O "$rpro_zip"
                
                if [ -f $rpro_zip ] ; then
                    find "$TEMP_FOLDER" -type f -not \( -name '*zip' \) -delete
                else
                    log_e "Oops!! Seems like the archive was not downloaded properly to disk."
                    log_e "Failed to download latest Red5 Pro distribution from 'red5pro.com'. Please contact support!"
                    pause
                fi
            else
                
                log_w "Failed to authenticate with website!"
                read -r -p " -- Retry? [y/N] " try_login_response
                case $try_login_response in
                    [yY][eE][sS]|[yY]) download_latest ;;
                    *) latest_rpro_download_success=0 ;;
                esac
            fi
        fi
    else
        log_w "Invalid request parameters"
        read -r -p " -- Retry? [y/N] " try_login_response
        case $try_login_response in
            [yY][eE][sS]|[yY]) download_latest ;;
            *) ;;
        esac
    fi
}

download_from_url()
{
    clear
    log_i "Downloading Red5 Pro from url"
    
    echo "Enter the Red5 Pro archive file URL source";
    read RED5PRO_DOWNLOAD_URL
    
    log_i "Attempting to download Red5 Pro archive file to $TEMP_FOLDER"
    wget -O "$RED5PRO_DEFAULT_DOWNLOAD_NAME" "$RED5PRO_DOWNLOAD_URL" -O "$rpro_zip"
}

download_from_local()
{
    clear
    log_i "Downloading Red5 Pro from local storage"
    
    echo "Enter the path to Red5 Pro archive file. (Example: /home/user/red5pro-server-release.zip)";
    read RED5PRO_DOWNLOAD_PATH
    
    log_i "Attempting to copy Red5 Pro archive file to $TEMP_FOLDER"
    if [ -f $RED5PRO_DOWNLOAD_PATH ] ; then
        cp -r $RED5PRO_DOWNLOAD_PATH $rpro_zip
    else
        log_e "Path to Red5 Pro archive is not correct: $RED5PRO_DOWNLOAD_PATH"
        pause
    fi
}

install_rpro_zip()
{
    red5_zip_install_success=0
    
    clear
    
    log_i "Installing Red5 Pro from zip $RED5ARCHIVE_PATH"
    
    if ! isValidArchive $RED5ARCHIVE_PATH; then
        log_i "Cannot process archive $RED5ARCHIVE_PATH"
        pause;
    fi
    
    log_i "Attempting to install Red5 Pro from zip"
    
    log_i "Unpacking archive $RED5ARCHIVE to install location..."
    
    if ! unzip $TEMP_FOLDER/$RED5ARCHIVE -d $TEMP_FOLDER/; then
        log_e "Failed to extract zip. Possible invalid archive"
        rm -r $TEMP_FOLDER/*
        pause;
    fi
    
    rm $TEMP_FOLDER/$RED5ARCHIVE
    
    log_i "Moving files to install location : $RED5_HOME"
    
    # SHECKING UNPACKED ARCHIVE FILES STRUCTURE
    local count
    count=$(find $TEMP_FOLDER -maxdepth 1 -type d | wc -l)
    
    if [ $count -gt 2 ]; then
        # Single level archive -> top level manual zip
        if [ ! -d "$RED5_HOME" ]; then
            mkdir -p $RED5_HOME
        fi
        log_i "Single level archive -> top level manual zip"
        mv $TEMP_FOLDER/* $RED5_HOME
        
    else
        log_i "Single level archive -> top level manual zip"
        mv $TEMP_FOLDER/red5pro* $RED5_HOME
    fi
    
    log_i "Setting permissions ..."
    sleep 1
    chmod +x $RED5_HOME/*.sh
    
    sleep 1
    
    if [ ! -d "$RED5_HOME" ]; then
        log_w "Could not install Red5 Pro at $RED5_HOME"
        pause
    else
        log_i "Red5 Pro installed at $RED5_HOME"
        red5_zip_install_success=1
    fi
    
    check_linux_and_java_versions
    install_pkg
    
    echo "For Red5 Pro to autostart with operating system, it needs to be registered as a service"
    read -r -p "Do you want to register Red5 Pro service now? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            register_rpro_service
            log_i "Red5 Pro service is now installed on your system. You can start / stop it with from the menu".
        ;;
        *) log_i "Skip registering Red5 Pro as a service"
        ;;
    esac
    
    echo "                             	"
    echo -e "\e[31mNOTE: To use WebRTC it is imperative that you have SSL configured on the Red5 Pro instance.For more information see https://www.red5pro.com/docs/server/ssl/overview/\e[m"
    
    # Moving to home directory
    cd ~
}

###################################################################################
################################### CHECK RED5PRO #################################
###################################################################################

check_current_rpro()
{
    rpro_exists=0
    local check_silent=$1
    
    red5pro_ini="$RED5_HOME/conf/red5.ini"
    
    if [ "$check_silent" -eq 0 ] ; then
        log_i "Looking for Red5 Pro at install location..."
        sleep 2
        
        if [ -d $RED5_HOME ]; then
            log_i "Red5 Pro installation found at install location : $RED5_HOME"
            if [ -f $red5pro_ini ]; then
                red5pro_server_version=$(sed ${red5pro_ini} -e "s/server.version=/""/g")
                log_i "Red5 Pro build info : $red5pro_server_version"
            else
                log_w "There were files found at install location : $RED5_HOME, but the installation might be broken !. I could not locate version information"
            fi
        else
            log_i "No Red5 Pro installation found at install location : $RED5_HOME"
        fi
        pause
    fi
    
    if [ ! -f $red5pro_ini ]; then
        rpro_exists=0
    else
        rpro_exists=1
    fi
}

###################################################################################
################################## BACKUP RED5PRO #################################
###################################################################################

backup_rpro()
{
    rpro_backup_success=0
    
    if [ ! -d "$RPRO_BACKUP_HOME" ]; then
        mkdir -p $RPRO_BACKUP_HOME
        chmod 777 $RPRO_BACKUP_HOME
    fi
    
    if [ -d "$RPRO_BACKUP_HOME" ]; then
        
        log_i "Starting backup procedure..."
        sleep 2
        
        stop_red5pro_service
        log_i "Backing up... "
        
        # Create backup folder
        t_now=$(date +%Y-%m-%d-%H-%M)
        RPRO_BACKUP_FOLDER="$RPRO_BACKUP_HOME/red5pro_$t_now"
        
        # Copy all files to backup folder
        cp -R $RED5_HOME $RPRO_BACKUP_FOLDER
        
        # Show notice to user that back up was saved
        if [ -d "$RPRO_BACKUP_FOLDER" ]; then
            if [ -f $red5pro_ini ]; then
                printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
                log_i "Your active Red5 Pro installation was backed up successfully to $RPRO_BACKUP_FOLDER"
                log_i "You can restore any necessary file(s) later from the backup manually."
                printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
                chmod 777 $RPRO_BACKUP_FOLDER
                rpro_backup_success=1
                rm -r $RED5_HOME
            else
                log_e "Something went wrong!! Perhaps files were not copied properly"
            fi
        else
            log_e "WARNING! Could not create backup destination directory"
        fi
        
        printf "\n"
        read -r -p 'Press any [ Enter ] key to continue...'
        
    else
        log_e "Failed to create backup directory. Backup will be skipped..."
        
    fi
}

###################################################################################
###################################### LICENSE ####################################
###################################################################################

set_update_license(){
    local lic_file="$RED5_HOME/LICENSE.KEY"
    local current_license_code
    
    if [ ! -f $lic_file ]; then
        touch "$lic_file"
        echo "Installing license code : Please enter new license code and press [ Enter ]."
        read license_code
    else
        current_license_code=$(cat $lic_file)
        
        if [ -z "$current_license_code" ]; then
            log_w "No license key found in the file $lic_file!."
        else
            log_i "Current license key: $current_license_code"
        fi
        
        echo "Updating license : Please enter new license code and press [ Enter ]."
        read license_code
    fi
    log_i "Writing license code $license_code to file $lic_file"
    echo "$license_code" > $lic_file
    pause
}

check_license() {
    local lic_file=$RED5_HOME/LICENSE.KEY
    local current_license_code
    
    if [ ! -f $lic_file ]; then
        log_w "No license file found!. Please install a license."
    else
        current_license_code=$(cat $lic_file)
        
        if [ -z "$current_license_code" ]; then
            log_w "No license key found in the file $lic_file!. Please install a license."
        else
            log_i "Current license key: $current_license_code"
        fi
    fi
    pause
}

is_license_installed(){
    local lic_file=$RED5_HOME/LICENSE.KEY
    local current_license_code
    
    if [ -f $lic_file ]; then
        current_license_code=$(cat $lic_file)
        if [ -z "$current_license_code" ]; then
            false
        else
            true
        fi
    else
        false
    fi
}

###################################################################################
############################### REMOVE RED5PRO ####################################
###################################################################################

remove_rpro_installation()
{
    log_i "Looking for Red5 Pro at install location..."
    sleep 2
    
    if [ ! -d $RED5_HOME ]; then
        log_w "No Red5 Pro installation found at install location : $RED5_HOME"
    else
        if [ ! -f $RED5_HOME/conf/red5.ini ]; then
            log_w "There were files found at install location : $RED5_HOME, but the installation might be broken !. I could not locate version information"
        else
            echo "Red5 Pro installation found at install location : $RED5_HOME"
            echo "Warning! All file(s) and folder(s) at $RED5_HOME will be removed permanently"
            read -r -p "Are you sure? [y/N] " response
            
            case $response in
                [yY][eE][sS]|[yY])
                    stop_red5pro_service
                    unregister_rpro_service
                    rm -r $RED5_HOME
                    if [ ! -d "$RED5_HOME" ]; then
                        log_i "Red5 installation was removed"
                    fi
                ;;
                *)
                    log_w "Uninstall cancelled"
                ;;
            esac
        fi
    fi
    pause
}

###################################################################################
############################# RED5PRO SERVICE #####################################
###################################################################################

unregister_rpro_service()
{
    log_i "Unregistering service $RPRO_SERVICE_NAME"
    sleep 1
    
    systemctl disable red5pro.service
    
    log_i "Preparing to remove service..."
    
    if [ -f /lib/systemd/system/red5pro.service ];	then
        rm -f /lib/systemd/system/red5pro.service
        log_i "Service removed successfully"
    else
        log_w "Red5 Pro service was not found"
        sleep 2
    fi
    sleep 2
}

register_rpro_service()
{
    log_i "Registering service $RPRO_SERVICE_NAME"
    sleep 1
    
    test_set_mem
    
    log_i "Copy original service file $RPRO_SERVICE_NAME"
    cp "$RED5_HOME/red5pro.service" /lib/systemd/system/red5pro.service
    chmod 644 /lib/systemd/system/red5pro.service
    
    log_i "JVM MEMORY (-Xms-Xmx) ${MEMORY}GB"
    
    local service_memory_pattern='-Xms2g -Xmx2g'
    local service_memory_new="-Xms${MEMORY}g -Xmx${MEMORY}g"
    
    sudo sed -i -e "s|$service_memory_pattern|$service_memory_new|" "/lib/systemd/system/red5pro.service"
    
    systemctl daemon-reload
    
    log_i "Enabling service $RPRO_SERVICE_NAME"
    systemctl enable red5pro.service
    sleep 2
}

is_service_installed()
{
    if [ ! -f "$RPRO_SERVICE_LOCATION" ]; then
        false
    else
        true
    fi
}

start_red5pro_service()
{
    log_i "Start Red5 Pro service"
    
    if is_license_installed; then
        systemctl start red5pro
        if [ "0" -eq $? ]; then
            log_i "Red5 Pro service started!"
        else
            log_e "Red5 Pro service file was not started!"
            log_e "Please check service file $RPRO_SERVICE_LOCATION"
            pause
        fi
    else
        log_w "No license key found!. Please install a license."
        pause
    fi
    sleep 2
}

stop_red5pro_service(){
    log_i "Stop Red5 Pro service"
    systemctl stop red5pro
    log_i "Red5 Pro service stopped!"
    sleep 2
}

test_set_mem(){
    
    local phymem=$(free -m|awk '/^Mem:/{print $2}') # Value in Mb
    local mem=$((phymem/1024)); # Value in Gb
    
    if [[ "$mem" -le 2 ]]; then
        MEMORY=1;
        elif [[ "$mem" -gt 2 && "$mem" -le 4 ]]; then
        MEMORY=2;
    else
        MEMORY=$((mem-2));
    fi
}

###################################################################################
################################ SSL CERTIFICATE ##################################
###################################################################################

rpro_ssl_installer_main(){
    
    local rpro_ssl_form_valid=1
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo "-------- SSL CERTIFICATE REQUEST ----------"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    
    
    echo "Enter Domain (The domain name for which SSL cert is required): "
    read SSL_DOMAIN
    echo "Enter Email (The email address to identify the SSL with) : "
    read SSL_MAIL
    
    # Simple domain name validation
    if [ -z "$rpro_ssl_reg_domain" -a "$rpro_ssl_reg_domain" == " " ]; then
        log_e "Invalid 'Domain' string!"
        rpro_ssl_form_valid=0
    fi
    
    if ! isEmailValid "${SSL_MAIL}"; then
        log_e "Invalid 'Email' string!"
        rpro_ssl_form_valid=0
    fi
    if [ "$rpro_ssl_form_valid" -eq "0" ]; then
        log_e "One or more parameters are invalid. Please check and try again!"
        read -r -p " -- Retry? [y/N] " try_login_response
        case $try_login_response in
            [yY][eE][sS]|[yY]) cls && rpro_ssl_installer_main ;;
            *) pause ;;
        esac
    fi
    
    if [ -d "/etc/letsencrypt/live/$SSL_DOMAIN" ]; then
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo -e "\e[35m Detected an existing letsEncrypt SSL certificate for this domain. Please an appropriate action to continue! \e[m"
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "1. --- DELETE LETSENCRYPT DIRECTORY (ALL CERTIFICATES) AND TRY AGAIN"
        echo "2. --- ATTEMPT TO USE THE EXISTING CERTIFICATE"
        echo "X. --- Exit"
        echo " "
        
        local choice
        read -p "Enter choice [ 1 - 2 | X to exit ] " choice
        case $choice in
            1) rm -rf /etc/letsencrypt ;;
            2)
                stop_red5pro_service
                rpro_ssl_installer
                config_ssl_properties
                start_red5pro_service
                log_i "Red5 Pro SSL configuration complete!"
                pause
            ;;
            [xX])  pause ;;
            *) echo -e "\e[41m Error: Invalid choice\e[m" && sleep 2 && show_has_ssl_cert_menu ;;
        esac
    fi
    
    certbot_install
    stop_red5pro_service
    rpro_ssl_get
    config_ssl_properties
    start_red5pro_service
    log_i "Red5 Pro SSL configuration complete!"
    pause
}

ssl_cert_passphrase_form()
{
    local rpro_ssl_cert_passphrase_form_error="Unknown error!"
    local rpro_ssl_cert_passphrase_valid=0
    
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "\e[33m ------- SSL CERTIFICATE PASSWORD ---------- \e[m"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    
    echo "Enter the  SSL cert password (can not contain spaces or the & character): "
    read -s rpro_ssl_cert_passphrase
    
    echo "Confirm password : "
    read -s rpro_ssl_cert_passphrase_copy
    
    # simple validate password
    if [ -n "$rpro_ssl_cert_passphrase" -a "$rpro_ssl_cert_passphrase" != " " ]; then
        
        if [ "$rpro_ssl_cert_passphrase" == "$rpro_ssl_cert_passphrase_copy" ]; then
            
            rpro_ssl_cert_passphrase_length=size=${#rpro_ssl_cert_passphrase}
            
            if [[ "$rpro_ssl_cert_passphrase_length" -gt 4 ]]; then
                
                rpro_ssl_cert_passphrase_valid=1
            else
                rpro_ssl_cert_passphrase_valid=0
                rpro_ssl_cert_passphrase_form_error="Invalid password length. Minimum length should be 5"
            fi
        else
            rpro_ssl_cert_passphrase_valid=0
            rpro_ssl_cert_passphrase_form_error="Passwords do not match!"
        fi
    else
        rpro_ssl_cert_passphrase_valid=0
        rpro_ssl_cert_passphrase_form_error="Password cannot be empty!"
    fi
    
    # If all params not valid
    local try_login_response
    if [ "$rpro_ssl_cert_passphrase_valid" -eq "0" ]; then
        
        log_e "There seems to be a problem with the cert password. Cause:$rpro_ssl_cert_passphrase_form_error. Please check and try again!"
        read -r -p " -- Retry? [y/N] " try_login_response
        case $try_login_response in
            [yY][eE][sS]|[yY]) ssl_cert_passphrase_form ;;
            *) pause ;;
        esac
    fi
    
    SSL_PASSWORD=$rpro_ssl_cert_passphrase
}

certbot_install(){
    log_i "Install Certbot for get SSL certificate..."
    snap install core; sudo snap refresh core
    snap install --classic certbot
    ln -s /snap/bin/certbot /usr/bin/certbot
}

rpro_ssl_get(){
    
    log_i "Getting a new certificate for domain: $SSL_DOMAIN ..."
    rpro_ssl_response=$(certbot certonly --non-interactive --standalone --email "$SSL_MAIL" --agree-tos -d "$SSL_DOMAIN" 2>&1 | tee /dev/tty)
    
    echo "$rpro_ssl_response" | grep 'Successfully received certificate.' &> /dev/null
    if [ $? == 0 ]; then
        log_i "SSL Certificate successfully generated!"
        rpro_ssl_installer
    else
        log_e "SSL Certificate generation did not succeed. Please rectify any errors mentioned in the logging and try again!"
        pause
    fi
}

rpro_ssl_installer()
{
    log_i "Start SSL installation to Java keystore"
    
    ssl_cert_passphrase_form
    
    local cert_path="/etc/letsencrypt/live/$SSL_DOMAIN"
    
    log_i "Importing SSL certificate to Java keystore..."
    rpro_ssl_fullchain="$cert_path/fullchain.pem"
    rpro_ssl_privkey="$cert_path/privkey.pem"
    rpro_ssl_fullchain_and_key="$cert_path/fullchain_and_key.p12"
    rpro_ssl_keystore_jks="$cert_path/keystore.jks"
    rpro_ssl_tomcat_cer="$cert_path/tomcat.cer"
    rpro_ssl_trust_store="$cert_path/truststore.jks"
    
    java_ssl_files=(fullchain_and_key.p12 keystore.jks tomcat.cer truststore.jks)
    
    for index in ${!java_ssl_files[*]}
    do
        if [ -f "$cert_path/${java_ssl_files[$index]}" ] ; then
            log_i "Delete old java ssl file: ${java_ssl_files[$index]}"
            rm "$cert_path/${java_ssl_files[$index]}"
        fi
    done
    
    openssl pkcs12 -export -in "$rpro_ssl_fullchain" -inkey "$rpro_ssl_privkey" -out "$rpro_ssl_fullchain_and_key" -password pass:"$SSL_PASSWORD" -name tomcat
    
    keytool_response=$(keytool -noprompt -importkeystore -deststorepass "$SSL_PASSWORD" -destkeypass "$SSL_PASSWORD" -destkeystore "$rpro_ssl_keystore_jks" -srckeystore "$rpro_ssl_fullchain_and_key" -srcstoretype PKCS12 -srcstorepass "$SSL_PASSWORD" -alias tomcat)
    # Check for keytool error
    if [[ ${keytool_response} == *"keytool error"* ]];then
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "An error occurred while processing certificate.Please resolve the error(s) and try the SSL installer again."
        echo "Error Details:"
        echo "$keytool_response"
        pause
    fi
    
    keytool_response=$(keytool -export -alias tomcat -file "$rpro_ssl_tomcat_cer" -keystore "$rpro_ssl_keystore_jks" -storepass "$SSL_PASSWORD" -noprompt)
    # Check for keytool error
    if [[ ${keytool_response} == *"keytool error"* ]];then
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "An error occurred while processing certificate.Please resolve the error(s) and try the SSL installer again."
        echo "Error Details:"
        echo "$keytool_response"
        pause
    fi
    
    keytool_response=$(keytool -import -trustcacerts -alias tomcat -file "$rpro_ssl_tomcat_cer" -keystore "$rpro_ssl_trust_store" -storepass "$SSL_PASSWORD" -noprompt)
    # Check for keytool error
    if [[ ${keytool_response} == *"keytool error"* ]];then
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo "An error occurred while processing certificate.Please resolve the error(s) and try the SSL installer again."
        echo "Error Details:"
        echo "$keytool_response"
        pause
    fi
}

config_ssl_properties()
{
    local cert_path="/etc/letsencrypt/live/$SSL_DOMAIN"
    local red5pro_conf_properties="$RED5_HOME/conf/red5.properties"
    local red5pro_conf_jee_container="$RED5_HOME/conf/jee-container.xml"
    
    log_i "Configure Red5 Pro to run with SSL. Config file: $red5pro_conf_properties.."
    
    local https_port_pattern='https.port=5443'
    local https_port_new="https.port=443"
    
    local rtmps_keystorepass_pattern='rtmps.keystorepass=password'
    local rtmps_keystorepass_new="rtmps.keystorepass=${SSL_PASSWORD}"
    
    local rtmps_keystorefile_pattern='rtmps.keystorefile=conf/keystore.jks'
    local rtmps_keystorefile_new="rtmps.keystorefile=${cert_path}/keystore.jks"
    
    local rtmps_truststorepass_pattern='rtmps.truststorepass=password'
    local rtmps_truststorepass_new="rtmps.truststorepass=${SSL_PASSWORD}"
    
    local rtmps_truststorefile_pattern='rtmps.truststorefile=conf/truststore.jks'
    local rtmps_truststorefile_new="rtmps.truststorefile=${cert_path}/truststore.jks"
    
    sed -i -e "s|$https_port_pattern|$https_port_new|" -e "s|$rtmps_keystorepass_pattern|$rtmps_keystorepass_new|" -e "s|$rtmps_keystorefile_pattern|$rtmps_keystorefile_new|" -e "s|$rtmps_truststorepass_pattern|$rtmps_truststorepass_new|" -e "s|$rtmps_truststorefile_pattern|$rtmps_truststorefile_new|"  "$red5pro_conf_properties"
    
    log_i "Copy original file with SSL: jee-container-ssl.xml to $red5pro_conf_jee_container"
    cp -f "$CURRENT_DIRECTORY/conf/jee-container-ssl.xml" "$red5pro_conf_jee_container"
}

###################################################################################
################################### CHECK JAVA ####################################
###################################################################################

check_java()
{
    log_i "Checking java requirements"
    
    for JAVA in "${JAVA_HOME}/bin/java" "${JAVA_HOME}/Home/bin/java" "/usr/bin/java" "/usr/local/bin/java"
    do
        if [ -x "$JAVA" ]
        then
            break
        fi
    done
    
    if [ ! -x "$JAVA" ]; then
        log_w "Unable to locate Java. If you think you do have java installed, please set JAVA_HOME environment variable to point to your JDK / JRE."
    else
        JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        log_i "Current java version is $JAVA_VERSION"
        JAVA_VERSION_MAJOR=$(echo "${JAVA_VERSION:0:3}")
        
        if (( $(echo "$JAVA_VERSION_MAJOR < $MIN_JAVA_VERSION" |bc -l) )); then
            log_i "You need to install a newer java version of java!"
        else
            log_i "Minimum java version is already installed!"
        fi
    fi
    
    pause
}

###################################################################################
##################################### ETC #########################################
###################################################################################

validatePermissions()
{
    if [[ $EUID -ne 0 ]]; then
        echo "This script does not seem to have / has lost root permissions. Please re-run the script with 'sudo'"
        exit 1
    fi
}

function isEmailValid() {
    #regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
    regex="^([A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
    [[ "${1}" =~ $regex ]]
}

isValidArchive(){
    
    if [ ! -f "$RED5ARCHIVE_PATH" ]; then
        log_w "Invalid archive file path $RED5ARCHIVE_PATH"
        false
    else
        local extension="${RED5ARCHIVE##*.}"
        
        local filesize=$(stat -c%s "$RED5ARCHIVE_PATH")
        
        if [ "$filesize" -lt 30000 ]; then
            log_w "Invalid archive file size detected for $RED5ARCHIVE_PATH. Probable corrupt file!"
            false
        else
            case "$extension" in
                zip|tar|gz*) true ;;
                *) log_w "Invalid archive type $extension" && false ;;
            esac
        fi
    fi
}

preparation(){
    
    USER_HOME=$(eval echo "~${SUDO_USER}")
    RPRO_BACKUP_HOME="$USER_HOME/red5pro_backups"
    
    if [ ! -f "$CURRENT_DIRECTORY/conf/jee-container-ssl.xml" ]; then
        log_e "File $CURRENT_DIRECTORY/conf/jee-container-ssl.xml was not found. Exit!!!"
        exit 1
    fi
    
    if [ -d $RED5_HOME ]; then
        rm -r $TEMP_FOLDER/*
    else
        mkdir $TEMP_FOLDER
    fi
}

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
validatePermissions
preparation
detect_system
main

#!/bin/bash
apt-get update -y
chmod +x -R asset/
clear
banner="#####################################################################
                                                                
  8888888 8888888888   .8.           ,o888888o.    8 888888888o   
        8 8888        .888.         8888      88.  8 8888     88. 
        8 8888       :88888.     ,8 8888        8. 8 8888      88 
        8 8888      .  88888.    88 8888           8 8888      88 
        8 8888     .8.  88888.   88 8888           8 8888.   ,88  
        8 8888    .8 8.  88888.  88 8888           8 888888888P'  
        8 8888   .8'  8.  88888. 88 8888           8 8888         
        8 8888  .8'    8.  88888. 8 8888       .8  8 8888         
        8 8888 .888888888.  88888.  8888     ,88'  8 8888         
        8 8888.8'        8.  88888.   8888888P'    8 8888         
                                                                  
#####################################################################"

echo "$banner"
sleep 2

PS3='Please enter your choice: '
options=("Install Web Static" "Install Web Dinamis" "FTP Server" "Auto Mount EBS" "Remote Server ( OS Ubuntu / OS Debian )" "Update package TACP" "Quit")
select opt in "${options[@]}"; do
    case $opt in
    "Install Web Static")
        sudo ./asset/WebStatis/webstatis.sh
        ;;

    "Install Web Dinamis")
        clear
        echo "$banner"
        sleep 2
        echo "Select Your Apps :"
        dinamis=("Datasiswa Apps" "Batiku Apps" "Quit")
        select pil in "${dinamis[@]}"; do
            case $pil in
            "Datasiswa Apps")
                datapil=("datasiswa Apps Basic" "datasiswa Apps Basic + EFS" "Quit")
                select datapil in "${datapil[@]}"; do
                    case $datapil in
                    "datasiswa Apps Basic")
                        clear
                        echo "$banner"
                        sleep 2
                        sudo ./asset/WebDinamis/datasiswa/webserver.sh
                        ;;
                    "datasiswa Apps Basic + EFS")
                        sudo ./asset/WebDinamis/datasiswa/webserverEFS.sh
                        ;;
                    "Quit")
                        break 3
                        ;;
                    esac
                done
                ;;
            "Batiku Apps")
                clear
                echo "$banner"
                sleep 2

                batikuops=("Batiku Apps Basic" "Batiku Apps + EFS" "Quit")
                echo "Select Your Apps :"
                select batiku in "${batikuops[@]}"; do
                    case $batiku in
                    "Batiku Apps Basic")
                        clear
                        echo "$banner"
                        sleep 2
                        sudo ./asset/WebDinamis/batiku/batiku.sh
                        ;;
                    "Batiku Apps + EFS")
                        clear
                        echo "$banner"
                        sleep 2
                        batikuEFSlink=("Batiku + EFS Apps Admin Version" "Batiku + EFS Apps client Version" "Quit")
                        echo "Pilih Versi Apps yang anda inginkan :"
                        select batlink in "${batikuEFSlink[@]}"; do
                            case $batlink in
                            "Batiku + EFS Apps Admin Version")
                                clear
                                echo "$banner"
                                sleep 2
                                sudo ./asset/WebDinamis/batiku/AdminBatikuEFS.sh
                                ;;
                            "Batiku + EFS Apps client Version")
                                clear
                                echo "$banner"
                                sleep 2
                                sudo ./asset/WebDinamis/batiku/batikuEFS.sh
                                ;;
                            "Quit")
                                break 3
                                ;;
                            esac
                        done
                        ;;
                    "Quit")
                        break 2
                        ;;
                    esac
                done
                ;;
            "Quit")
                break
                ;;
            esac
        done
        ;;

    "FTP Server")
        sudo ./asset/FtpServer/proftpd.sh
        ;;
    "Auto Mount EBS")
        sudo ./asset/AutoMountEBS/mountEBS.sh
        ;;
    "Remote Server ( OS Ubuntu / OS Debian )")
        sudo ./asset/remote/remote.sh
    ;;
    "Update package TACP")
        sudo ./asset/updateapp/update.sh
        break
        ;;
    "Quit")
        break
        ;;
    *) echo invalid option ;;
    esac
done

#!/bin/bash

# source upgrade package....
source ./asset/upgrade.sh

update_status=$(
    apt-get update -y >/dev/null 2>&1
    echo $?
)
if [ $update_status -eq 0 ]; then
    echo "Update sudah dijalankan sebelumnya, melanjutkan ke perintah berikutnya"
else
    apt-get update -y &
    progress_bar $! wait $!
fi

chmod +x -R asset/

clear
echo -e "${banner}${RESET}"
sleep 2

PS3='Please enter your choice: '
options=("Install Web Static" "Install Web Dinamis" "Install Web Framework" "FTP Server" "Auto Mount EBS" "Remote Server ( OS Ubuntu / OS Debian )" "Update package TACP" "Quit")
select opt in "${options[@]}"; do
    case $opt in
    "Install Web Static")
        sudo ./asset/WebStatis/webstatis.sh
        ;;

    "Install Web Dinamis")
        clear
        echo -e "${banner}${RESET}"
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
                        echo -e "${banner}${RESET}"
                        sleep 2
                        sudo ./asset/WebDinamis/datasiswa/webserver.sh
                        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
                        message "Lakukan checking Ulang "
                        message "Terimakasih Telah Menggunakan Layanan kami"
                        break 2
                        ;;
                    "datasiswa Apps Basic + EFS")
                        sudo ./asset/WebDinamis/datasiswa/webserverEFS.sh
                        message "Aplikasi Anda Sudah Terinstall Dengan Baik"
                        message "Lakukan checking Ulang "
                        message "Terimakasih Telah Menggunakan Layanan kami"
                        break 2
                        ;;
                    "Quit")
                        break 2
                        ;;
                    esac
                done
                ;;
            "Batiku Apps")
                clear
                echo -e "${banner}${RESET}"
                sleep 2

                batikuops=("Batiku Apps Basic" "Batiku Apps + EFS" "Quit")
                echo "Select Your Apps :"
                select batiku in "${batikuops[@]}"; do
                    case $batiku in
                    "Batiku Apps Basic")
                        clear
                        echo -e "${banner}${RESET}"
                        sleep 2
                        sudo ./asset/WebDinamis/batiku/batiku.sh
                        ;;
                    "Batiku Apps + EFS")
                        clear
                        echo -e "${banner}${RESET}"
                        sleep 2
                        batikuEFSlink=("Batiku + EFS Apps Admin Version" "Batiku + EFS Apps client Version" "Quit")
                        echo "Pilih Versi Apps yang anda inginkan :"
                        select batlink in "${batikuEFSlink[@]}"; do
                            case $batlink in
                            "Batiku + EFS Apps Admin Version")
                                # sudo ./asset/WebDinamis/batiku/AdminBatikuEFS.sh
                                ;;
                            "Batiku + EFS Apps client Version")
                                clear
                                echo -e "${banner}${RESET}"
                                sleep 2
                                # sudo ./asset/WebDinamis/batiku/batikuEFS.sh
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

    "Install Web Framework")
        clear
        echo -e "${banner}${RESET}"
        sleep 2
        echo "Pilih Karakter Framework yang kamu butuhkan ?"
        framework=("Framework static" "Framework dynamic" "Quit")
        select framework in "${framework[@]}"; do
            case $framework in
            "Framework static")
                clear
                echo -e "${banner}${RESET}"
                sleep 2
                message "Pilih Framework yang ingin anda install ?"
                PilFrameworkStatic=("NodeJS" "ReactJS" "NextJS" "Quit")
                select PilFrameworkStatic in "${PilFrameworkStatic[@]}"; do
                    case $PilFrameworkStatic in
                    "NodeJS")
                        sudo ./asset/framework/statis/nodejs/nodetegar.sh
                        break 2
                        ;;
                    "ReactJS")
                        clear
                        echo -e "${banner}${RESET}"
                        sleep 2
                        message "Pilih React JS yang ingin anda install ?"
                        pilreact=("ReactJS Template 1 - By OmTegar" "ReactJS T-movie By OmTegar" "ReactJS Template 2 - By OmTegar" "Quit")
                        select pilreact in "${pilreact[@]}"; do
                            case $pilreact in
                            "ReactJS Template 1 - By OmTegar")
                                sudo ./asset/framework/statis/reactjs/template1.sh
                                break 3
                                ;;
                            "ReactJS T-movie By OmTegar")
                                sudo ./asset/framework/statis/reactjs/tmovie.sh
                                break 3
                                ;;
                            "ReactJS Template 2 - By OmTegar")
                                sudo ./asset/framework/statis/reactjs/template2.sh
                                break 3
                                ;;
                            "Quit")
                                break 3
                                ;;
                            esac
                        done

                        ;;
                    "NextJS")
                        sudo ./asset/framework/statis/nextjs/nexttegar.sh
                        break 2
                        ;;
                    "Quit")
                        break 2
                        ;;
                    esac
                done
                ;;
            "Framework dynamic")
                clear
                echo -e "${banner}${RESET}"
                sleep 2
                echo "Mohon Maaf Fitur ini Masih Dalam Tahap Pengembangan. Nantikan Update TACP Di Versi berikutnya..........."
                break 2
                ;;
            "Quit")
                break 2
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

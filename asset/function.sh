#!/bin/bash

# Fungsi untuk menampilkan pesan
message() {
    echo "INFO: $1"
}

# Fungsi untuk menjalankan perintah update
run_update() {
    if apt-get update -y >/dev/null 2>&1; then
        message "Update sudah dijalankan sebelumnya, melanjutkan ke perintah berikutnya"
    else
        apt-get update -y
    fi
}

# Fungsi untuk menjalankan perintah progress bar
run_progress_bar() {
    local pid=$1
    while kill -0 $pid >/dev/null 2>&1; do
        echo -n "."
        sleep 1
    done
    echo ""
}

# Fungsi untuk menjalankan skrip web server static
run_web_static() {
    sudo ./asset/WebStatis/webstatis.sh
}

# Fungsi untuk menjalankan skrip web server dinamis
run_web_dinamis() {
    local app_options=("Datasiswa Apps" "Batiku Apps" "Quit")
    select app_option in "${app_options[@]}"; do
        case $app_option in
            "Datasiswa Apps")
                sudo ./asset/WebDinamis/datasiswa/webserver.sh
                ;;
            "Batiku Apps")
                sudo ./asset/WebDinamis/batiku/batiku.sh
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan skrip Datasiswa Apps
run_datasiswa_app() {
    local datasiswa_options=("Datasiswa Apps Basic" "Datasiswa Apps Basic + EFS" "Quit")
    select datasiswa_option in "${datasiswa_options[@]}"; do
        case $datasiswa_option in
            "Datasiswa Apps Basic")
                sudo ./asset/WebDinamis/datasiswa/webserver.sh
                message "Aplikasi Anda Sudah Terinstall Dengan Baik"
                message "Terimakasih Telah Menggunakan Layanan kami"
                break
                ;;
            "Datasiswa Apps Basic + EFS")
                sudo ./asset/WebDinamis/datasiswa/webserverEFS.sh
                message "Aplikasi Anda Sudah Terinstall Dengan Baik"
                message "Terimakasih Telah Menggunakan Layanan kami"
                break
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan skrip Batiku Apps
run_batiku_app() {
    local batiku_options=("Batiku Apps Basic" "Batiku Apps + EFS" "Quit")
    select batiku_option in "${batiku_options[@]}"; do
        case $batiku_option in
            "Batiku Apps Basic")
                sudo ./asset/WebDinamis/batiku/batiku.sh
                ;;
            "Batiku Apps + EFS")
                run_batiku_efs_app
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan skrip Batiku + EFS Apps
run_batiku_efs_app() {
    local batiku_efs_options=("Batiku + EFS Apps Admin Version" "Batiku + EFS Apps client Version" "Quit")
    select batiku_efs_option in "${batiku_efs_options[@]}"; do
        case $batiku_efs_option in
            "Batiku + EFS Apps Admin Version")
                # sudo ./asset/WebDinamis/batiku/AdminBatikuEFS.sh
                ;;
            "Batiku + EFS Apps client Version")
                # sudo ./asset/WebDinamis/batiku/batikuEFS.sh
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan skrip web framework
run_web_framework() {
    local framework_options=("Framework static" "Framework dynamic" "Quit")
    select framework_option in "${framework_options[@]}"; do
        case $framework_option in
            "Framework static")
                run_static_framework
                ;;
            "Framework dynamic")
                message "Mohon Maaf Fitur ini Masih Dalam Tahap Pengembangan. Nantikan Update TACP Di Versi berikutnya..........."
                break
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan framework statis
run_static_framework() {
    local static_frameworks=("NodeJS" "ReactJS" "NextJS" "Quit")
    select static_framework in "${static_frameworks[@]}"; do
        case $static_framework in
            "NodeJS")
                sudo ./asset/framework/statis/nodejs/nodetegar.sh
                break
                ;;
            "ReactJS")
                run_reactjs_framework
                break
                ;;
            "NextJS")
                sudo ./asset/framework/statis/nextjs/nexttegar.sh
                break
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

# Fungsi untuk menjalankan framework ReactJS
run_reactjs_framework() {
    local reactjs_options=("ReactJS Template 1 - By OmTegar" "ReactJS T-movie By OmTegar" "ReactJS Template 2 - By OmTegar" "Quit")
    select reactjs_option in "${reactjs_options[@]}"; do
        case $reactjs_option in
            "ReactJS Template 1 - By OmTegar")
                sudo ./asset/framework/statis/reactjs/template1.sh
                break
                ;;
            "ReactJS T-movie By OmTegar")
                sudo ./asset/framework/statis/reactjs/tmovie.sh
                break
                ;;
            "ReactJS Template 2 - By OmTegar")
                sudo ./asset/framework/statis/reactjs/template2.sh
                break
                ;;
            "Quit")
                break
                ;;
            *)
                message "Pilihan tidak valid, silakan coba lagi"
                ;;
        esac
    done
}

run_rsync_helper() {
    sudo ./asset/RsyncHelper/rsync.sh
}

run_Database_server() {
    sudo ./asset/DatabaseServer/database.sh
}

# Fungsi untuk menjalankan skrip FTP server
run_ftp_server() {
    sudo ./asset/FtpServer/proftpd.sh
}

# Fungsi untuk menjalankan skrip auto mount EBS
run_auto_mount_ebs() {
    sudo ./asset/AutoMountEBS/mountEBS.sh
}

# Fungsi untuk menjalankan skrip remote server
run_remote_server() {
    sudo ./asset/remote/remote.sh
}

# Fungsi untuk menjalankan skrip update package TACP
run_update_tacp() {
    sudo ./asset/updateapp/update.sh
}
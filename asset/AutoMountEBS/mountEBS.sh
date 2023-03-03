#!/bin/bash
apt install xfsprogs -y
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
warning=$(
    cat <<"EOF"
                               _               
                              (_)              
 __      __ __ _  _ __  _ __   _  _ __    __ _ 
 \ \ /\ / // _` || '__|| '_ \ | || '_ \  / _` |
  \ V  V /| (_| || |   | | | || || | | || (_| |
   \_/\_/  \__,_||_|   |_| |_||_||_| |_| \__, |
                                          __/ |
                                         |___/ 
EOF
)

echo "$banner"
echo " "
echo "$warning"
echo ""
echo "Peringatan Penggunaan Script berikut akan otomatis berjalan "
pil=("Yes" "No")
echo "apakah anda memberikan kepercayaan kepadakami ?"
select pil in "${pil[@]}"; do
    case $pil in
    "Yes")
        clear
        echo "$banner"
        sleep 2
        echo "Please enter your choice: "
        con=("Mount Ke Directory yang sudah ada " "Mount Ke Directory Baru")
        select con in "${con[@]}"; do
            case $con in
            "Mount Ke Directory yang sudah ada ")
                clear
                echo "$banner"
                sleep 2
                echo "Jika anda menggunakan layanan kami sebelum nya maka Directory anda ada pada ( / )"
                echo "Dimana Anda menaruh Mount Point EBS anda?"
                read default
                echo "CEK DIRECTORY EBS ANDA :"
                df -h
                lsblk
                cd $default
                ls
                echo " "
                echo "Masukkan mount point EBS:"
                read mount_point

                echo "Masukkan nama directory yang akan di mount :"
                read directory_name

                sudo mkfs -t xfs $mount_point
                sudo mount $mount_point $directory_name
                df -h
                echo "Apakah directory sudah termounting dengan benar"
                sleep 1
                break 2
                ;;

            "Mount Ke Directory Baru")
                clear
                echo "$banner"
                sleep 2
                echo "CEK DIRECTORY EBS ANDA :"
                df -h
                lsblk
                echo "Masukkan mount point EBS:"
                read mount_point

                echo "Masukkan nama directory yang akan ditambahkan:"
                read directory_name

                cd /
                ls
                sudo mkdir $directory_name
                sudo mkfs -t xfs $mount_point
                sudo mount $mount_point $directory_name
                df -h
                echo "Apakah directory sudah termounting dengan benar"
                sleep 1
                echo "Directory Mount EBS Anda berada pada directory ( / )"
                break 2
                ;;
            esac
        done

        ;;
    "No")
        break
        ;;
    esac
done
sleep 2

#!/bin/bash

source ./asset/view.sh

sudo apt-get install rsync -y & progress_bar $!
clear
echo -e "${banner}${RESET}"
sleep 2

# Fungsi untuk melakukan rsync lokal
perform_local_rsync() {
  # Mendapatkan path sumber dari pengguna
  message "Masukkan path sumber:"
  echo "Your Answer : "
  read source_path

  # Mendapatkan path tujuan dari pengguna
  message "Masukkan path tujuan:"
  echo "Your Answer : "
  read destination_path

  # Mendapatkan opsi rsync dari pengguna
  message "Pilih opsi rsync:"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "| No  |        Opsi         |                      Keterangan                         |"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "|  1  | -a                  | Mode arsip (rekursif, mempertahankan izin, dll.)        |"
  echo "|  2  | -v                  | Keluaran verbose                                        |"
  echo "|  3  | -z                  | Kompresi data file selama transfer                      |"
  echo "|  4  | -P                  | Setara dengan -v --partial --progress                   |"
  echo "|  5  | Opsi kustom         | Opsi kustom                                             |"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "Your Answer : "
  read -p "Masukkan nomor pilihan (nomor yang dipisahkan koma atau '5' untuk opsi kustom):" rsync_options

  # Mengatur opsi rsync berdasarkan pilihan pengguna
  options=""
  case $rsync_options in
    1)
      options+="a"
      ;;
    2)
      options+="v"
      ;;
    3)
      options+="z"
      ;;
    4)
      options+="P"
      ;;
    5)
      warning_message "Masukkan opsi kustom:"
      echo "Your Answer : "
      read custom_options
      options+="$custom_options"
      ;;
    *)
      error_message "Pilihan tidak valid. Menggunakan opsi default: -avz"
      options="avz"
      ;;
  esac

  # Perintah rsync
  rsync_command="rsync -$options --progress $source_path $destination_path"

  # Menjalankan perintah rsync
  $rsync_command

  # Memeriksa status keluaran rsync
  if [ $? -eq 0 ]; then
    success_message "Rsync berhasil dilakukan."
  else
    error_message "Rsync gagal dilakukan."
  fi
}

# Fungsi untuk melakukan rsync ke server remote
perform_remote_rsync() {
  # Mendapatkan path sumber dari pengguna
  message "Masukkan path sumber:"
  echo "Your Answer : "
  read source_path

  # Mendapatkan path tujuan dari pengguna
  message "Masukkan path tujuan:"
  echo "Your Answer : "
  read destination_path

  # Mendapatkan opsi rsync dari pengguna
  message "Pilih opsi rsync:"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "| No  |        Opsi         |                      Keterangan                         |"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "|  1  | -a                  | Mode arsip (rekursif, mempertahankan izin, dll.)        |"
  echo "|  2  | -v                  | Keluaran verbose                                        |"
  echo "|  3  | -z                  | Kompresi data file selama transfer                      |"
  echo "|  4  | -P                  | Setara dengan -v --partial --progress                   |"
  echo "|  5  | Opsi kustom         | Opsi kustom                                             |"
  echo "+-----+---------------------+---------------------------------------------------------+"
  echo "Your Answer : "
  read -p "Masukkan nomor pilihan (nomor yang dipisahkan koma atau '5' untuk opsi kustom):" rsync_options

  # Mengatur opsi rsync berdasarkan pilihan pengguna
  options=""
  case $rsync_options in
    1)
      options+="a"
      ;;
    2)
      options+="v"
      ;;
    3)
      options+="z"
      ;;
    4)
      options+="P"
      ;;
    5)
      warning_message "Masukkan opsi kustom:"
      echo "Your Answer : "
      read custom_options
      options+="$custom_options"
      ;;
    *)
      error_message "Pilihan tidak valid. Menggunakan opsi default: -avz"
      options="avz"
      ;;
  esac

  # Mendapatkan informasi server remote dari pengguna
  message "Masukkan informasi server remote:"
  echo "Your Answer : "
  read -p "Username:" username
  read -p "Hostname:" hostname
  read -p "Port (default 22):" port

  # Perintah rsync
  rsync_command="rsync -$options --progress -e 'ssh -p $port' $source_path $username@$hostname:$destination_path"

  # Menjalankan perintah rsync
  $rsync_command

  # Memeriksa status keluaran rsync
  if [ $? -eq 0 ]; then
    success_message "Rsync berhasil dilakukan."
  else
    error_message "Rsync gagal dilakukan."
  fi
}

# Menampilkan menu utama
while true; do
  echo "+-----------------------------------------+"
  echo "|                 Menu                    |"
  echo "+-----------------------------------------+"
  echo "|  1. Rsync Lokal                         |"
  echo "|  2. Rsync ke Server Remote              |"
  echo "|  3. Keluar                              |"
  echo "+-----------------------------------------+"
  echo "Your Answer : "
  read -p "Pilih menu (1-3):" choice

  case $choice in
    1)
      perform_local_rsync
      ;;
    2)
      perform_remote_rsync
      ;;
    3)
      exit 0
      ;;
    *)
      error_message "Pilihan tidak valid."
      ;;
  esac
done

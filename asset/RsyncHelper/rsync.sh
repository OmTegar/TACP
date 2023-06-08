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
      echo "Your Answer : "
      options="avz"
      ;;
  esac

  # Perintah rsync
  rsync_command="rsync -$options --progress $source_path $destination_path"

  # Menjalankan perintah rsync
  $rsync_command
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
      echo "Your Answer : "
      options="avz"
      ;;
  esac

  # Mendapatkan server sumber dari pengguna
  message "Masukkan server sumber (username@server):"
  echo "Your Answer : "
  read source_server

  # Mendapatkan server tujuan dari pengguna
  message "Masukkan server tujuan (username@server):"
  echo "Your Answer : "
  read destination_server

  # Mendapatkan path ke file .pem dari pengguna
  message "Masukkan path ke file .pem:"
  echo "Your Answer : "
  read pem_path

  # Perintah rsync
  rsync_command="rsync -$options --progress -e 'ssh -i $pem_path' $source_server:$source_path $destination_path"

  # Menjalankan perintah rsync
  $rsync_command
}

# Fungsi untuk menambahkan cronjob
add_cronjob() {
  # Mendapatkan path dari directory HasilRsync.sh
  rsync_directory="/home/rsync-TACP"
  rsync_script_path="$rsync_directory/HasilRsync_$(date +'%Y%m%d%H%M%S').sh"

  # Memeriksa apakah direktori rsync-TACP sudah ada atau belum
  if [ ! -d "$rsync_directory" ]; then
    # Membuat direktori baru jika belum ada
    mkdir -p "$rsync_directory"
  fi

  # Menanyakan pengguna apakah ingin menambahkan cronjob
  message "Apakah Anda ingin menambahkan cronjob untuk script rsync? (y/n)"
  echo "Your Answer : "
  read cronjob_option

  if [ "$cronjob_option" = "y" ]; then
    # Menanyakan pengguna waktu (hitungan menit) untuk menjalankan cronjob
    message "Masukkan waktu cronjob (hitungan menit):"
    echo "Your Answer : "
    read cron_minutes

    # Validasi apakah input waktu cron adalah angka
    if [[ "$cron_minutes" =~ ^[0-9]+$ ]]; then
      # Menambahkan cronjob untuk menjalankan script rsync
      (crontab -l ; echo "$cron_minutes * * * * /bin/bash $rsync_script_path") | crontab -
      message "Cronjob berhasil ditambahkan."
    else
      error_message "Waktu cron tidak valid. Cronjob tidak ditambahkan."
    fi
  else
    message "Cronjob tidak ditambahkan."
  fi
}


# Mendapatkan mode rsync dari pengguna
message "Pilih mode rsync:"
echo "+-----+-----------------------+------------------------------------+"
echo "| No  |         Mode          |            Keterangan              |"
echo "+-----+-----------------------+------------------------------------+"
echo "|  1  | Rsync lokal           | Melakukan rsync pada localhost     |"
echo "|  2  | Rsync ke server remote| Melakukan rsync ke server remote   |"
echo "+-----+-----------------------+------------------------------------+"
read -p "Masukkan pilihan Anda (1 atau 2):" rsync_mode

case $rsync_mode in
  1)
    perform_local_rsync
    ;;
  2)
    perform_remote_rsync
    ;;
  *)
    error_message "Pilihan tidak valid."
    ;;
esac

# Menanyakan pengguna untuk menambahkan cronjob
add_cronjob

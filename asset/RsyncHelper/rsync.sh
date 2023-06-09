#!/bin/bash

source ./asset/view.sh

# Pengecekan rsync
if ! command -v rsync &> /dev/null; then
  # Jika rsync belum terinstall, lakukan instalasi
  sudo apt-get install rsync -y & progress_bar $!
fi

clear
echo -e "${banner}${RESET}"
sleep 2

# Fungsi untuk melakukan rsync lokal
perform_local_rsync() {
  # Mendapatkan path sumber dari pengguna
  message "Masukkan path sumber:"
  read -p "Your Answer : " source_path

  # Mendapatkan path tujuan dari pengguna
  message "Masukkan path tujuan:"
  read -p "Your Answer : " destination_path

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
      warning_message "Masukkan opsi kustom (tanpa tanda minus [-] atau spasi):"
      read -r -a custom_options_array
      options+="${custom_options_array[*]}"
      ;;
    *)
      # Memisahkan opsi menjadi karakter individu
      options=$(echo "$rsync_options" | sed 's/./& /g')
      ;;
  esac

  # Perintah rsync
  rsync_command="rsync -$options --progress $source_path $destination_path"

  # Menjalankan perintah rsync
  $rsync_command

  # Memeriksa status keluaran rsync
  if [ $? -eq 0 ]; then
    success_message "Rsync berhasil dilakukan."

    # Mendapatkan path dari directory HasilRsync.sh
    rsync_directory="/home/Cronjob-TACP/RsyncCommand"
    sudo mkdir -p "$rsync_directory"
    sudo chmod 755 "$rsync_directory"

    rsync_script_path="$rsync_directory/HasilRsync_$(date +'%Y%m%d%H%M%S').sh"

    # Memeriksa apakah direktori rsync-TACP sudah ada atau belum
    if [ ! -d "$rsync_directory" ]; then
      # Membuat direktori baru jika belum ada
      mkdir -p "$rsync_directory"
      success_message "Direktori rsync-TACP telah dibuat di $rsync_directory"
    fi

    # Membuat file script HasilRsync.sh
    echo "#!/bin/bash" | sudo tee "$rsync_script_path" > /dev/null
    echo "$rsync_command" | sudo tee -a "$rsync_script_path" > /dev/null

    success_message "File HasilRsync.sh telah dibuat di $rsync_script_path"

    # Menambahkan cronjob untuk menjalankan script HasilRsync.sh
    message "Apakah Anda ingin menambahkan cronjob untuk menjalankan script HasilRsync.sh? (y/n)"
    read -p "Your Answer : " add_cronjob

    if [ "$add_cronjob" == "y" ]; then
      message "Masukkan waktu cronjob (dalam hitungan menit):"
      read -p "Your Answer : " cronjob_minutes

      # Menambahkan cronjob
      (crontab -l ; echo "*/$cronjob_minutes * * * * bash $rsync_script_path") | crontab -
      success_message "Cronjob berhasil ditambahkan."
    else
      success_message "Cronjob tidak ditambahkan."
    fi
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
      warning_message "Masukkan opsi kustom (pisahkan dengan spasi):"
      echo "Your Answer : "
      read -r -a custom_options_array
      options+="${custom_options_array[*]}"
      ;;
    *)
      options=$(echo "$rsync_options" | sed 's/./& /g')
      ;;
  esac

  # Memisahkan opsi kustom menjadi opsi individual
  custom_options_array=($custom_options)
  for opt in "${custom_options_array[@]}"; do
    options+="$opt"
  done

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
      break 2
      ;;
    *)
      error_message "Pilihan tidak valid."
      ;;
  esac
done

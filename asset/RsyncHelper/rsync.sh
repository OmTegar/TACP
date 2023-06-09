#!/bin/bash

source ./asset/view.sh

# Pengecekan rsync
if ! command -v rsync &> /dev/null; then
  # Jika rsync belum terinstall, lakukan instalasi
  sudo apt-get install rsync sshpass -y & progress_bar $!
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

  # Memisahkan opsi kustom menjadi opsi individual
  custom_options_array=($options)

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

# Fungsi untuk melakukan rsync ke server remote menggunakan password
perform_remote_rsync_with_password() {
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

  # Memisahkan opsi kustom menjadi opsi individual
  custom_options_array=($options)
  for opt in "${custom_options_array[@]}"; do
    options+="$opt"
  done

  # Mendapatkan informasi server remote dari pengguna
  message "Masukkan informasi server remote:"
  read -p "Username:" username
  read -p "Hostname:" hostname
  read -p "Port (default 22):" port
  read -p "Password:" password

  # Perintah rsync
  rsync_command="sshpass -p '$password' rsync -$options --progress -e 'ssh -p $port' $source_path $username@$hostname:$destination_path"

  # Menjalankan perintah rsync
  eval "$rsync_command"

  # Memeriksa status keluaran rsync
  if [ $? -eq 0 ]; then
    success_message "Rsync berhasil dilakukan."

    # Mendapatkan path dari directory HasilRsync.sh
    rsync_directory="/home/Cronjob-TACP/RsyncServer"
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

# Fungsi untuk melakukan rsync ke server remote menggunakan private key .pem
perform_remote_rsync_with_pem() {
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

  # Memisahkan opsi kustom menjadi opsi individual
  custom_options_array=($options)
  for opt in "${custom_options_array[@]}"; do
    options+="$opt"
  done

  # Mendapatkan informasi server remote dari pengguna
  message "Masukkan informasi server remote:"
  read -p "Username:" username
  read -p "Hostname:" hostname
  read -p "Port (default 22):" port

  message "Apakah Anda ingin menggunakan RSA Private Key yang sudah ada? (y/n)"
  read -p "Your Answer : " use_existing_key

  if [ "$use_existing_key" == "y" ]; then
    message "Apakah Anda Akan Menggunakan file .pem Yang Sudah Pernah Anda Inputkan ? (y/n)"
    read -p "Your Answer : " pem_in_pem_directory

    if [ "$pem_in_pem_directory" == "y" ]; then
      # Mendapatkan file .pem yang tersedia di pem_directory
      pem_files=($(ls -p /home/Cronjob-TACP/RsyncServer | grep '\.pem$' | grep -v /))
      num_pem_files=${#pem_files[@]}

      if [ "$num_pem_files" -eq 0 ]; then
        error_message "Tidak ada file .pem yang tersedia di pem_directory."
        return
      fi

      # Menampilkan list file .pem yang tersedia di pem_directory
      message "Pilih file .pem yang akan digunakan:"
      for ((i=0; i<$num_pem_files; i++)); do
        echo "$(($i+1)). ${pem_files[$i]}"
      done

      selected_pem_index=0
      while [[ ! "$selected_pem_index" =~ ^[0-9]+$ || "$selected_pem_index" -lt 1 || "$selected_pem_index" -gt $num_pem_files ]]; do
        read -p "Masukkan nomor pilihan (1-$num_pem_files):" selected_pem_index
      done

      selected_pem_file="${pem_files[$(($selected_pem_index-1))]}"
      pem_path="/home/Cronjob-TACP/RsyncServer/$selected_pem_file"
    else
      message "Masukkan path file .pem:"
      read -p "Your Answer : " pem_path

      if [ ! -f "$pem_path" ]; then
        error_message "File .pem tidak ditemukan."
        return
      fi

      # Copy file .pem ke pem_directory
      pem_filename=$(basename "$pem_path")
      pem_directory="/home/Cronjob-TACP/RsyncServer(.pem)"
      sudo mkdir -p "$pem_directory"
      sudo chmod 755 "$pem_directory"
      sudo cp "$pem_path" "$pem_directory/$pem_filename"
      pem_path="$pem_directory/$pem_filename"

      # Memberikan perizinan chmod pada file .pem
      sudo chmod 400 "$pem_path"
    fi

    # Perintah rsync
    rsync_command="rsync -$options --progress -e 'ssh -p $port -i $pem_path' $source_path $username@$hostname:$destination_path"

    # Menjalankan perintah rsync
    $rsync_command

    # Memeriksa status keluaran rsync
    if [ $? -eq 0 ]; then
      success_message "Rsync berhasil dilakukan."

      rsync_script_path="/home/Cronjob-TACP/RsyncServer(.pem)/HasilRsync_$(date +'%Y%m%d%H%M%S').sh"

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
        success_message "Cronjob telah ditambahkan."
      else
        success_message "Cronjob tidak ditambahkan."
      fi
    else
      error_message "Rsync gagal dilakukan."
    fi
  else
    warning_message "Private key RSA tidak digunakan."
    pem_path=""
    rsync_command="rsync -$options --progress -e 'ssh -p $port' $source_path $username@$hostname:$destination_path"
    $rsync_command

    # Memeriksa status keluaran rsync
    if [ $? -eq 0 ]; then
      success_message "Rsync berhasil dilakukan."
    else
      error_message "Rsync gagal dilakukan."
    fi
  fi
}



# Memulai program rsync-TACP
message "Selamat datang di rsync-TACP!"
message "Silakan pilih opsi rsync yang ingin Anda gunakan:"
echo "+-----+-------------------------------+"
echo "| No  |        Jenis Rsync           |"
echo "+-----+-------------------------------+"
echo "|  1  | Rsync ke server lokal        |"
echo "|  2  | Rsync ke server remote       |"
echo "|  3  | Rsync ke server remote (pem) |"
echo "+-----+-------------------------------+"
read -p "Masukkan nomor pilihan Anda:" rsync_type

case $rsync_type in
  1)
    perform_local_rsync
    ;;
  2)
    perform_remote_rsync_with_password
    ;;
  3)
    perform_remote_rsync_with_pem
    ;;
  *)
    error_message "Opsi tidak valid. Silakan pilih nomor yang valid."
    ;;
esac

message "Terima kasih telah menggunakan rsync-TACP!"

  #ini adalah perintah yang di butuhkan server target 
  #sudo chown -R ec2-user:ec2-user /home/ec2-user/app-log/
  #sudo chmod -R 755 /home/ec2-user/app-log/
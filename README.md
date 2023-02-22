# TAC - Project

===========================================================================

Aplikasi ini dibuat untuk mempermudah konfigurasi anda dalam berbagai aspek seperti 
- mount directory EBS
- Hosting Web Apps 
- Hosting Web Apps + Database
- FTP Server

Fitur Fitur Diatas saya buat menggunakan Learner Lab 
dengan instance <strong>Ubuntu</strong> yang satu basis dengan <strong>Debian</strong>
Diharapkan Aplikasi ini dapat membantu anda dalam proses pengembangan atau pembelajaran anda.
jika anda memilih beberapa opsi di bawah ada beberapa requirement yang harus di penuhi sebelum installasi sebagai berikut.

===========================================================================
# Requirement
Jika anda memilih opsi sebagai berikut :
1. <strong>datasiswa Apps Basic + EFS</strong> maka mount point yang harus anda gunakan untuk EFS anda adalah : <br>
<code>/var/www/web-project3/asset/images/</code>
2. <strong>Batiku + EFS Apps Admin Version/</strong> maka mount point yang harus anda gunakan untuk EFS anda adalah :
<code>/var/www/batiku/admin/proses/image/</code>
3. <strong>Batiku + EFS Apps client Version</strong> maka mount point yang harus anda gunakan untuk EFS anda adalah :
<code>/var/www/batiku/admin/proses/image/</code>

===========================================================================
# Cara-pengunaan
1. Masuk Ke directory TACP 
<code>cd TACP/</code>
2. Beri Akses index untuk boot di dalam instance
<code>chmod +x index.sh</code>
3. Running Apps dengan perintah
<code>sudo ./index.sh</code>

===========================================================================
# Update-TACP
Jika anda melakukan update TACP menggunakan fitur yang 
sudah tersedia pada package ini maka anda perlu melakukan beberapa
langkah sebagai berikut : <br>
1. masuk ke directory TACP
2. lakukan <code>chmod +x index.sh</code><br>

Package sudah siap di jalankan ulang.

===========================================================================
Sekian Dari saya Terimakasih 

- <a href="https://github.com/OmTegar">OmTegar</a>




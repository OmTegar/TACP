#!/bin/bash

#   IKI SENG USERDATA MYTEMPLATE
RDSmountpoint="database-1.cu57i22zqmlj.us-east-1.rds.amazonaws.com"
UsernameRDS="admin"
passwordRDS="Admin12345"
EFSid="fs-037d0cdc772b08a62"

sudo apt update
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install nodejs -y

sudo apt-get install rsync build-essential git mysql-client -y

sudo apt install binutils -y
git clone https://github.com/aws/efs-utils
cd efs-utils
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb

cd /home/ubuntu
sudo mkdir efs
sudo mount -t efs -o tls $EFSid:/ efs
df -h

cd /home/ubuntu/ && git clone https://github.com/adinur21/ukk.git
cd ukk/ && npm install

npm install --save express
npm install -g nodemon
npm install -g cors
npm install -g body-parser

cd /home/ubuntu/ukk/src/model/
sudo cat <<EOF >dbConnection.js
const mySql = require("mysql")

const db = mySql.createPool({
  host: "$RDSmountpoint",
  user: "$UsernameRDS",
  password: "$passwordRDS",
  database: "cloud_api"
})

exports.db = db;
EOF

sudo rsync -azP /home/ubuntu/ukk/ /home/ubuntu/efs/


#  IKI SCRIPT GAWE MASUKIN DATA NANG RDS
mysql -h database-1.cu57i22zqmlj.us-east-1.rds.amazonaws.com -u admin -p <<EOF

# Show existing databases
show databases;

# Create the datasiswa database
create database cloud_api;

# Use the datasiswa database
use cloud_api;

# create table
  CREATE TABLE guru (
  id_guru int(11) AUTO_INCREMENT PRIMARY KEY,
  nama_guru varchar(255),
  mapel_guru varchar(255),
  sekolah_guru varchar(255)
  );

# Import the SQL script to create tables and populate data
INSERT INTO guru (nama_guru, mapel_guru, sekolah_guru) VALUES ('Adi','cloud','SMK Telkom Malang');
INSERT INTO guru (nama_guru, mapel_guru, sekolah_guru) VALUES ('Meera','Kuli Jawa','STM Kuli Telkom');
INSERT INTO guru (nama_guru, mapel_guru, sekolah_guru) VALUES ('Areta','Kuli Jawa','STM Kuli Telkom');
INSERT INTO guru (nama_guru, mapel_guru, sekolah_guru) VALUES ('Radit','Kuli Jawa','STM Kuli Telkom');

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM guru;

# Exit the MySQL prompt
EOF
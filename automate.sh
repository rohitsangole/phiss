#!/bin/bash

# Exit immediately if any command fails
set -e

echo "📦 Updating package index..."
sudo apt update

echo "📦 Installing Apache, MySQL, PHP, and Git..."
sudo apt install apache2 mysql-server git php libapache2-mod-php php-mysql -y

echo "🚀 Starting and enabling Apache and MySQL..."
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

echo "🔁 Cloning Git repository..."
git clone https://github.com/rohitsangole/phiss.git /tmp/phiss

echo "🧹 Removing default Apache files..."
sudo rm -rf /var/www/html/*

echo "📁 Copying website files to /var/www/html/..."
sudo cp -r /tmp/phiss/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html

echo "🛠️ Setting up MySQL database and user..."

# SQL commands to be executed
sudo mysql <<EOF
CREATE DATABASE userDB;
CREATE USER 'rohit'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON userDB.* TO 'rohit'@'localhost';
FLUSH PRIVILEGES;

USE userDB;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);
EOF

echo "✅ Setup complete! Visit your server's public IP to view the website."

#!/bin/bash

# Exit on any error
set -e

echo "📦 Updating package index..."
sudo apt update

echo "📦 Installing Apache, MySQL, PHP, and Git..."
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql git -y

echo "🚀 Starting and enabling Apache and MySQL..."
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

echo "🔁 Cloning Git repository..."
git clone https://github.com/rohitsangole/phiss.git /tmp/phiss

echo "🧹 Removing default Apache web files..."
sudo rm -rf /var/www/html/*

echo "📁 Deploying website to /var/www/html/..."
sudo cp -r /tmp/phiss/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html

echo "🛠️ Setting up MySQL database and user..."
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

echo "☕ Installing Java 17 (required for Jenkins)..."
sudo apt install openjdk-17-jdk -y

echo "🔑 Adding Jenkins repository key and source..."
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "📦 Updating package list and installing Jenkins..."
sudo apt update
sudo apt install jenkins -y

echo "🚀 Starting and enabling Jenkins..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "✅ All done! Access Jenkins on port 8080 and your website via Apache on port 80."
echo "🔑 Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

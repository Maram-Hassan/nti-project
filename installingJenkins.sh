#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Java (required for Jenkins)
echo "Installing Java..."
sudo apt install -y openjdk-11-jdk

# Add Jenkins repository key
echo "Adding Jenkins repository key..."
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Add Jenkins repository to the system's package source list
echo "Adding Jenkins repository to sources.list..."
echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index
echo "Updating package index..."
sudo apt update

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install -y jenkins

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Print Jenkins status
echo "Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

# Display initial admin password
echo "Fetching initial Jenkins admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword


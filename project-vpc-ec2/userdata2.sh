#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>Web Server 1</h1><p>Created using Terraform user_data</p>" > /var/www/html/index.html

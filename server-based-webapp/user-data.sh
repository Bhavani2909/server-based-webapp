#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from Auto Scaling EC2 in $(hostname -f)" > /var/www/html/index.html

#!/bin/bash
set -euxo pipefail
yum update -y
yum install -y httpd
systemctl enable --now httpd
echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html

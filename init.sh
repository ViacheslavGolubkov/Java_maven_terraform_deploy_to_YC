#!/bin/bash
rm hosts.txt
echo "[all]" | tee -a hosts.txt
#Terraform
terraform init
terraform apply -auto-approve
VAR1=$(terraform output external_ip_address_java_app | tr -d \") 
echo "java_app    ansible_host=${VAR1} ansible_user=ubuntu" | tee -a hosts.txt
VAR2=$(terraform output external_ip_address_monitor | tr -d \") 
echo "monitoring    ansible_host=${VAR2} ansible_user=ubuntu" | tee -a hosts.txt

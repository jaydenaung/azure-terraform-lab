# Azure Terraform Lab for Demo
---
This is just a repository of Terraform scripts that will create a lab environment on Azure. The scripts will create the following: 

- VNET
- Subnets
- Route Tables
- Load Balancer
- Virtual Machine Scale-set (VMSS) with backend Virtual Machines

> (Cloud init script will automatically deploy  a demo web application on the virtual machines.)
---
## Usage

Execute the followings in the directory:
```bash 
terraform init
terraform plan
terraform apply
```
***Happy Terraforming!***

Best,\
Jayden Aung

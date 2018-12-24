# Devops Task From Bonial

1. [Terraform_Template](#Terraform_Template)

## Terraform Template

1. [Goal](#Goal)
3. [Installation](#installation)
4. [Deployment](#deployment)

## Goal
- This template `main.tf` deploy nginx docker container with a html file.
- Sending a HTTP request, you should return the response `My Resume`
- This can be run on any region.
- User can change the necessary parameter

## Installation

Specs:
- Default VPC
- Security Group
- Instance Type: t2.micro
- AMI: Debian-Stretch
- Docker with nginx container
- ELB

1. Should have necessary privilege on aws
2. Create a key pair for accessing Application server
3. You are deploying Terraform Templates via Terraform CLI
4. Do not forget to change terraform.tfvars and fill your personal information

## Deployment

Download the zip file which already shared or you can clone the git repo to your local machine

`git clone https://github.com/arifurreza/bonial_exercise.git`

To check what recurses will be created

`$ terraform plan`

To create EC2 instances and their dependencies:

`$ terraform apply`

Things achieved by executing the template:

- Create a ec2 instance with Debian-Stretch image.

- Install Docker on the ec2 inastance and pull the nginx image and RUN nginx docker conainter
	
- Create a Loadbalancer and listen with http protocol. And it's forward all the traffic to ec2 instance via 80 port.

- At the end, you can output the Instance DNS & Loadbalancer DNS address.

To destroy all:

`$ terraform destroy`
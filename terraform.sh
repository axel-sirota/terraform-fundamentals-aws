#!/usr/bin/env bash

cd $@
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"

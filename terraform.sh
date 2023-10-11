#!/usr/bin/env bash

cd "$1" || exit

if [ "$2" == "" ]; then
  terraform init
  terraform fmt -recursive
  terraform validate
  terraform plan -out plan.tfplan
  terraform apply "plan.tfplan"
else
  if [ "$2" == "destroy" ]; then
    terraform destroy --auto-approve
  fi
fi

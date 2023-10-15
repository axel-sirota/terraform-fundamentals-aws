#!/usr/bin/env bash

cd "$1" || exit

plan() {
  terraform init
  terraform fmt -recursive
  terraform validate
  terraform plan -out plan.tfplan
}

if [ "$2" == "" ]; then
  plan
  terraform apply "plan.tfplan"
else
  if [ $2 == "check-plan" ]; then
    plan
  fi
  if [ "$2" == "destroy" ]; then
    terraform destroy --auto-approve
  fi
fi

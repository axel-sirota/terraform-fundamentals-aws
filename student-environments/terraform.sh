#!/bin/bash

export TF_VAR_pgp_key=$(gpg --export "Axel Sirota" | base64)
terraform init
terraform $@

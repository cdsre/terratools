# Terratools

## Overview
This docker image provides terratools such as [terraform](https://www.terraform.io/) and 
[terragrunt](https://terragrunt.gruntwork.io/). It is built using the GoLang image as its base which means it will also 
be able to do terratest for writting infrastructure unit test. The docker includes the 
[vault](https://www.hashicorp.com/products/vault) binary to provide easy integration to vault for secrets and AWS 
credentials. If you want to use hashicorp vault CLI you will need to provide the `VAULT_ADDR` and `VAULT_TOKEN` 
environment variables

## HashiCorp Licence
Following announcement of HashiCorp changing the licence, all HashiCorp products in this image use the latest versions 
on the MPL 2.0 licence. This ensures compliance with other competitors tools such as gruntworks tools that are also 
included in this image.

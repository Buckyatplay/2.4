
terraform {
  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    region = "ap-southeast-1"
    key = "choonyee2-4.tfstate" #Name of your tfstate file. It must be different from other projects 
  }
  }

###############################################################################
# 
# MAIN
#
###############################################################################

###############################################################################
# TERRAFORM ###################################################################
terraform {
  required_version = ">= 0.12.18"

  backend "s3" {
    bucket         = "tf-backend-remote-state"
    key            = "terraform.tfstate"
    dynamodb_table = "tf-remote-state-lock"
    region         = "us-east-1"
  }
}
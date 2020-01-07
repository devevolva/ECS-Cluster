###############################################################################
# 
# S3 REMOTE STATE WITH DYNAMO DB LOCKING INFRASTRUCTURE
#
# Run before apply ../Main.tf on setup, run after on destroy
#
###############################################################################

###############################################################################
# VERSION #####################################################################
terraform {
  required_version = ">= 0.12.18"
}

###############################################################################
# PROVIDER ####################################################################
provider "aws" {
    region  = "us-east-1"
}


###############################################################################
# BUCKET ######################################################################
data "template_file" "remote_state_bucket_policy" {
  template = "${file("C:/Git/ECS Cluster/backend infrastructure/s3_tf_remote_state_policy.json")}"

  vars = {
    bucket = var.tf_backend_remote_state_bucket
  }
}

resource "aws_s3_bucket" "tfRemoteState" {
  bucket    = var.tf_backend_remote_state_bucket
  acl       = "private"
  policy    = data.template_file.remote_state_bucket_policy.rendered

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}


###############################################################################
# DYNAMODB ####################################################################
resource "aws_dynamodb_table" "tfStateLock" {
  name           = var.tf-remote-state-lock_ddb_table
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name         = "LockID"
    type         = "S"
  }
}

###############################################################################
# 
# VARIABLES
#
###############################################################################

###############################################################################
# BUCKET ######################################################################
variable "tf_backend_remote_state_bucket" {
    description = "S3 bucket used to hold Terraform remote state."
    default     = "tf-backend-remote-state"
}


###############################################################################
# DYNAMODB ####################################################################
variable "tf-remote-state-lock_ddb_table" {
    description = "Dynamo DB table used to hold Terraform remote state locks."
    default     = "tf-remote-state-lock"
}
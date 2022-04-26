# Environment: common
# Terraform Workspace: common
# Latest update: 2022/03/20

module "tfstate" {
  source            = "../../modules/tf_state"
  bucket_name       = var.tfstate.bucket_name
  dynamo_table_name = var.tfstate.dynamo_table_name
  ip                = var.ip
}
#################################################
# ECR 
#################################################
resource "aws_ecr_repository" "ecr" {
  for_each = { for i in var.ecr.private : i.name => i }
  name     = each.value.name

  dynamic "encryption_configuration" {
    for_each = [{ type = each.value.encrypt_type, kms_key = each.value.encrypt_key }]
    content {
      encryption_type = encryption_configuration.value.type
      kms_key         = encryption_configuration.value.kms_key
    }
  }
  image_tag_mutability = each.value.tag_mutable ? "MUTABLE" : "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
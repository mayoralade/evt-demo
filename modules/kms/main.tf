resource "aws_kms_key" "default" {
  description              = "${upper(var.environment)} KMS Key"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "default" {
  name = "alias/${var.environment}/default"
  target_key_id = aws_kms_key.default.key_id
}

output "key_alias" {
  description = "KMS Key Alias"
  value       = aws_kms_alias.default.name
}

output "key_arn" {
  description = "KMS Key ARN"
  value       = aws_kms_key.default.arn
}

output "key_id" {
  description = "KMS Key ID"
  value       = aws_kms_key.default.id
}

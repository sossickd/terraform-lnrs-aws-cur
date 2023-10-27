output "cur-athena-bucket" {
  description = "The name/id cur athena s3 bucket name."
  value       = aws_s3_bucket.cur-athena.id
}
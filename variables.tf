variable "account_id" {
  description = "Name of the account."
  type        = string
  nullable    = false
}

variable "partition" {
  description = "AWS partition."
  type        = string
  default     = "aws"
  nullable    = false
}

variable "cur_report_s3_bucket_region" {
  description = "CUR Athena bucket region."
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "cur_report_s3_prefix" {
  description = "CUR S3 prefix"
  type        = string
  default     = "opencost-prefix/opencost-report"
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}

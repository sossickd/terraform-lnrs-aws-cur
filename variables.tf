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

variable "cur_athena_bucket_region" {
  description = "CUR Athena bucket region."
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}

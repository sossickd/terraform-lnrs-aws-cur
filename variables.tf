variable "partition" {
  description = "AWS partition."
  type        = string
  nullable    = false
  default     = "aws"
}

variable "account_id" {
  description = "The account ID."
  type        = string
  nullable    = false
  default     = ""
}

variable "cluster_name" {
  description = "The name of the EKS cluster that has been created."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = false
  default     = {}
}

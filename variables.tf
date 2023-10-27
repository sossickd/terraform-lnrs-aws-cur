variable "cluster_name" {
  description = "The name of the EKS cluster that has been created."
  type        = string
  nullable    = false
}

variable "cur_athena_bucket_region" {
  description = "CUR Athena bucket region."
  type        = string
  nullable    = false
}
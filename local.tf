locals {
  cur_report_name             = "eks-cost-usage-report-${var.account_id}"
  cur_report_s3_bucket_region = "us-east-1"
  cur_report_s3_prefix        = "opencost-prefix/opencost-report"
}

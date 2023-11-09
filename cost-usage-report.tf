resource "aws_cur_report_definition" "cur_report_definition" {
  report_name                = "eks-cost-usage-report-${var.account_id}"
  time_unit                  = "DAILY"
  compression                = "Parquet"
  format                     = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = "eks-cost-usage-report-${var.account_id}"
  s3_region                  = var.cur_athena_bucket_region
  s3_prefix                  = "opencost-prefix/opencost-report"
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"

  depends_on = [
    aws_s3_bucket.athena_query_results
  ]
}
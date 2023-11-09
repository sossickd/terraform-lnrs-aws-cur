resource "aws_cur_report_definition" "cur_report_definition" {
  report_name                = "eks-cost-usage-report-${var.account_id}"
  time_unit                  = "DAILY"
  compression                = "Parquet"
  format                     = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.cost_and_usage_report.id
  s3_region                  = local.cur_report_s3_bucket_region
  s3_prefix                  = local.cur_report_s3_prefix
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"

  depends_on = [
    aws_s3_bucket.athena_query_results,
    aws_s3_bucket.cost_and_usage_report
  ]
}
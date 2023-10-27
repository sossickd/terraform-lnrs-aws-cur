resource "aws_cur_report_definition" "example_cur_report_definition" {
  report_name                = "${var.cluster_name}-cur-report"
  time_unit                  = "DAILY"
  compression                = "Parquet"
  format                     = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = aws_s3_bucket.cur-athena.id
  s3_region                  = aws_s3_bucket.cur-athena.region
  s3_prefix                  = "opencost-prefix/${var.cluster_name}-opencost-report"
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"
}
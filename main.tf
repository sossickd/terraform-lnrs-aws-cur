resource "aws_cur_report_definition" "cur_report_definition" {
  report_name                = "${var.cluster_name}-cur-report"
  time_unit                  = "DAILY"
  compression                = "Parquet"
  format                     = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = "${var.cluster_name}-cur-athena"
  s3_region                  = var.cur_athena_bucket_region
  s3_prefix                  = "opencost-prefix/${var.cluster_name}-opencost-report"
  additional_artifacts       = ["ATHENA"]
  report_versioning          = "OVERWRITE_REPORT"
}
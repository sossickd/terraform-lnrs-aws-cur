#tfsec:ignore:aws-athena-enable-at-rest-encryption
resource "aws_athena_workgroup" "athena_output" {
  name = "secondary"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_query_results.bucket}/"
    }
  }

  depends_on = [
    aws_s3_bucket.athena_query_results
  ]

}
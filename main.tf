#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "cur-athena" {
  bucket = "${var.cluster_name}-us-east-1-cur-athena"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-us-east-1-cur-athena"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "cur-athena" {
  bucket = aws_s3_bucket.cur-athena.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

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
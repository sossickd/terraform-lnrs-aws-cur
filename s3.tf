#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "cost_and_usage_report" {
  bucket = "cost-and-usage-report-eks-${var.account_id}"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "cost-and-usage-report-eks-${var.account_id}"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "cost_and_usage_report" {
  bucket = aws_s3_bucket.cost_and_usage_report.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cost_and_usage_report" {
  bucket = aws_s3_bucket.cost_and_usage_report.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "cost_and_usage_report" {
  bucket = aws_s3_bucket.cost_and_usage_report.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "cost_and_usage_report" {
  bucket = aws_s3_bucket.cost_and_usage_report.id
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "Policy1335892530063",
    "Statement" : [
      {
        "Sid" : "Stmt1335892150622",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ],
        "Resource" : "arn:${var.partition}:s3:::${aws_s3_bucket.cost_and_usage_report.id}",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : "arn:aws:cur:us-east-1:${var.account_id}:definition/*",
            "aws:SourceAccount" : "${var.account_id}"
          }
        }
      },
      {
        "Sid" : "Stmt1335892526596",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "billingreports.amazonaws.com"
        },
        "Action" : [
          "s3:PutObject"
        ],
        "Resource" : "arn:${var.partition}:s3:::${aws_s3_bucket.cost_and_usage_report.id}/*",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : "arn:${var.partition}:cur:${var.cur_report_s3_bucket_region}:${var.account_id}:definition/*",
            "aws:SourceAccount" : "${var.account_id}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "aws_put_s3_cur_notification" {
  bucket = aws_s3_bucket.cost_and_usage_report.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.awscur_initializer.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.cur_report_s3_prefix}/eks-cost-usage-report-${var.account_id}/eks-cost-usage-report-${var.account_id}"
  }

  depends_on = [
    aws_s3_bucket.cost_and_usage_report
  ]

}

#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "athena_query_results" {
  bucket = "aws-athena-query-results-eks-${var.account_id}"

  force_destroy = true

  tags = merge(var.tags, {
    Name = "aws-athena-query-results-eks-${var.account_id}"
  })
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "athena_query_results" {
  bucket = aws_s3_bucket.athena_query_results.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "athena_query_results" {
  bucket = aws_s3_bucket.athena_query_results.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "athena_query_results" {
  bucket = aws_s3_bucket.athena_query_results.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role" "awscur_crawler_component_function" {
  name = "awscur-crawler-component-function-eks-${var.account_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "glue.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path = "/"
  managed_policy_arns = [
    "arn:${var.partition}:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]
  force_detach_policies = true
  inline_policy {
    name = "AWSCURCrawlerComponentFunctionEKS${var.account_id}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "glue:UpdateDatabase",
            "glue:UpdatePartition",
            "glue:CreateTable",
            "glue:UpdateTable",
            "glue:ImportCatalogToGlue"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject"
          ]
          Resource = "arn:${var.partition}:s3:::${aws_s3_bucket.cost_and_usage_report.id}/${local.cur_report_s3_prefix}/${local.cur_report_name}/${local.cur_report_name}*"
        }
      ]
    })
  }

  inline_policy {
    name = "AWSCURKMSDecryptionEKS${var.account_id}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "kms:Decrypt"
          ]
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(var.tags, {
    Name = "awscur-crawler-component-function-eks-${var.account_id}"
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role" "awscur_crawler_lambda_executor" {
  name = "awscur-crawler-lambda-executor-eks-${var.account_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path                  = "/"
  force_detach_policies = true
  inline_policy {
    name = "AWSCURCrawlerLambdaExecutorEKS${var.account_id}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "glue:StartCrawler"
          ]
          Resource = "*"
        }
      ]
    })
  }

  tags = merge(var.tags, {
    Name = "awscur-crawler-lambda-executor-eks-${var.account_id}"
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role" "awss3_cur_lambda_executor" {
  name = "aawss3-cur-lambda-executor-eks-${var.account_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path                  = "/"
  force_detach_policies = true
  inline_policy {
    name = "AWSS3CURLambdaExecutorEKS${var.account_id}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:${var.partition}:logs:*:*:*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:PutBucketNotification"
          ]
          Resource = "arn:${var.partition}:s3:::${aws_s3_bucket.cost_and_usage_report.id}"
        }
      ]
    })
  }

  tags = merge(var.tags, {
    Name = "aawss3-cur-lambda-executor-eks-${var.account_id}"
  })
}
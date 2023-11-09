resource "aws_glue_catalog_database" "awscur_database" {
  name = "awscur_database-eks-${var.account_id}"

  catalog_id = var.account_id

  tags = merge(var.tags, {
    Name = "awscur_database-eks-${var.account_id}"
  })
}

resource "aws_glue_crawler" "awscur_crawler" {
  name          = "AWSCURCrawler-${local.cur_report_name}"
  description   = "A recurring crawler that keeps your CUR table in Athena up-to-date."
  role          = aws_iam_role.awscur_crawler_component_function.arn
  database_name = aws_glue_catalog_database.awscur_database.name

  s3_target {
    path       = "s3://${aws_s3_bucket.cost_and_usage_report.id}/${local.cur_report_s3_prefix}/${local.cur_report_name}/${local.cur_report_name}"
    exclusions = ["**.json", "**.yml", "**.sql", "**.csv", "**.gz", "**.zip"]
  }
  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DELETE_FROM_DATABASE"
  }

  tags = merge(var.tags, {
    Name = "AWSCURCrawler-${local.cur_report_name}"
  })
}

resource "aws_glue_catalog_table" "catalog_table" {
  catalog_id    = var.account_id
  database_name = aws_glue_catalog_database.awscur_database.name
  name          = "cost_and_usage_data_status_eks_${var.account_id}"
  storage_descriptor {
    columns {
      name = "status"
      type = "string"
    }

    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    location      = "s3://${aws_s3_bucket.cost_and_usage_report.id}/${local.cur_report_s3_prefix}/${local.cur_report_name}/cost_and_usage_data_status/"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

  }

  table_type = "EXTERNAL_TABLE"
}
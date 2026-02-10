provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for incoming data
resource "aws_s3_bucket" "data_bucket" {
  bucket = "event-pipeline-data-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# DynamoDB Table
resource "aws_dynamodb_table" "processed_data" {
  name           = "ProcessedData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Lambda Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda Policy
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:*",
          "s3:*",
          "sns:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Process Data Lambda
resource "aws_lambda_function" "process_data" {
  filename      = "process_data.zip"
  function_name = "ProcessDataFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "process_data.lambda_handler"
  runtime       = "python3.9"
}

# S3 Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_data.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_data.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# SNS Topic for Reports
resource "aws_sns_topic" "daily_report" {
  name = "daily-report"
}

# Report Lambda
resource "aws_lambda_function" "generate_report" {
  filename      = "generate_report.zip"
  function_name = "GenerateReportFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "generate_report.lambda_handler"
  runtime       = "python3.9"
  
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.daily_report.arn
    }
  }
}

# EventBridge Rule for Daily Report
resource "aws_cloudwatch_event_rule" "daily_report" {
  name                = "daily-report-schedule"
  schedule_expression = "cron(0 9 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_report.name
  target_id = "GenerateReportLambda"
  arn       = aws_lambda_function.generate_report.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_report.arn
}

output "bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "sns_topic_arn" {
  value = aws_sns_topic.daily_report.arn
}

provider "aws" {
  region  = var.aws_region
}

data "archive_file" "lambda_archive_file" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = "greet_lambda.zip"
}

resource "aws_iam_role" "common_lambda_role" {
  name               = "common-lambda-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/greet_lambda"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name   = "lambda-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.common_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

resource "aws_lambda_function" "geeting_lambda" {
  function_name = "greet_lambda"
  filename = data.archive_file.lambda_archive_file.output_path
  source_code_hash = data.archive_file.lambda_archive_file.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.common_lambda_role.arn

  environment{
      variables = {
          greeting = "Test output"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}
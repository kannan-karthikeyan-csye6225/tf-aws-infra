# modules/lambda/main.tf
resource "aws_lambda_function" "email_verification" {
  filename         = var.lambda_zip_path
  function_name    = "email-verification-lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs16.x"
  timeout         = 30

  environment {
    variables = {
      SENDGRID_API_KEY = var.sendgrid_api_key
    }
  }
}

# Create Lambda role
resource "aws_iam_role" "lambda_role" {
  name = "email_verification_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Allow Lambda to be invoked by SNS
resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_verification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

# Subscribe Lambda to SNS topic
resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_verification.arn
}
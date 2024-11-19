# modules/sns/main.tf
resource "aws_sns_topic" "user_verification" {
  name = "user-verification-topic"
}

# Create an SNS topic policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.user_verification.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.user_verification.arn
      }
    ]
  })
}
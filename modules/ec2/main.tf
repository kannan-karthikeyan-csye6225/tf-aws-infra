resource "aws_instance" "web_app" {
  ami                         = var.custom_ami
  instance_type               = "t2.small"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.app_security_group_id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "DB_NAME=csye6225" >> /opt/apps/webapp/.env
              echo "DB_USER=csye6225" >> /opt/apps/webapp/.env
              echo "DB_PASSWORD=${var.db_password}" >> /opt/apps/webapp/.env
              echo "DB_HOST=${var.db_endpoint}" >> /opt/apps/webapp/.env
              echo "DB_PORT=5432" >> /opt/apps/webapp/.env
              echo "AWS_REGION=${var.aws_region}" >> /opt/apps/webapp/.env
              echo "S3_BUCKET_NAME=${var.bucket_name}" >> /opt/apps/webapp/.env

              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
                -s

              sudo systemctl restart myapp
              sudo systemctl restart amazon-cloudwatch-agent
              
              EOF
  )

  root_block_device {
    volume_size           = 25
    volume_type          = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "web-app-instance"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "cloudwatch-s3-ec2_role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "cloudwatch-s3-ec2_profile"
  role = aws_iam_role.ec2_role.name
}
 
resource "aws_iam_role_policy" "ec2_policy" {
  name = "cloudwatch-s3-ec2_policy"
  role = aws_iam_role.ec2_role.id
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}  
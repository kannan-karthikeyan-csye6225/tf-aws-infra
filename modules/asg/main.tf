# modules/asg/main.tf

resource "aws_launch_template" "app_launch_template" {
  name                   = "csye6225-app-launch-template"
  instance_type         = "t2.small"
  image_id               = var.custom_ami
  key_name               = var.key_name
  vpc_security_group_ids = [var.app_security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  
  user_data = var.user_data

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webapp-instance"
    }
  }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  name                = "csye6225-app-asg"
  desired_capacity    = 3
  max_size            = 5
  min_size            = 3
  target_group_arns   = [var.lb_target_group_arn]
  vpc_zone_identifier = var.public_subnet_ids  # Changed to public subnets
  health_check_type          = "ELB"
  health_check_grace_period  = 300

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "webapp-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "csye6225-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 15.0
  alarm_description   = "Alarm for scaling up when CPU utilization is above 5%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

# CloudWatch Alarm for Scale Down (Low CPU Utilization)
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "csye6225-low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 10.0
  alarm_description   = "Alarm for scaling down when CPU utilization is below 3%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "csye6225-scale-up-policy"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_autoscaling_group.name
  cooldown               = 60
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "csye6225-scale-down-policy"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.app_autoscaling_group.name
  cooldown               = 60
  scaling_adjustment     = -1
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
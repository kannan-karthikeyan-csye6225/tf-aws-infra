resource "aws_instance" "web_app" {
  ami                         = var.custom_ami
  instance_type               = "t2.small"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.app_security_group_id]
  associate_public_ip_address = true

  iam_instance_profile = "CloudWatchAgent"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "DB_NAME=csye6225" >> /opt/apps/webapp/.env
              echo "DB_USER=csye6225" >> /opt/apps/webapp/.env
              echo "DB_PASSWORD=${var.db_password}" >> /opt/apps/webapp/.env
              echo "DB_HOST=${var.db_endpoint}" >> /opt/apps/webapp/.env
              echo "DB_PORT=5432" >> /opt/apps/webapp/.env

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
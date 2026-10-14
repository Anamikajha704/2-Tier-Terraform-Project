# Create IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "://amazonaws.com" }
      }
    ]
  })
}

# Attach AWS Managed Systems Manager Policy (Allows secure terminal access without SSH keys)
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#  Create the Instance Profile Wrapper
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_launch_template" "lt_name" {
  name          = "${var.project_name}-tpl"
  image_id      = var.ami
  instance_type = var.cpu
  user_data     = filebase64("${path.module}/config.sh")


  vpc_security_group_ids = [var.web_sg_id]
  tags = {
    Name = "${var.project_name}-tpl"
  }
}


resource "aws_autoscaling_group" "asg_name" {

  name                      = "${var.project_name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_cap
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type 
  vpc_zone_identifier = [var.private_subnet_3a_id,var.private_subnet_4b_id]
  target_group_arns   = [var.target_group_arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.lt_name.id
    version = aws_launch_template.lt_name.latest_version 
  }
}



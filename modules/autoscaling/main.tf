resource "aws_launch_template" "lt_name" {
  name          = "${var.project_name}-tpl"
  image_id      = var.ami
  instance_type = var.cpu
  key_name      = var.key_name
  user_data     = filebase64("../modules/autoscaling/config.sh")


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
  health_check_type         = var.asg_health_check_type #ELB or default EC2
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
resource "aws_launch_configuration" "app_lc" {
  name_prefix = "goji-lc-"
  image_id = data.aws_ami.ecs.id 
  instance_type = var.instance_type
  lifecycle {
    create_before_destroy = true
  }
  # Storage
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
  security_groups =  ["${aws_security_group.goji-ec2-sg.id}"]
  associate_public_ip_address = false

  user_data = filebase64("${path.module}/ecs.sh")
}

resource "aws_autoscaling_group" "app_asg" {
  name = "goji-asg"
  launch_configuration = aws_launch_configuration.app_lc.name
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2
  lifecycle {
    create_before_destroy = true
  }
  health_check_type    = "ELB"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}


resource "aws_lb" "goji-ecs-alb" {
 name_prefix        = "goji-"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.goji-alb-sg.id]
 subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

 tags = {
   Name = "goji-ecs-alb"
 }
}

resource "aws_lb_listener" "ecs_alb_listener" {
 load_balancer_arn = aws_lb.goji-ecs-alb.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.goji.id

 health_check {
   path = "/"
 }
}

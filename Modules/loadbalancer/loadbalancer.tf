# Create the public load balancer
resource "aws_lb" "loadbalancer" {
  name               = var.name_lb
  internal           = var.internal_or_internetfacing
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_groups]
  subnets            = [var.subnet_1, var.subnet_2]

  tags = {
    Name = var.name_tag_lb
  }
}

# Create a target group for the reverse proxy (public instances)
resource "aws_lb_target_group" "target_group" {
  name     = var.name_tg
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_in_tg

  tags = {
    Name = var.name_tag_tg
  }
}

# Public Load Balancer HTTP Listener (no HTTPS)
resource "aws_lb_listener" "public_lb_http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "lb_tg_p1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.target_instance_1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "lb_tg_p2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.target_instance_2_id
  port             = 80
}
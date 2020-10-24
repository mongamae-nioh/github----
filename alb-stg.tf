# SecurityGroup
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "alb" {
  name        = "alb"
  description = "alb"
  vpc_id      = aws_vpc.vpc.id

  # in out setting
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "alb"
  }
}

# ALB
# https://www.terraform.io/docs/providers/aws/d/lb.html
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "stg"

  security_groups = [aws_security_group.alb.id]
  subnets = aws_subnet.public-web.*.id
  tags    = var.tags
}

## Listener
## https://www.terraform.io/docs/providers/aws/r/lb_listener.html
resource "aws_lb_listener" "main" {
  # accept http access
  port     = "80"
  protocol = "HTTP"

  # alb arn
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.for-web.arn
  }
}

## target group
resource "aws_lb_target_group" "for-web" {
  name     = "for-web-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path = "/index.html"
  }
}

## assign instance to target group
resource "aws_lb_target_group_attachment" "for_webserver_a" {
  target_group_arn = aws_lb_target_group.for-web.arn
  count            = 1
  target_id        = aws_instance.webserver[count.index].id
  port             = 80
}
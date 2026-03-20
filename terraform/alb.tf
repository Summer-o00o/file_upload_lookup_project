// get the default VPC and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



#create an application load balancer for the backend server
resource "aws_lb" "backend_alb" {

  name               = "file-upload-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = data.aws_subnets.default.ids

  tags = {
    Name = "file-upload-alb"
  }
}

# create a target group for the backend server (forward the traffic to port 8080)
resource "aws_lb_target_group" "backend_tg" {

  name     = "file-upload-backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/api/upload/health"
    port = "8080"
  }

  tags = {
    Name = "backend-target-group"
  }
}

# attach the target group to the backend server
resource "aws_lb_target_group_attachment" "backend_attachment" {

  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.backend_server.id
  port             = 8080
}

// create a listener for ALB to forward the traffic to the backend server
resource "aws_lb_listener" "http_listener" {

  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

// create a security group for the ALB to allow traffic from the internet
resource "aws_security_group" "alb_sg" {

  name = "alb-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "alb-sg"
  }
}
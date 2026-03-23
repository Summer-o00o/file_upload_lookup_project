// get the default subnets for the VPC link
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

// create a security group for the VPC link
resource "aws_security_group" "vpc_link_sg" {
  name = "vpc-link-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-link-sg"
  }
}

// vpc link for the backend ALB to forward traffic to the backend server
resource "aws_apigatewayv2_vpc_link" "backend_vpc_link" {
  name               = "backend-vpc-link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids         = data.aws_subnets.default.ids
}

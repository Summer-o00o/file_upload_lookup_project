resource "aws_key_pair" "backend_key" {
  key_name   = "file-upload-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "backend_server" {

  ami           = "ami-03caad32a158f72db" #amazon linux 2023. free tier instance
  instance_type = "t3.micro" #free tier instance
  key_name = aws_key_pair.backend_key.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id] #attach the security group to the instance
  tags = {
    Name = "file-upload-backend"
  }
}

resource "aws_security_group" "backend_sg" {

  name = "backend-security-group"
  #allow http traffic to the instance
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  #allow ssh/EC2 instance connect to the instance
  ingress {
  description = "Allow SSH"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}
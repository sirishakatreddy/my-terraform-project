# Creating VPC
resource "aws_vpc" "My_VPC" {
  cidr_block = var.vpc_cidr
}

# Creating Subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnet_cidr_1
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnet_cidr_2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.My_VPC.id
}

# Creating Route Tables
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.My_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Creating Subnet Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.RT.id
}

# Creating Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.My_VPC.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

# Creating Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  vpc_id      = aws_vpc.My_VPC.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["124.123.158.46/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "My_bucket" {
  bucket = var.state_bucket_name
}

# Creating Ec2-instances
resource "aws_instance" "Web" {
  count                  = 2
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.subnet1.id
  user_data = file("userdata.sh")

  tags = {
    Name = "terraform-web-${count.index + 1}"
  }
}

# Creating Application Load Balancer
resource "aws_lb" "My_ALB" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ec2_sg.id]
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {
    Name = "web"
  }
}

# Creating Target Group
resource "aws_lb_target_group" "TG" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.My_VPC.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach" {
  count            = length(aws_instance.Web)
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.Web[count.index].id
  port             = 80
}


# Creating Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.My_ALB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.TG.arn
    type             = "forward"
  }
}

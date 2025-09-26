
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/gachs_ssh_key.pub")
}

resource "aws_security_group" "ecommerce_sg" {
  name_prefix = "ecommerce-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ecommerce_app" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 22.04 in us-east-1
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.ecommerce_sg.name]

  user_data = templatefile("${path.module}/user_data.sh", {
    dockerhub_username = var.dockerhub_username
    dockerhub_token    = var.dockerhub_token
  })

  tags = {
    Name = "EcommerceApp"
  }
}


# # Lookup the latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

# # Read a user data script to install Docker on the instance
# data "template_file" "user_data" {
#   template = file("${path.module}/user_data.sh")
# }

# # Create or import an SSH key pair
# resource "aws_key_pair" "deployer" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }

# # Security group allowing SSH and application traffic
# resource "aws_security_group" "web_sg" {
#   name        = "${var.key_name}-sg"
#   description = "Allow SSH and HTTP access"

#   ingress = [
#     {
#       description = "SSH"
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       description = "HTTP"
#       from_port   = var.server_port
#       to_port     = var.server_port
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]

#   egress = [
#     {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
# }

# # EC2 instance for the application
# resource "aws_instance" "app_server" {
#   ami                    = data.aws_ami.amazon_linux.id
#   instance_type          = var.instance_type
#   key_name               = aws_key_pair.deployer.key_name
#   vpc_security_group_ids = [aws_security_group.web_sg.id]
#   user_data              = data.template_file.user_data.rendered

#   tags = {
#     Name = "EcommerceAppServer"
#   }
# }
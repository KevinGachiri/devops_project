
variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
}

variable "dockerhub_username" {
  description = "Docker Hub username"
}

variable "dockerhub_token" {
  description = "Docker Hub token"
  sensitive   = true
}


# variable "aws_region" {
#   description = "AWS region to deploy resources"
#   type        = string
#   default     = "us-east-1"
# }

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t2.micro"
# }

# variable "key_name" {
#   description = "Name of the existing SSH key pair"
#   type        = string
# }

# variable "public_key_path" {
#   description = "Path to the public SSH key"
#   type        = string
# }

# variable "server_port" {
#   description = "Port on which the application listens"
#   type        = number
#   default     = 80
# }
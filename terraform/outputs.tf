output "instance_ip" {
  value = aws_instance.ecommerce_app.public_ip
}

output "app_url" {
  value = "http://${aws_instance.ecommerce_app.public_ip}"
}

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.app_server.public_ip
# }
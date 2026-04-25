output "private_ip" {
  description = "My Private Instance's Private IP address"
  value       = aws_instance.private_instance.private_ip
}

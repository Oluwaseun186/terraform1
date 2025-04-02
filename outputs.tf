output "instance_ip_addr" {
  value = aws_instance.simple2-ec2[0].private_ip
}

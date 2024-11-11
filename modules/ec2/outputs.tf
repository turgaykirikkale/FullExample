//outputs will come
output "instance_private_ip" {
  value = aws_instance.instance.private_ip
}

output "instance_id" {
  value = aws_instance.instance.id
}

output "user_data_script" {
  value = aws_instance.instance.user_data
}

data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.asg.name]
  }
}

output "instance_ids" {
  value = data.aws_instances.asg_instances.id
}

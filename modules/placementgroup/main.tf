resource "aws_placement_group" "placement_group" {
  name     = var.placement_group_name
  strategy = var.placement_group_strategy
}

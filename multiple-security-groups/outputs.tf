output "vpc_arn" {
  value = data.aws_vpc.selected.arn
}

output "vpc_tags" {
  value = data.aws_vpc.selected.tags
}

output "demo_vpc_tags" {
  value = aws_vpc.demo_vpc.tags_all
}
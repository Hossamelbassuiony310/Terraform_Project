output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "public1_subnets_id" {
  value = aws_subnet.public1.id
}

output "public2_subnets_id" {
  value = aws_subnet.public2.id
}

output "private1_subnets_id" {
  value = aws_subnet.private1.id
}

output "private2_subnets_id" {
  value = aws_subnet.private2.id
}
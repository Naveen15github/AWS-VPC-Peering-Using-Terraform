output "vpc_a_id" {
  value = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  value = aws_vpc.vpc_b.id
}

output "peering_connection_id" {
  value = aws_vpc_peering_connection.peer.id
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc_a.id
  peer_vpc_id = aws_vpc.vpc_b.id
  auto_accept = true

  tags = {
    Name = "VPC-A-to-VPC-B"
  }
}

resource "aws_route" "route_a_to_b" {
  route_table_id            = aws_route_table.rt_a.id
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_b_to_a" {
  route_table_id            = aws_route_table.rt_b.id
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

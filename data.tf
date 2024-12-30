data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnets" "public-1" {
  /*filter {
    name = "vpc-id"
    #values = [var.vpc_id]
    values = [module.vpc-1.vpc_id]
  }*/

  filter {
    name = "tag:Name"
    values = ["yl-vpc-1-public*"]
  }
  depends_on = [module.vpc-1]
}

data "aws_subnets" "public-2" {
  /*filter {
    name = "vpc-id"
    # values = [var.vpc_id]
    values = [module.vpc-2.vpc_id]
  }*/

  filter {
    name = "tag:Name"
    values = ["yl-vpc-2-public*"]
  }
    depends_on = [module.vpc-2]
}

resource "aws_vpc_peering_connection" "yl_vpc_peer" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.vpc-2.vpc_id
  vpc_id        = module.vpc-1.vpc_id
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "vpc-1_to_vpc-2" {
  # ID of VPC 1 main route table.
  #route_table_id = "${aws_vpc.primary.main_route_table_id}"
  #route_table_id = module.vpc-1.vpc_main_route_table_id
  route_table_id = module.vpc-1.public_route_table_ids[0]

  # CIDR block / IP range for VPC 2.
  #destination_cidr_block = "${aws_vpc.secondary.cidr_block}"
  destination_cidr_block = module.vpc-2.vpc_cidr_block

  # ID of VPC peering connection.
  #vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
  vpc_peering_connection_id = aws_vpc_peering_connection.yl_vpc_peer.id
}

resource "aws_route" "vpc-2_to_vpc-1" {
  # ID of VPC 1 main route table.
  #route_table_id = "${aws_vpc.primary.main_route_table_id}"
  #route_table_id = module.vpc-2.vpc_main_route_table_id
  route_table_id = module.vpc-2.public_route_table_ids[0]

  # CIDR block / IP range for VPC 2.
  #destination_cidr_block = "${aws_vpc.secondary.cidr_block}"
  destination_cidr_block = module.vpc-1.vpc_cidr_block

  # ID of VPC peering connection.
  #vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
  vpc_peering_connection_id = aws_vpc_peering_connection.yl_vpc_peer.id
}




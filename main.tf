locals {
  name_prefix = "yl"
}

resource "aws_instance" "web_app_1" {
  #count = 2

  ami = "ami-04c913012f8977029"
  #instance_type = var.instance_type
  instance_type = "t2.micro"
  #for_each = toset(data.aws_subnets.public-1.ids)
  #subnet_id = each.value
  subnet_id = data.aws_subnets.public-1.ids[0] # this is working
  #subnet_id = data.aws_subnets.public-"${var.index_count}".ids[0]
  #subnet_id = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.allow_tls_vpc_1.id]
  user_data = templatefile("init-script.sh", {file_content = "webapp"})

  depends_on = [module.vpc-1, aws_security_group.allow_tls_vpc_1]

  #key_name = "yl-key-pair"
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-ec2-1"
  }
}

resource "aws_instance" "web_app_2" {
  #count = 2

  ami = "ami-04c913012f8977029"
  #instance_type = var.instance_type
  instance_type = "t2.micro"
  #for_each = toset(data.aws_subnets.public-2.ids)
  #subnet_id = each.value
  subnet_id = data.aws_subnets.public-2.ids[0]
  #subnet_id = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.allow_tls_vpc_2.id]
  user_data = templatefile("init-script.sh", {file_content = "webapp"})

  #key_name = "yl-key-pair"
  associate_public_ip_address = true

  depends_on = [aws_security_group.allow_tls_vpc_2]

  tags = {
    Name = "${local.name_prefix}-ec2-2"
  }
}

resource "aws_security_group" "allow_tls_vpc_1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  #vpc_id      = module.vpc-1.default_vpc_id
  vpc_id      = module.vpc-1.vpc_id

  tags = {
    Name = "allow_tls_vpc_1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_vpc_1" {
  security_group_id = aws_security_group.allow_tls_vpc_1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_vpc_1" {
  security_group_id = aws_security_group.allow_tls_vpc_1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_vpc_1" {
  security_group_id = aws_security_group.allow_tls_vpc_1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "allow_tls_vpc_2" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  #vpc_id      = module.vpc-2.default_vpc_id
  vpc_id      = module.vpc-2.vpc_id

  tags = {
    Name = "allow_tls_vpc_2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_vpc_2" {
  security_group_id = aws_security_group.allow_tls_vpc_2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_vpc_2" {
  security_group_id = aws_security_group.allow_tls_vpc_2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_vpc_2" {
  security_group_id = aws_security_group.allow_tls_vpc_2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



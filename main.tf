#VPC
resource "aws_vpc" "ssm_vpc_example" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
    Name = "ssm_vpc_example"
  }
}

resource "aws_eip" "eip" {
    domain = "vpc"
}

#Subnets
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    cidr_block = var.public_subnet_cidr_range
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
    tags = {
        Name = "public_ssm_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    cidr_block = var.private_subnet_cidr_range
    availability_zone = "us-west-2a"
    tags = {
        Name = "private_ssm_subnet"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}

#Route Tables
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id  
    }
    tags = {
        Name = "public_ssm_rt"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ngw.id
    }
    tags = {
        Name = "private_ssm_rt"
    }
}



#Gateways
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    tags = {
        Name = "ssm_vpc_igw"
    }
  
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public_subnet.id
    tags = {
        Name = "ssm_vpc_ngw"
    }
}

#Security Groups
resource "aws_security_group" "ec2_instance_sg" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    description = "Allow HTTPS traffic from SSM endpoints"
    name = "ec2_instance_sg"
    tags = {
        Name = "ec2_instance_sg"
    }
}

resource "aws_security_group" "vpce_sg" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    description = "SG for VPC endpoints"
    name = "vpce_sg"
    tags = {
        Name = "vpce_sg"
    }
}

#SG Rules
resource "aws_security_group_rule" "allow_https_from_vpce" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.ec2_instance_sg.id
    source_security_group_id = aws_security_group.vpce_sg.id
}

resource "aws_security_group_rule" "allow_https_from_instance" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.vpce_sg.id
    source_security_group_id = aws_security_group.ec2_instance_sg.id
}

#EC2 Instance
resource "aws_instance" "ssm_example_instance" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.private_subnet.id
    vpc_security_group_ids = [aws_security_group.ec2_instance_sg.id]

    tags = {
        Name = "ssm_example_instance"
    }
}

resource "aws_ebs_volume" "instance_ebs_volume" {
    availability_zone = "us-west-2a"
    size = 8
    tags = {
        Name = "ssm_example_instance_volume"
    }
}

resource "aws_volume_attachment" "ebs_attachment" {
    device_name = "/dev/sdb"
    instance_id = aws_instance.ssm_example_instance.id
    volume_id = aws_ebs_volume.instance_ebs_volume.id
}

#VPC Endpoints
resource "aws_vpc_endpoint" "ssm_vpce" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    service_name = "com.amazonaws.${var.region}.ssm"
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.vpce_sg.id]
    subnet_ids = [aws_subnet.private_subnet.id]
    tags = {
        Name = "ssm_vpce"
    }
}

resource "aws_vpc_endpoint" "ssm_messages_vpce" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    service_name = "com.amazonaws.${var.region}.ssmmessages"
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.vpce_sg.id]
    subnet_ids = [aws_subnet.private_subnet.id]
    tags = {
        Name = "ssm_messages_vpce"
    }
}

resource "aws_vpc_endpoint" "ec2_messages_vpce" {
    vpc_id = aws_vpc.ssm_vpc_example.id
    service_name = "com.amazonaws.${var.region}.ec2messages"
    vpc_endpoint_type = "Interface"
    security_group_ids = [aws_security_group.vpce_sg.id]
    subnet_ids = [aws_subnet.private_subnet.id]
    tags = {
        Name = "ec2_messages_vpce"
    }
  
}
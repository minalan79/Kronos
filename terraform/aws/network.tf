resource "aws_vpc" "vpc_ue_vervea" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "vpc-ue-vervea"
    }
}

resource "aws_subnet" "subnet_ue_vervea_a" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    availability_zone = data.aws_availability_zones.az_ue.names[0]
    tags = {
        Name = "subnet-ue-vervea-a"
    }
}

resource "aws_subnet" "subnet_ue_vervea_b" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    availability_zone = data.aws_availability_zones.az_ue.names[1]
    tags = {
        Name = "subnet-ue-vervea-b"
    }
}

resource "aws_subnet" "subnet_ue_vervea_c" {
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    availability_zone = data.aws_availability_zones.az_ue.names[2]
    tags = {
        Name = "subnet-ue-vervea-c"
    }
}
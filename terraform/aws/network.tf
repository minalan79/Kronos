resource "aws_vpc" "vpc_ue_vervea" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "vpc-ue-vervea"
    }
}

resource "aws_subnet" "subnet_ue_vervea_a" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    tags = {
        Name = "subnet-ue-vervea-a"
    }
}

resource "aws_subnet" "subnet_ue_vervea_b" {
    cidr_block = "10.1.0.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    tags = {
        Name = "subnet-ue-vervea-b"
    }
}

resource "aws_subnet" "subnet_ue_vervea_c" {
    cidr_block = "10.2.0.0/24"
    vpc_id = aws_vpc.vpc_ue_vervea.id
    tags = {
        Name = "subnet-ue-vervea-c"
    }
}
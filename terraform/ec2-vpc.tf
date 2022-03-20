#### Create The VPC, Subnet & Network Interfaces ###
resource "aws_vpc" "dev" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"
   tags = {
     Name = "dev-vpc"
   }
}
resource "aws_subnet" "sub" {
   vpc_id = aws_vpc.dev.id
   cidr_block = "10.0.1.0/24"
   tags = {
     Name = "dev-subnet"
   }
}
resource "aws_network_interface" "mw_network" {
   subnet_id = aws_subnet.sub.id
   private_ips = ["10.0.1.45"]
   tags = {
     Name = "network_interface"
   }
}

#### Create the AWS EC2 instance with 10 disk space ####
resource "aws_instance" "mw_php1" {
   ami = "ami-0fb653ca2d3203ac1"
   instance_type = "t2.micro"   
   root_block_device {
     volume_size = 15
     volume_type = "standard"
   }
   tags = {
     Name = "kreybooks"
     Environment = "Dev"
   }
   network_interface {
     network_interface_id = aws_network_interface.mw_network.id
     device_index = 0
   }
}
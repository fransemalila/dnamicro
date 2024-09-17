provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "dnamicro_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create two subnets in different Availability Zones with non-conflicting CIDRs
resource "aws_subnet" "dnamicro_subnet_1" {
  vpc_id            = aws_vpc.dnamicro_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "dnamicro_subnet_2" {
  vpc_id            = aws_vpc.dnamicro_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"  
  map_public_ip_on_launch = true
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "dnamicro_igw" {
  vpc_id = aws_vpc.dnamicro_vpc.id
}

# Create a Route Table for the subnets
resource "aws_route_table" "dnamicro_route_table" {
  vpc_id = aws_vpc.dnamicro_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dnamicro_igw.id
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "dnamicro_subnet_1_assoc" {
  subnet_id      = aws_subnet.dnamicro_subnet_1.id
  route_table_id = aws_route_table.dnamicro_route_table.id
}

resource "aws_route_table_association" "dnamicro_subnet_2_assoc" {
  subnet_id      = aws_subnet.dnamicro_subnet_2.id
  route_table_id = aws_route_table.dnamicro_route_table.id
}

# Security Group for Worker Nodes
resource "aws_security_group" "worker_node_sg" {
  vpc_id = aws_vpc.dnamicro_vpc.id

  # Allow inbound traffic on port 443 and 10250
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eks-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": "sts:AssumeRole",
      "Principal": { "Service": "eks.amazonaws.com" },
      "Effect": "Allow",
    }]
  })
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "node_role" {
  name = "node-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": "sts:AssumeRole",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Effect": "Allow",
    }]
  })
}

# Attach policies to the Worker Node Role
resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

# Create EKS Cluster
resource "aws_eks_cluster" "dnamicro" {
  name     = "dnamicro"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.30"  

  vpc_config {
    subnet_ids = [
      aws_subnet.dnamicro_subnet_1.id,
      aws_subnet.dnamicro_subnet_2.id
    ]
    security_group_ids = [aws_security_group.worker_node_sg.id]
  }
}

# Create EKS Node Group
resource "aws_eks_node_group" "dnamicro_node_group" {
  cluster_name    = aws_eks_cluster.dnamicro.name
  node_group_name = "dnamicro-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [
    aws_subnet.dnamicro_subnet_1.id,
    aws_subnet.dnamicro_subnet_2.id
  ]
  version = "1.30"  

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }
}

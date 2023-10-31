resource "aws_security_group" "sg-allow-ssh" {
  name        = "Allow-SSH"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    description = "SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "sg-Allow-SSH"
  }
}

# Be sure to run this comamnd on terminal, in order to create the SSH keys locally
#
# ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws-infra -N ""

resource "aws_key_pair" "ec2-key-pair" {
  key_name   = "ec2-key"
  public_key = file("~/.ssh/aws-infra.pub")
}

data "aws_key_pair" "internal-access-key-pair" {
  key_name = "internal-access"
}




resource "aws_instance" "ec2-sub-a-public" {
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sub-a-public.id
  vpc_security_group_ids      = [aws_security_group.sg-allow-ssh.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "EC2 Sub-A Public"
  }
}

output "ec2-sub-a-public-ip" {
  value = "EC2 Sub-A Public IP: ${aws_instance.ec2-sub-a-public.public_ip}"
}

output "ec2-sub-a-private-ip" {
  value = "EC2 Sub-A Private IP: ${aws_instance.ec2-sub-a-public.private_ip}"
}


resource "aws_instance" "ec2-sub-b-public" {
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sub-b-public.id
  vpc_security_group_ids      = [aws_security_group.sg-allow-ssh.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2-key-pair.key_name

  tags = {
    Name = "EC2 Sub-B Public"
  }
}

output "ec2-sub-b-public-ip" {
  value = "EC2 Sub-B Public IP: ${aws_instance.ec2-sub-b-public.public_ip}"
}

output "ec2-sub-b-private-ip" {
  value = "EC2 Sub-B Private IP: ${aws_instance.ec2-sub-b-public.private_ip}"
}


resource "aws_instance" "ec2-sub-c-private" {
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sub-c-private.id
  vpc_security_group_ids      = [aws_security_group.sg-allow-ssh.id]
  associate_public_ip_address = false
  key_name                    = data.aws_key_pair.internal-access-key-pair.key_name

  tags = {
    Name = "EC2 Sub-C Private"
  }
}

output "ec2-sub-c-private-ip" {
  value = "EC2 Sub-C Private IP: ${aws_instance.ec2-sub-c-private.private_ip}"
}


resource "aws_instance" "ec2-sub-d-private" {
  ami                         = var.ec2_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sub-d-private.id
  vpc_security_group_ids      = [aws_security_group.sg-allow-ssh.id]
  associate_public_ip_address = false
  key_name                    = data.aws_key_pair.internal-access-key-pair.key_name

  tags = {
    Name = "EC2 Sub-D Private"
  }
}

output "ec2-sub-d-private-ip" {
  value = "EC2 Sub-D Private IP: ${aws_instance.ec2-sub-d-private.private_ip}"
}



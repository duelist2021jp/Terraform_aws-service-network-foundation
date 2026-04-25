# Network Interface for the EC2 Instance
resource "aws_network_interface" "private_instance_eni" {
  subnet_id       = var.private_subnet_id
  security_groups = [var.private_security_group_id]

  tags = {
    Name = "CS-PrivateEC2-ENI"
  }
}

# EC2 Instance
resource "aws_instance" "private_instance" {
  instance_type        = "t2.micro"
  ami                  = "ami-0b2cd2a95639e0e5b"
  iam_instance_profile = "EC2Instance_Role"

  credit_specification {
    cpu_credits = "standard"
  }

  primary_network_interface {
    network_interface_id = aws_network_interface.private_instance_eni.id
  }

  user_data_base64 = base64encode(<<-EOF
#!/bin/bash
apt update -y
apt dist-upgrade -y
apt install -y postgresql-client-16
EOF
  )

  tags = {
    Name = "CS-PrivateEC2-Instance"
  }
}



resource "aws_instance" "bastion" {
  #  count           = length(aws_subnet.public_subnets[*].id)
  count           = 0
  ami             = "ami-0b1deee75235aa4bb"
  instance_type   = "t2.micro"
  key_name        = var.bastion_ssh_key_name
  subnet_id       = element(aws_subnet.public_subnets[*].id, count.index)
  security_groups = [aws_security_group.bastion.id]
  tags = {
    Name = "bastion-${count.index + 1}"
  }

}

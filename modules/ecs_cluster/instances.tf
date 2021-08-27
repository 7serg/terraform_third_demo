resource "aws_instance" "web_server" {
  #count           = length(aws_subnet.private_subnets[*].id)
  count           = 0
  ami             = "ami-0b1deee75235aa4bb"
  instance_type   = "t2.micro"
  key_name        = var.bastion_ssh_key_name
  subnet_id       = element(aws_subnet.private_subnets[*].id, count.index)
  security_groups = [aws_security_group.webserver.id]
  tags = {
    Name = "webserver-${count.index + 1}"
  }
  #  user_data = file("userdata.sh")

}

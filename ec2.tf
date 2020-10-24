# EC2
resource "aws_instance" "webserver" {
  ami           = "<ami-nnnnnn>"
  instance_type = "<instance type>"
  key_name      = aws_key_pair.pubkey.id
  vpc_security_group_ids = [
    aws_security_group.public-web-sg.id
  ]
  count                       = 1
  subnet_id                   = aws_subnet.public-web[count.index].id
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = nn # disk size
  }
  user_data = file("./cloud-init.tpl")
  tags = {
    Name  = format("web%02d", count.index + 1)
  }
}

# EIP
resource "aws_eip" "webserver" {
  count = 1
  instance = aws_instance.webserver[count.index].id
  vpc      = true
  tags = {
    Name  = format("web%02d", count.index + 1)
  }
}

# Output
output "public_ip_of_webserver" {
  value = aws_eip.webserver.*.public_ip
}
## instance
resource "aws_db_instance" "db" {
  identifier             = "db"
  allocated_storage      = nn # disk size
  storage_type           = "gp2"
  engine                 = "<mysql|postgres|aurora>"
  engine_version         = "<version>"
  instance_class         = "<instance type>"
  name                   = "name"
  username               = "name"
  password               = "password" # must longer than 8 characters
  vpc_security_group_ids = [aws_security_group.private-db-sg.id]
  count                  = 1
  db_subnet_group_name   = aws_db_subnet_group.private-db.name
  skip_final_snapshot    = true
  tags = {
    Name  = format("db%02d", count.index + 1)
  }
}

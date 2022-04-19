resource "aws_ebs_volume" "testvol" {
  availability_zone = aws_instance.testvm.availability_zone
  size              = 10

  tags = {
    Name = "myvol"
  }
}

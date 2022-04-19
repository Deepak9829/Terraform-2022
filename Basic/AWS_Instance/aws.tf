provider "aws" {
  profile = "Deepak"
  region = "ap-south-1"
}



resource "aws_instance" "testvm" {

ami           = "ami-0d2986f2e8c0f7d01"
instance_type = "t2.micro"
key_name = "master"
tags = {
Name = "testvm"
}
}

resource "aws_ebs_volume" "testvol" {
  availability_zone = aws_instance.testvm.availability_zone
  size              = 10

  tags = {
    Name = "myvol"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.testvol.id
  instance_id = aws_instance.testvm.id
}
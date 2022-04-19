resource "aws_instance" "testvm" {

ami           = "ami-0d2986f2e8c0f7d01"
instance_type = "t2.micro"
key_name = "testvm"
tags = {
Name = "testvm"
}
}
resource "null_resource" "null_remote1" {

    depends_on = [
    aws_volume_attachment.ebs_att,
  ]
 
   connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/home/deepaksaini/Downloads/testvm.pem")
    host     = aws_instance.testvm.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      
    ]
  }
  
}
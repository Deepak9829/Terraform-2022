resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.testvol.id
  instance_id = aws_instance.testvm.id
}
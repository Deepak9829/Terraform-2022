variable "ip" {
    type = string
    default = "192.168.43.13"
}

output "myip" {
    value = "${var.ip}"
}
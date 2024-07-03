output "public_subnet" {
  value = "aws_subnet.public_subnet.id"
}
output "pricvate_subnet" {
  value = "aws_subnet.private_subnet.id"
}
output "MySg" {
 value = "aws_security_group.MySg.id"
}

output "ec2_public_ip" {
  value = [
    for instance in aws_instance.my_ec2_instance : instance.public_ip
  ]
}

output "ec2_private_ip" {
  value = [
    for instance in aws_instance.my_ec2_instance : instance.private_ip
  ]
}


output "ec2_public_dns" {
  value = [
    for instance in aws_instance.my_ec2_instance : instance.public_dns
  ]
}

output "ec2_id" {
  value = [
    for instance in aws_instance.my_ec2_instance : instance.id
  ]
}

output "ec2_ami_id" {
  value = [
    for instance in aws_instance.my_ec2_instance : instance.ami
  ]
}

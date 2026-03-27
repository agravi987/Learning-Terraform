output "ec2_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.my_ec2_instance.private_ip
}


output "ec2_public_dns" {
  value = aws_instance.my_ec2_instance.public_dns
}

output "ec2_id" {
  value = aws_instance.my_ec2_instance.id
}

output "ec2_ami_id" {
  value = aws_instance.my_ec2_instance.ami
}

output "ec2_instance_type" {
  value = aws_instance.my_ec2_instance.instance_type
}

output "ec2_key_name" {
  value = aws_instance.my_ec2_instance.key_name
}

output "ec2_vpc_security_group_ids" {
  value = aws_instance.my_ec2_instance.vpc_security_group_ids
}

output "ec2_root_block_device" {
  value = aws_instance.my_ec2_instance.root_block_device
}

output "ec2_tags" {
  value = aws_instance.my_ec2_instance.tags
}


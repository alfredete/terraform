output "aws_security_group_http_server_details" {
  value = aws_security_group.http_server_sg
}

output "http_server_public_dnss" {
  value = values(aws_instance.http_servers).*.public_dns
}

output "http_elb_public_dns" {
  value = aws_elb.elb
}
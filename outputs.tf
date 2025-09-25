output "DNS_publica_server1" {
  description = "value of the public DNS server 1"
  value = "http://${aws_instance.serverTF_1.public_dns}:8080" 
}

output "DNS_publica_server2" {
  description = "value of the public DNS"
  value = "http://${aws_instance.serverTF_2.public_dns}:8080" 
}


output "ipv4_servidor1" {
  description = "IPv4 de nuestro servidor1"
  value = aws_instance.serverTF_1.public_ip
}

output "ipv4_servidor2" {
  description = "IPv4 de nuestro servidor2"
  value = aws_instance.serverTF_2.public_ip
}

#output "DNS_publica_LB" {
#  description = "DNS publico del Load Balancer"
#  value = "http://${aws_lb.alb.dns_name}"
  
#}
output "alb_dns_name" {
  description = "Open this URL in a browser to verify load balancing"
  value       = "http://${aws_lb.alb.dns_name}"
}

output "instance_ids" {
  description = "IDs of the three web server instances"
  value       = { for k, v in aws_instance.web : k => v.id }
}

output "instance_public_ips" {
  description = "Public IPs of the three web servers"
  value       = { for k, v in aws_instance.web : k => v.public_ip }
}

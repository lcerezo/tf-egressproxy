output "squid_nlb_endpoint_east" {
  value = module.squid-ec2-east.squid_nlb_endpoint
}

output "squid_nlb_endpoint_west" {
  value = module.squid-ec2-west.squid_nlb_endpoint
}
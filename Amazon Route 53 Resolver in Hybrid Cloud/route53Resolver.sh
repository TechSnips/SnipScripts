#VPN is setup and we can access private IP addresses in our VPC
http://10.0.0.90
# But we cant use the DNS name
http://ip-10-0-0-90.us-east-2.compute.internal
nslookup ip-10-0-0-90.us-east-2.compute.internal

https://us-east-2.console.aws.amazon.com/route53resolver/home?region=us-east-2#/

# create inbound and outbound endpoits
# create rule to point to on prem DNS (techsnips.example.io.)

nslookup ip-10-0-0-90.us-east-2.compute.internal 10.0.0.180

ssh -i "ohio-keys1-prod.pem" ubuntu@ec2-3-14-85-72.us-east-2.compute.amazonaws.com

dig www.techsnips.example.io
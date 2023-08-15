#### ● Basic example of IaC using Terraform.
#### ● Suitable infrastructure to deploy [2095-SPHFS18](https://github.com/gstmoniz/2095-SPHFS18).
#### ● ECS cluster with Fargate on private subnet; Route 53 update; ALB with SSL/TLS.
---
#### To use this code, you need:

1. a fully qualified domain name with Route 53 configured DNS
2. an enabled CloudFront distribution with ALB associated with ACM/SSL as origin
3. the ALB's listener with a domain that matches DNS settings (i.e. subdomain)
4. one s3 bucket with the same prefixes found inside backend.tf 
5. to properly set IAM permissions (detailed policies and roles in the future)
---
```
cd /ambiente/desenvolvimento
terraform apply -var="dns_name=example.com"
terraform destroy
```
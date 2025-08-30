# Highly Available Auto‑Scaling Web Application (AWS)

A production‑style, highly available web application on AWS using a VPC across multiple AZs, an Application Load Balancer (ALB), Auto Scaling Group (ASG), CloudWatch alarms, and SNS notifications.

## Architecture
- VPC with 2 public subnets across 2 Availability Zones
- Application Load Balancer routing HTTP traffic to EC2 instances in an Auto Scaling Group
- Dynamic scaling policies (scale out/in) based on CPU utilization
- CloudWatch for monitoring and alarms; SNS for email notifications


## Implementation (Condensed)
1. **VPC & Networking**
   - Create a VPC, 2 public subnets in different AZs.
   - Attach an Internet Gateway; update route table for public access.

2. **Launch Template + User Data**
   - Create a Launch Template referencing your AMI and instance type.
   - Paste this user‑data to serve a simple web page:
     ```bash
     #!/bin/bash
     yum install -y httpd
     systemctl start httpd
     systemctl enable httpd
     echo "Hello from Auto Scaling EC2 in $(hostname -f)" > /var/www/html/index.html
     ```

3. **Auto Scaling Group (ASG) + Application Load Balancer (ALB)**
   - Target the 2 public subnets.
   - Attach the ALB Target Group to the ASG.

4. **Scaling Policies**
   - Example thresholds:
     - Scale out when CPUUtilization > 70% for 1 minute.
     - Scale in when CPUUtilization < 20% for 1 minute.

5. **Monitoring & Alerts**
   - Create a CloudWatch alarm on `CPUUtilization`.
   - Configure an SNS topic and email subscription for notifications.

## Validate / Output
- Hitting the **ALB DNS** should rotate responses from different EC2 instances.
- ASG activity shows launches/terminations as policies trigger.
- CloudWatch alarm transitions to ALARM state on threshold breach; **SNS** sends an email.

## Repo Structure
```
server-based-webapp/
├─ README.md
├─ user-data.sh
└─ screenshots/
   └─ architecture.png   # (add your diagram)
```

## How to Reproduce (Quickstart)
1. Create VPC + 2 public subnets (different AZs), IGW + public route.
2. Create Launch Template (paste the user‑data).
3. Create Target Group (HTTP), ALB (HTTP:80), and register targets via ASG.
4. Create ASG (min=2) across both subnets; attach to Target Group.
5. Add scale policies and CloudWatch alarm; configure SNS notifications.

## Future Enhancements
- Migrate to private subnets + NAT for better security.
- Add HTTPS (ACM certificate) and redirect HTTP→HTTPS.
- Use IaC (CloudFormation/Terraform) to version infrastructure.
- Add blue/green or rolling deployments with CodeDeploy.

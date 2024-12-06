resource "aws_config_configuration_recorder_status" "foo" {
  name       = aws_config_configuration_recorder.foo.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.foo]
}

resource "aws_iam_role_policy_attachment" "a" {
  role       = aws_iam_role.r.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_s3_bucket" "b" {
  bucket = "awsconfig-example"
}

resource "aws_config_delivery_channel" "foo" {
  name           = "example"
  s3_bucket_name = aws_s3_bucket.b.bucket
}

resource "aws_config_configuration_recorder" "foo" {
  name     = "example"
  role_arn = aws_iam_role.r.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "r" {
  name               = "example-awsconfig"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "p" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.b.arn,
      "${aws_s3_bucket.b.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "p" {
  name   = "awsconfig-example"
  role   = aws_iam_role.r.id
  policy = data.aws_iam_policy_document.p.json
}

/*
**AWS Config** is a **management service** used to track, monitor, and manage the configurations of AWS resources. It records changes to the configuration of resources over time and provides reports on these changes. With AWS Config, you can ensure that your infrastructure is compliant, conduct security audits, and access the historical configurations of resources.

### AWS Config Features

1. **Resource Tracking:**
   - AWS Config tracks AWS resources (such as EC2, S3, IAM, RDS, etc.) and records their historical configurations. This allows you to see what configuration a resource had at any point in time.

2. **Change Tracking:**
   - AWS Config logs every change made to your resources (e.g., when an IAM role is added or an EC2 instance is launched) and alerts you to these changes. This helps you monitor the evolution of your infrastructure.

3. **Compliance Auditing:**
   - AWS Config can audit your resources to ensure they are configured according to specific compliance standards, such as PCI-DSS, HIPAA, etc. It helps you quickly identify configuration errors and non-compliance.

4. **Historical Review:**
   - AWS Config provides access to the historical configurations of your resources, which is useful for troubleshooting and identifying configuration mistakes.

5. **Automated Events and Alerts:**
   - AWS Config can automatically generate alerts based on rules you define. For example, if a resource violates a security standard, AWS Config can send an alert or trigger a Lambda function.

### Use Cases for AWS Config

1. **Infrastructure Management:**
   - AWS Config helps you manage the state of your infrastructure by tracking the configurations of your resources and changes to them over time.

2. **Security and Compliance Auditing:**
   - AWS Config helps you enforce compliance with security standards and regulatory frameworks. For example, you can check if S3 buckets are publicly accessible.

3. **Debugging and Troubleshooting:**
   - You can review historical configurations of your resources to identify configuration errors and understand when and how changes were made in your infrastructure.

4. **Advanced Security Monitoring:**
   - AWS Config helps you continuously monitor security standards and respond quickly when compliance violations occur.

### AWS Config Components

1. **Config Recorder:**
   - A component that records changes to AWS resources. The Config Recorder monitors and records resources integrated with AWS Config.

2. **Config Rules:**
   - AWS Config Rules help ensure your resources are configured according to specific rules. For example, you can check security groups of EC2 instances.

3. **Configuration History:**
   - Provides the historical configuration data of your resources. This helps you understand when and how a resource was changed.

4. **Remediation:**
   - You can trigger AWS Lambda functions to automatically remediate non-compliance situations.

AWS Config continuously provides insights into the state of your infrastructure, enhances security, and makes resource management more efficient.


**AWS Config** is a **management service** used to track, monitor, and manage the configurations of AWS resources. It records changes to the configuration of resources over time and provides reports on these changes. With AWS Config, you can ensure that your infrastructure is compliant, conduct security audits, and access the historical configurations of resources.

### AWS Config Features

1. **Resource Tracking:**
   - AWS Config tracks AWS resources (such as EC2, S3, IAM, RDS, etc.) and records their historical configurations. This allows you to see what configuration a resource had at any point in time.

2. **Change Tracking:**
   - AWS Config logs every change made to your resources (e.g., when an IAM role is added or an EC2 instance is launched) and alerts you to these changes. This helps you monitor the evolution of your infrastructure.

3. **Compliance Auditing:**
   - AWS Config can audit your resources to ensure they are configured according to specific compliance standards, such as PCI-DSS, HIPAA, etc. It helps you quickly identify configuration errors and non-compliance.

4. **Historical Review:**
   - AWS Config provides access to the historical configurations of your resources, which is useful for troubleshooting and identifying configuration mistakes.

5. **Automated Events and Alerts:**
   - AWS Config can automatically generate alerts based on rules you define. For example, if a resource violates a security standard, AWS Config can send an alert or trigger a Lambda function.

### Use Cases for AWS Config

1. **Infrastructure Management:**
   - AWS Config helps you manage the state of your infrastructure by tracking the configurations of your resources and changes to them over time.

2. **Security and Compliance Auditing:**
   - AWS Config helps you enforce compliance with security standards and regulatory frameworks. For example, you can check if S3 buckets are publicly accessible.

3. **Debugging and Troubleshooting:**
   - You can review historical configurations of your resources to identify configuration errors and understand when and how changes were made in your infrastructure.

4. **Advanced Security Monitoring:**
   - AWS Config helps you continuously monitor security standards and respond quickly when compliance violations occur.

### AWS Config Components

1. **Config Recorder:**
   - A component that records changes to AWS resources. The Config Recorder monitors and records resources integrated with AWS Config.

2. **Config Rules:**
   - AWS Config Rules help ensure your resources are configured according to specific rules. For example, you can check security groups of EC2 instances.

3. **Configuration History:**
   - Provides the historical configuration data of your resources. This helps you understand when and how a resource was changed.

4. **Remediation:**
   - You can trigger AWS Lambda functions to automatically remediate non-compliance situations.

AWS Config continuously provides insights into the state of your infrastructure, enhances security, and makes resource management more efficient.


**AWS Config Rules** is a feature of **AWS Config** that allows you to define and enforce rules on your AWS resources to ensure they comply with best practices, security standards, and organizational policies. These rules evaluate the configuration of resources and trigger compliance checks, allowing you to monitor whether your resources are compliant with specified configurations.

### Key Features of AWS Config Rules:

1. **Compliance Monitoring:**
   - AWS Config Rules automatically check whether your resources comply with predefined configurations or organizational policies. For example, you can create rules to ensure that EC2 instances are using the correct security groups or that S3 buckets do not allow public access.

2. **Predefined Managed Rules:**
   - AWS Config provides a library of predefined, **managed rules** that you can use directly. These rules cover common use cases like ensuring EC2 instances have a specific tag or checking that security groups do not allow unrestricted inbound traffic.

3. **Custom Rules:**
   - You can also create custom rules to meet specific requirements for your environment. These custom rules are typically written as AWS Lambda functions that define the logic to check the configuration of your resources.

4. **Continuous Monitoring:**
   - AWS Config Rules continuously monitor the configuration of your resources. Whenever a resource configuration changes, the rules are evaluated again to ensure compliance.

5. **Automatic Remediation:**
   - AWS Config Rules can trigger automated remediation actions when non-compliance is detected. For example, if a rule detects that an S3 bucket is publicly accessible, you can automatically remediate the issue by triggering a Lambda function to modify the bucket’s permissions.

6. **Real-time Notifications:**
   - You can set up Amazon SNS (Simple Notification Service) to notify you when a resource violates a Config Rule, making it easier to quickly respond to non-compliant resources.

### Example AWS Config Rules:

- **EC2 Security Groups Compliance:** Ensure that EC2 instances are not associated with security groups that allow unrestricted access (e.g., open ports like 0.0.0.0/0 for SSH).
  
- **S3 Bucket Public Access:** Ensure that S3 buckets do not have public access enabled.

- **IAM Password Policy:** Ensure that IAM users follow the organization’s password policy (e.g., passwords must be at least 8 characters long, must include special characters, etc.).

- **VPC Flow Logs:** Ensure that VPC Flow Logs are enabled for all VPCs to capture network traffic data.

### Benefits of AWS Config Rules:

1. **Automated Compliance Checks:**
   - Automates the process of checking whether your resources comply with company policies, security standards, and industry regulations.
   
2. **Simplified Auditing:**
   - Provides an easy way to audit your AWS environment and ensure that resources are always in the desired state.

3. **Visibility and Reporting:**
   - Gives visibility into compliance status across your AWS environment, helping with security, compliance reporting, and risk management.

4. **Cost Efficiency:**
   - Prevents misconfigurations and non-compliance that could result in security vulnerabilities or potential costs due to improper resource configurations.

5. **Scalability:**
   - AWS Config Rules can scale automatically to monitor large AWS environments with numerous resources.

### Example of AWS Config Rule:

Here is an example of how to create an AWS Config Rule using Terraform to check whether S3 buckets have public access disabled:

```hcl
resource "aws_config_config_rule" "s3_bucket_public_access" {
  name        = "s3-bucket-public-access"
  description = "Ensure S3 buckets do not allow public access."

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}
```

This rule will check all S3 buckets and flag any bucket that allows public access.

### Conclusion:

**AWS Config Rules** help automate compliance and governance within your AWS environment by ensuring that your resources are always configured according to your organization’s policies and security standards. By using AWS Config Rules, you can reduce manual efforts in auditing and correcting configuration issues, as well as ensure ongoing compliance with regulatory and security requirements.


**AWS Config Rules** can evaluate the configuration of different **AWS resources** to ensure they comply with your organizational policies, security best practices, or compliance standards. These rules help ensure that your resources are correctly configured and can trigger notifications or remediation actions if any resource violates a rule.

Below is a list of **AWS resources** that AWS Config Rules can monitor and evaluate for compliance:

### 1. **EC2 Instances**
   - **Security Groups Compliance**: Ensure EC2 instances are associated with security groups that do not allow inbound traffic from `0.0.0.0/0` (open access).
   - **Instance State**: Check that EC2 instances are in a running or stopped state according to your policy.
   - **Instance Tags**: Ensure that EC2 instances have specific tags, such as `Environment: Production`.

### 2. **S3 Buckets**
   - **Public Access**: Ensure S3 buckets do not allow public access (e.g., no `*` for public access in bucket permissions).
   - **Versioning**: Ensure that versioning is enabled on all S3 buckets.
   - **Logging**: Ensure that logging is enabled for all S3 buckets.

### 3. **IAM Resources**
   - **IAM Roles**: Ensure that IAM roles are properly configured, with necessary policies and permissions, and do not have overly broad permissions.
   - **IAM User Password Policy**: Ensure that IAM users follow your organization’s password policy (e.g., minimum password length, complexity requirements).
   - **IAM Group Permissions**: Check that IAM users are not granted permissions directly but are instead assigned to IAM groups.

### 4. **VPC (Virtual Private Cloud) Resources**
   - **Flow Logs**: Ensure VPC Flow Logs are enabled to monitor traffic flow in and out of your VPC.
   - **Public Subnets**: Ensure that public subnets do not have overly permissive routing or access.
   - **VPC Peering**: Ensure that VPC peering connections follow proper security and routing rules.

### 5. **CloudTrail**
   - **CloudTrail Logging**: Ensure that AWS CloudTrail is enabled to log all management and data events for your AWS account.
   - **CloudTrail Multi-region Trails**: Ensure that CloudTrail is set up with multi-region support to capture logs from all regions.
   
### 6. **RDS (Relational Database Service)**
   - **Encryption**: Ensure RDS instances are encrypted using AWS KMS (Key Management Service).
   - **Backup**: Ensure automated backups are enabled for RDS instances.
   - **Public Accessibility**: Ensure that RDS instances are not publicly accessible unless necessary.

### 7. **Lambda Functions**
   - **Environment Variables**: Ensure that Lambda functions use environment variables for sensitive data, instead of hardcoded values.
   - **Concurrency Settings**: Ensure that concurrency settings for Lambda functions do not exceed predefined thresholds.

### 8. **Elastic Load Balancers (ELB)**
   - **SSL/TLS Configuration**: Ensure that ELBs use secure SSL/TLS configurations to prevent weak cipher suites.
   - **Cross-zone Load Balancing**: Ensure that cross-zone load balancing is enabled for ELBs to ensure high availability.

### 9. **EBS (Elastic Block Store)**
   - **Encryption**: Ensure that EBS volumes are encrypted.
   - **Snapshot Management**: Ensure that regular snapshots are created and stored securely.
   
### 10. **CloudFormation Stacks**
   - **Stack Deletion Protection**: Ensure that deletion protection is enabled for critical CloudFormation stacks.
   - **Change Set Approval**: Ensure that changes to CloudFormation stacks go through the change set approval process.

### 11. **Security Groups**
   - **Ingress Rules**: Ensure that security groups do not have overly permissive ingress rules (e.g., open ports like 22, 80, 443).
   - **Egress Rules**: Ensure that security groups have the appropriate egress rules for controlled outbound access.

### 12. **Elastic Beanstalk**
   - **Environment Configuration**: Ensure that the AWS Elastic Beanstalk environment is configured securely (e.g., no public access to sensitive applications).
   - **Environment Health**: Monitor the health of the Elastic Beanstalk environment and ensure it remains in a healthy state.

### 13. **Route 53 (DNS)**
   - **DNSSEC (Domain Name System Security Extensions)**: Ensure DNSSEC is enabled to protect the integrity of DNS data.
   - **Record Set Compliance**: Ensure that domain record sets (such as A, MX, or CNAME records) are compliant with the organization’s security policy.

### 14. **AWS Organizations**
   - **Service Control Policies (SCPs)**: Ensure that service control policies are in place to restrict certain actions across accounts in AWS Organizations.
   - **Account Access**: Ensure that accounts in your AWS Organization are appropriately configured for security and compliance.

### 15. **KMS (Key Management Service)**
   - **Key Rotation**: Ensure that KMS encryption keys are rotated regularly.
   - **Key Usage**: Ensure that KMS keys are used for encryption and decryption operations appropriately.

### 16. **SNS (Simple Notification Service)**
   - **Topic Encryption**: Ensure that SNS topics use encryption.
   - **Topic Access Control**: Ensure that SNS topics have appropriate access policies that restrict who can publish or subscribe to the topics.

### 17. **EFS (Elastic File System)**
   - **Encryption**: Ensure that EFS file systems are encrypted.
   - **Access Control**: Ensure that access points and mount targets are correctly configured to prevent unauthorized access.

### Predefined AWS Managed Config Rules:
AWS Config provides **predefined managed rules** that automatically check resources for common compliance checks, including:
- **ec2-instance-no-public-ip**: Checks if EC2 instances have public IP addresses.
- **iam-password-policy**: Ensures that IAM users follow the organization's password policy.
- **s3-bucket-public-read-prohibited**: Ensures that S3 buckets do not allow public read access.
- **rds-instance-public-access-check**: Ensures that RDS instances are not publicly accessible.

### Custom Config Rules:
In addition to AWS-managed rules, you can create **custom rules** using AWS Lambda functions to enforce more specific policies tailored to your needs.

### Example of a Custom AWS Config Rule (Using Lambda):
```hcl
resource "aws_config_config_rule" "custom_security_group_rule" {
  name        = "custom-security-group-rule"
  description = "Ensure security group does not allow open access"

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.security_group_check.arn
  }
}
```
This example shows how you can create a custom rule that uses a Lambda function (`aws_lambda_function.security_group_check`) to evaluate whether the security group is compliant.

### Benefits of AWS Config Rules:
- **Automated Compliance Checks**: Ensures that resources are continuously compliant with policies.
- **Reduced Manual Effort**: Automates the process of auditing configurations and enforcing security best practices.
- **Improved Security and Governance**: Prevents misconfigurations and security vulnerabilities by continuously monitoring resources.
- **Scalable Compliance**: Can scale to monitor hundreds or thousands of resources across your AWS environment.

By leveraging AWS Config Rules, you can continuously monitor your AWS resources for compliance, enforce best practices, and ensure that your infrastructure remains secure and well-configured.

*/

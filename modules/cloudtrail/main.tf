

resource "aws_cloudtrail" "example" {
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket_name
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
}




/*

**What is AWS CloudTrail?**

AWS CloudTrail is a service provided by Amazon Web Services (AWS) that keeps a record of all activities occurring within your AWS account. 
CloudTrail enables users to monitor, audit, and analyze operations in their AWS infrastructure. It is a critical tool for meeting both security and compliance needs.

### Key Features of CloudTrail:
1. **Recording AWS API Calls:**
   - CloudTrail records API calls made by users, roles, or AWS services.
   - For instance, operations such as launching an EC2 instance, accessing an S3 bucket, or modifying an IAM role can be tracked.

2. **Activity Logs:**
   - CloudTrail can store log files in an Amazon S3 bucket.
   - These logs are saved in JSON format and can be used for analysis or reporting.

3. **Event Management:**
   - With the **Event History** feature, CloudTrail allows you to instantly view events.
   - It is useful for tracking or reviewing past activities.

4. **Multi-Account and Multi-Region Support:**
   - You can use a single CloudTrail trail to monitor activities across multiple AWS accounts and regions.

5. **Compliance and Security:**
   - CloudTrail helps meet compliance requirements (e.g., SOC, PCI, ISO standards).
   - It can be used to detect suspicious activities and prevent security threats.

### Use Cases:
- **Security Auditing:**
  - Detecting and analyzing suspicious activities.
  - Understanding who accessed which resources.

- **Compliance Monitoring:**
  - Using logs to demonstrate adherence to regulatory standards.

- **Incident Response:**
  - Analyzing logs after a security event to understand how it occurred.

- **Audit and Analysis:**
  - Analyzing administrator and user activities.
  - Monitoring API calls for cost optimization.

### How CloudTrail Works:
1. **Defining a Trail:**
   - You can create a trail to customize CloudTrail.
   - A trail can be configured to cover specific accounts, regions, or all AWS accounts.

2. **Storing Data:**
   - CloudTrail logs can be stored in an S3 bucket or monitored in real-time using AWS CloudWatch Logs.

3. **Tracking Events:**
   - Events and logs can be viewed through the AWS Management Console, CLI, or SDKs.

CloudTrail allows you to manage your AWS environment transparently and securely. It is an essential tool, especially for organizations running large-scale or critical operations.



### What are CloudTrail Events?

The events recorded in **AWS CloudTrail** represent various activities and operations performed on your AWS resources. These **events** allow you to track API calls, service activities, and security-related incidents within your AWS account.

### Types of CloudTrail Events

1. **Management Events:**
   - Records API calls made to manage AWS resources.
   - Examples:
     - Launching an EC2 instance (`RunInstances`)
     - Creating an S3 bucket (`CreateBucket`)
     - Creating an IAM user (`CreateUser`)
   - **Default:** Management Events are recorded by default but can be disabled if desired.

2. **Data Events:**
   - Tracks operations performed on data objects in AWS services.
   - Examples:
     - Accessing a specific file in an S3 bucket (`GetObject`, `PutObject`)
     - Invoking a Lambda function (`InvokeFunction`)
   - **Note:** Data Events are not recorded by default and require explicit activation, which may incur additional costs.

3. **Insights Events:**
   - Detects and reports unusual or unexpected activities.
   - Examples:
     - Unusually high API call volumes
     - Anomalies in operation durations
   - This feature helps identify anomalies and troubleshoot issues effectively.

---

### Details Within Event Categories

#### 1. **Read Events:**
   - Includes operations that retrieve data or resource details.
   - Example:
     - Reading a file from an S3 bucket (`GetObject`)
     - Checking the status of an EC2 instance (`DescribeInstances`)

#### 2. **Write Events:**
   - Includes operations that modify resources.
   - Example:
     - Uploading a file to an S3 bucket (`PutObject`)
     - Creating an IAM user (`CreateUser`)

#### 3. **Error Events:**
   - Records API calls that fail.
   - Example:
     - Attempting to add an invalid IAM policy
     - Failing to launch an EC2 instance due to insufficient permissions

#### 4. **Authentication Events:**
   - Tracks authentication-related activities such as logins.
   - Example:
     - Signing into the AWS Management Console (`ConsoleLogin`)
     - MFA authentication attempts

---

### Example Events in JSON Format

#### **Management Event:**
```json
{
  "eventName": "RunInstances",
  "eventSource": "ec2.amazonaws.com",
  "userIdentity": {
    "type": "IAMUser",
    "userName": "example-user"
  },
  "eventTime": "2024-12-06T10:00:00Z",
  "awsRegion": "us-east-1",
  "sourceIPAddress": "192.0.2.1",
  "responseElements": {
    "instanceId": "i-0abcd1234efgh5678"
  }
}
```

#### **Data Event (S3):**
```json
{
  "eventName": "GetObject",
  "eventSource": "s3.amazonaws.com",
  "s3": {
    "bucket": {
      "name": "example-bucket"
    },
    "object": {
      "key": "example.txt"
    }
  },
  "userIdentity": {
    "type": "IAMUser",
    "userName": "example-user"
  },
  "eventTime": "2024-12-06T11:00:00Z",
  "awsRegion": "us-east-1"
}
```

#### **Insight Event:**
```json
{
  "eventCategory": "Insight",
  "insightDetails": {
    "state": "Anomalous",
    "eventSource": "ec2.amazonaws.com",
    "eventName": "DescribeInstances"
  },
  "eventTime": "2024-12-06T12:00:00Z",
  "awsRegion": "us-west-2"
}
```

---

### How to Access Events
- **Event History:** Accessible directly through the AWS Management Console (provides up to 90 days of history for free).
- **S3 Bucket:** Logs can be stored in S3 for long-term retention.
- **CloudWatch Logs:** Useful for real-time analysis.
- **AWS SDK or CLI:** API calls can fetch detailed event information.

These events help you monitor and analyze activities transparently across your AWS infrastructure.


*/

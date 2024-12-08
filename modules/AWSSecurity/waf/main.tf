resource "aws_wafv2_web_acl" "example" {
  name        = "MyWebAppACL"
  description = "Protects against SQLi and rate-based attacks"
  scope       = "CLOUDFRONT"  # Use "REGIONAL" for ALB
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "MyWebAppACL"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "SQLiProtection"
    priority = 1
    action {
      block {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiProtection"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "RateLimit"
    priority = 2
    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit             = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }
}



/*

**AWS WAF (Web Application Firewall)** is a security service provided by Amazon Web Services (AWS) that protects web applications and APIs from common web threats. It monitors traffic, blocks malicious requests, and enhances application security.  

---

### **Key Features of AWS WAF:**  

1. **Web Traffic Monitoring:**  
   - Analyzes HTTP/HTTPS requests and filters traffic based on defined rules.  

2. **Custom Security Rules:**  
   - Allows creating rules for IP blocking, geographic filtering, request rate limiting, and preventing common attacks like SQL injection and XSS (Cross-Site Scripting).  

3. **Predefined Rule Sets:**  
   - Use pre-configured rule sets from the AWS Marketplace for quick security setup.  

4. **Bot Management:**  
   - Manages bot traffic, allowing good bots while blocking malicious ones.  

5. **Integration:**  
   - Works directly with Amazon CloudFront, Application Load Balancer (ALB), and API Gateway.  

6. **Real-Time Monitoring and Logging:**  
   - Provides real-time traffic analysis and security event monitoring through CloudWatch and AWS WAF logs.  

---

### **Benefits of AWS WAF:**  

- **DDoS Protection:**  
  - Offers additional protection against DDoS attacks when used with AWS Shield.  

- **Flexible Rule Management:**  
  - Create custom rules or use pre-built rule sets.  

- **Scalability:**  
  - Automatically protects web applications and APIs against increased traffic.  

- **Comprehensive Reporting:**  
  - Analyze traffic and attack statistics in detail.  

- **Cost-Efficiency:**  
  - Pay based on traffic volume, making it suitable for both small applications and large-scale systems.  

---

### **Use Cases for AWS WAF:**  

- **Web Application Security:**  
  - Preventing attacks like SQL injection and XSS.  

- **API Protection:**  
  - Securing API traffic against malicious requests.  

- **Bot Protection:**  
  - Blocking unwanted bot traffic while allowing legitimate bots.  

- **DDoS Mitigation:**  
  - Reducing the impact of DDoS attacks when integrated with AWS Shield.  

- **Compliance and Auditing:**  
  - Ensuring web application security standards compliance.  

AWS WAF is a powerful and flexible security solution designed to protect web applications from malicious threats. It automates security management and helps ensure the safety of your applications.

*/


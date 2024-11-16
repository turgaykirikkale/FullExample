resource "aws_s3_bucket" "b" {
  bucket = "mybucket"

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "development"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}




/*

Sure! Here's the English translation:

---

**AWS CloudFront** is a **Content Delivery Network (CDN)** service offered by **Amazon Web Services**. It is designed to deliver content to users faster and more reliably by caching and distributing it through geographically distributed **edge locations**.

### Key Functions of CloudFront
1. **Fast Content Delivery:**  
   CloudFront delivers static content (HTML, CSS, JavaScript, images) and dynamic content (API responses, live video streams) to users from the nearest edge location, reducing latency and providing a faster user experience.

2. **Security:**  
   - Protects against DDoS attacks with **AWS Shield** and **AWS Web Application Firewall (WAF)**.  
   - Encrypts data using the HTTPS protocol.  
   - Offers access control with features like **Origin Access Control (OAC)** and **Signed URLs**.

3. **Adaptive Scalability:**  
   Automatically scales to handle high traffic, ensuring service continuity even during peak loads.

4. **Integration:**  
   Works seamlessly with the AWS ecosystem, for example:  
   - Serving content from an **S3 Bucket**.  
   - Integrating with **Elastic Load Balancing (ELB)** or **EC2**.

5. **Location-Based Content Distribution:**  
   Delivers content via the nearest edge location based on the user’s geographic location, minimizing latency.

---

### Key Features
- **Caching:** Reduces server load by caching frequently accessed content.  
- **Real-time Metrics:** Integrated with CloudWatch for monitoring and performance analysis.  
- **Lambda@Edge:** Executes custom logic on content at edge locations for near-user response.  

### Use Cases
- Accelerating static and dynamic content for websites.  
- Video streaming (on-demand or live).  
- Enhancing API endpoint performance and security.  
- Speeding up software downloads.

### How CloudFront Works
1. **User Request:** The user makes a request for content (e.g., a video or webpage).  
2. **Access Point:** CloudFront routes the request to the edge location closest to the user.  
3. **Cache Check:**  
   - If the requested content is cached at the edge location, it is served directly to the user.  
   - If not, the content is fetched from the origin (e.g., S3 or EC2), cached at the edge location, and then delivered to the user.  
4. **Subsequent Requests:** Future requests for the same content are served quickly from the cache.


Sure! Here's the English translation:

---

**AWS CloudFront origins** are the original sources of the content, and CloudFront retrieves content from these sources to respond to user requests. As a **Content Delivery Network (CDN)**, CloudFront caches content at edge locations to provide faster access for users.

### Types of CloudFront Origins
CloudFront supports the following types of origins:

---

#### 1. **Amazon S3**
- **Purpose:** Distribution of static content (e.g., HTML, CSS, JS, images, videos).  
- **Use Case:**  
  - For files that are publicly accessible.  
  - Access to the S3 bucket can be restricted to only CloudFront using **Origin Access Control (OAC)** or the older method, **Origin Access Identity (OAI)**.  
- **Example:** Distributing website assets like images or stylesheets.

---

#### 2. **Amazon EC2**
- **Purpose:** Delivery of dynamic content or serving content from an application server.  
- **Use Case:**  
  - EC2 instances functioning as web servers can dynamically generate content.  
  - CloudFront can establish a secure connection with EC2 instances via HTTPS.  
- **Example:** Delivering API responses or user-specific content quickly.

---

#### 3. **Elastic Load Balancing (ELB)**
- **Purpose:** Distributing content from multiple backend sources (e.g., EC2 instances) in a scalable and reliable way.  
- **Use Case:**  
  - CloudFront works with ELB to provide load balancing for high-traffic applications.  
  - Features like health checks can monitor the status of backend resources.  
- **Example:** Ensuring scalability and high availability for dynamic web applications.

---

#### 4. **AWS Lambda@Edge or AWS API Gateway**
- **Purpose:**  
  - **Lambda@Edge:** Run custom code close to users to manipulate content.  
  - **API Gateway:** Speed up API endpoints through CloudFront.  
- **Use Case:**  
  - Customize requests or responses with Lambda@Edge.  
  - Enhance performance for RESTful or GraphQL APIs with API Gateway.  
- **Example:** Delivering region-specific content or customizing HTTP headers.

---

#### 5. **Custom HTTP/HTTPS Server**
- **Purpose:** Serving content from a source server outside AWS.  
- **Use Case:**  
  - On-premises servers hosted in a data center.  
  - Servers hosted on other cloud providers.  
- **Example:** Distributing content from on-premises or third-party applications.

---

### Multi-Origin Configuration
CloudFront can use multiple origins to deliver content from different sources. Using **Origin Groups**, you can configure primary and failover origins to ensure high availability.

### Factors to Consider When Choosing an Origin
When selecting an origin, consider the following factors:
- **Static/Dynamic Content:** Use S3 for static content, and EC2 or ELB for dynamic content.  
- **User Proximity:** Choose a geographic location that provides the fastest response to users.  
- **Security:** Implement security mechanisms to restrict access to origin resources.  
- **Integration:** Ensure compatibility with the AWS ecosystem (e.g., authorization with IAM).  


Of course! Here's the English translation:

---

**Origin Access Control (OAC)** and **S3 Bucket Policy** are two essential mechanisms in AWS CloudFront's integration with Amazon S3. They ensure that the content in the S3 bucket is securely delivered and can only be accessed via CloudFront, restricting direct access.

---

### **Origin Access Control (OAC)**

OAC is a modern and secure method used by CloudFront to access S3 buckets. It replaces the older **Origin Access Identity (OAI)** method.

#### How Does OAC Work?  
1. **Creating OAC in CloudFront:**
   - CloudFront creates an Origin Access Control.  
   - This OAC acts like an identity that represents the permissions needed to access the S3 bucket.

2. **Associating OAC with S3 Bucket:**
   - The OAC is linked to a specific CloudFront distribution and allows only requests from this distribution to access the S3 bucket.

3. **IAM Authorization:**
   - OAC integrates with IAM, and permissions for the OAC are added to the S3 bucket policy.

4. **Restricting Public Access:**
   - The S3 bucket's public access is disabled, ensuring that content is only accessible via CloudFront.

#### Advantages:
- It is more secure and up-to-date.  
- Supports access over HTTPS and follows best security practices by default.  
- Simplifies management due to its IAM-based approach.

---

### **S3 Bucket Policy**
The S3 Bucket Policy is a JSON-based document that defines access controls for an S3 bucket. When working with CloudFront, the Bucket Policy can be configured to only allow requests coming from CloudFront.

#### Example S3 Bucket Policy:
This policy allows only requests from a specific CloudFront distribution using OAC:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket-name/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::your-account-id:distribution/your-distribution-id"
        }
      }
    }
  ]
}
```

- **`Principal`**: Specifies that the requester is the CloudFront service.  
- **`Condition`**: Ensures that only requests from the specified CloudFront distribution are allowed.

---

### **How OAC and S3 Policy Work Together with CloudFront**
1. **Step 1:** Create a CloudFront distribution and define an OAC.  
2. **Step 2:** Add the necessary permissions for the OAC to the S3 Bucket Policy.  
3. **Step 3:** Disable public access to the S3 bucket.  
4. **Result:** CloudFront securely accesses the S3 bucket and serves requests to users.

---

### Process Overview
1. A user requests content (e.g., an image).  
2. CloudFront uses the OAC identity to access the S3 bucket.  
3. The S3 Bucket Policy allows only CloudFront requests with the OAC to retrieve content.  
4. CloudFront retrieves the content and delivers it to the user.


Certainly! Here's the English translation:

---

**CloudFront** and **S3 Cross-Region Replication (CRR)** are two distinct AWS technologies that serve different purposes. The key differences lie in their content delivery methods and use cases. Here’s a detailed comparison:

---

### **1. AWS CloudFront**
#### **Purpose:**  
CloudFront is a **Content Delivery Network (CDN)** designed to deliver content quickly and securely to users through the nearest **edge location**.

#### **How It Works?**  
- CloudFront fetches content from an **origin**, such as an **S3 bucket**, **EC2 instance**, **Elastic Load Balancer (ELB)**, or a custom HTTP server.  
- Content is cached at **CloudFront edge locations** (AWS’s global caching points).  
- When a user requests content:  
  - If the content is cached at the edge location, it is served directly from there (low latency).  
  - Otherwise, the content is fetched from the origin, cached at the edge location, and then delivered to the user.

#### **Use Cases:**
- Fast content delivery for websites and applications.  
- Streaming videos.  
- Delivering dynamic or static content with low latency.  
- Secure content distribution (e.g., using HTTPS and AWS WAF).

#### **Key Features:**
- **Temporary Cache:** Content is cached only when requested.  
- **Global Distribution:** Serves users from the geographically nearest edge location.  
- **Latency Reduction:** Speeds up content delivery.

---

### **2. S3 Cross-Region Replication (CRR)**
#### **Purpose:**  
S3 CRR is a **backup and data replication** solution that automatically replicates content from one AWS region's S3 bucket to another.

#### **How It Works?**  
- CRR operates between a source bucket and a destination bucket.  
- When an object is created in the source bucket, it is automatically copied to the destination bucket without user intervention.  
- Replication is governed by S3 replication rules and runs continuously.

#### **Use Cases:**
- **High availability and disaster recovery:** Backing up data to another region.  
- **Compliance requirements:** Ensuring data is stored in specific regions.  
- **Performance optimization:** Keeping copies of data in multiple regions for local access.

#### **Key Features:**
- **Full Copy:** Content is entirely replicated to the destination bucket.  
- **Automation:** CRR works continuously once configured.  
- **Long-Term Storage:** Ensures data is permanently available in another region.

---

### **Differences Between CloudFront and S3 CRR**

| **Feature**               | **AWS CloudFront**                              | **S3 Cross-Region Replication (CRR)**          |
|---------------------------|------------------------------------------------|------------------------------------------------|
| **Purpose**               | Deliver content quickly and locally to users   | Automatically replicate data to another region |
| **Content Source**        | S3 bucket, EC2, ELB, custom HTTP server        | A source S3 bucket                             |
| **Data Storage**          | Temporary (cache-based)                        | Permanent (full copy)                          |
| **User Request**          | Content is fetched and cached upon user request | Content is automatically replicated without user interaction |
| **Performance Enhancement** | Reduces latency by serving content close to users | Data can be accessed faster from another region |
| **Management**            | Configuration and security policies for content delivery | Replication rules between source and destination buckets |
| **Scope**                 | Global (Edge Locations)                        | Regional (Region to Region)                    |

---

### **When to Use Each?**
1. **Use CloudFront:**
   - If you need to deliver content to end users quickly.  
   - To enhance the performance of your website, application, or API.  
   - To cache and serve both dynamic and static content efficiently.

2. **Use S3 CRR:**
   - If you want to back up or store your data in another region.  
   - To create a high availability and disaster recovery strategy.  
   - To replicate changes in one region to another in real-time.


CloudFront Geo Restriction is a powerful tool for restricting content access to specific countries. It is easy to configure and provides an effective solution, especially for legal, commercial, and security requirements.

CloudFront cache invalidation is a way to manage and refresh content in CloudFront edge locations. It's crucial for ensuring that users see the latest content, but it should be used carefully to avoid unnecessary costs and performance impacts.

Sure! Here's the translation of the information about CloudFront price classes:

---

CloudFront offers three different price classes to determine the pricing of your distribution. The price class defines which Amazon CloudFront edge locations you can use, which impacts whether users will be served from geographically closer edge locations. The features and pricing of each price class are as follows:

### 1. **PriceClass_100**
   - **Edge Locations**: This class uses only data centers in North America and Europe.
   - **Covered Regions**:
     - North America (US and Canada)
     - Europe
   - **Pricing**: This is the lowest-priced class, as fewer data centers are used.
   - **Use Case**: Suitable for users who are primarily located in these regions and need a low-cost solution.

### 2. **PriceClass_200**
   - **Edge Locations**: Includes North America, Europe, Asia-Pacific, and some Latin American regions.
   - **Covered Regions**:
     - North America
     - Europe
     - Asia-Pacific
     - Latin America
   - **Pricing**: This offers medium-level pricing.
   - **Use Case**: Ideal for users who want to serve a wider global audience but don’t need full coverage across the world.

### 3. **PriceClass_All**
   - **Edge Locations**: Covers over 200 global data center locations worldwide.
   - **Covered Regions**:
     - North America
     - Europe
     - Asia-Pacific
     - Latin America
     - Middle East
     - Africa
   - **Pricing**: This is the highest-priced class as it uses all global edge locations.
   - **Use Case**: Best for global distributions aiming to reach users around the world, but with higher costs in mind.

### Price Class Selection
The choice of price class typically depends on the geographic distribution of your target audience:
- **PriceClass_100** is suitable for low-cost solutions with limited geographic reach.
- **PriceClass_200** is a good choice for those needing broader geographic coverage at a mid-range price.
- **PriceClass_All** is ideal for users who want to reach a global audience and are willing to pay higher costs.

In Terraform, you can specify the price class like this:

```hcl
resource "aws_cloudfront_distribution" "example" {
  # Other configurations...

  price_class = "PriceClass_100"  # Other options: PriceClass_200, PriceClass_All
}
```

*/

# 4. Route 53 Hosted Zone
resource "aws_route53_zone" "teggies" {
  name = "teggies.com"
}

resource "aws_route53_record" "weighted_instance1" {
  zone_id = aws_route53_zone.teggies.zone_id
  name    = "www.teggies.com"
  type    = "A"
  ttl     = 300

  records        = [var.instance_ip]
  set_identifier = "Instance_${var.instance_ip}"
  weighted_routing_policy {
    weight = var.weight
  }
}
/*

DNS (Domain Name System) is a system that translates domain names into IP addresses on the internet. It allows users to access websites using memorable domain names (e.g., `www.google.com`) instead of numerical IP addresses (e.g., `142.250.190.78`), which computers use to communicate.

### How DNS Works
1. **Domain Name Query:** When a user enters a URL into their browser, the computer sends a query to a DNS server to resolve the domain name.
2. **DNS Servers:**
   - **Local DNS Server:** Initially, the query goes to your Internet Service Provider's (ISP) local DNS server.
   - **Root DNS Servers:** If the local server doesn't know the domain, the query is forwarded to root DNS servers, which identify the domain's top-level domain (TLD) (e.g., `.com`, `.org`).
   - **TLD Servers:** These servers locate the authoritative DNS server for the domain.
   - **Authoritative DNS Server:** Finally, the authoritative server provides the matching IP address for the domain name.
3. **IP Address Response:** The DNS server returns the correct IP address, enabling the computer to connect to the website.

### Types of DNS Records
- **A Record (Address Record):** Links a domain name to an IPv4 address.
- **AAAA Record:** Links a domain name to an IPv6 address.
- **CNAME Record (Canonical Name Record):** Redirects one domain name to another.
- **MX Record (Mail Exchange Record):** Specifies email servers for email traffic.
- **NS Record (Name Server):** Indicates which DNS server is authoritative for the domain.
- **PTR Record:** Maps an IP address to a domain name (reverse DNS lookup).
- **TXT Record:** Provides additional information about a domain (e.g., SPF, DKIM).

### Importance of DNS
- **User Experience:** It allows people to use easy-to-remember domain names instead of complex IP addresses.
- **Internet Communication:** Facilitates access to websites, emails, and other internet services.
- **Performance and Security:** DNS caching speeds up queries, and security protocols like DNSSEC protect against fake DNS responses.

Without DNS, the internet would be much more complex and challenging to use.


DNS terminology helps us understand how various components and concepts within the DNS system function. Here are the main elements of DNS terminology:

### 1. **Domain Name**
   - **Domain Name:** A web address designed to be human-readable (e.g., `example.com`).
   - **Subdomain:** A section added to the main domain name, appearing in front of it (e.g., `mail.example.com`).
   - **Top-Level Domain (TLD):** The final section of the domain name (e.g., `.com`, `.org`, `.net`).

### 2. **Root Servers**
   - Located at the top of the DNS hierarchy, root servers are globally distributed and determine the top-level domain of a given domain name.

### 3. **Authoritative DNS Server**
   - The DNS server that holds definitive information about a specific domain name. This server provides the IP address or other DNS records for the domain.

### 4. **Resolver**
   - A DNS resolver receives DNS queries from users and relays them to DNS servers to find the needed information. It’s typically provided by an Internet Service Provider (ISP) and is used to resolve the domain names entered into the browser.

### 5. **DNS Records**
   DNS records contain information about a domain name. Common types include:
   - **A Record (Address Record):** Links the domain name to an IPv4 address.
   - **AAAA Record:** Links the domain name to an IPv6 address.
   - **CNAME Record (Canonical Name Record):** Redirects one domain name to another.
   - **MX Record (Mail Exchange Record):** Specifies email servers for email traffic.
   - **NS Record (Name Server):** Indicates the authoritative DNS server for the domain.
   - **PTR Record:** Provides a reverse DNS lookup by mapping an IP address to a domain name.
   - **TXT Record:** Provides additional information about a domain.

### 6. **DNS Caching**
   - DNS servers use caching to speed up frequent queries. When resolvers find an IP address for a domain, they store it for a specified period, controlled by the **TTL (Time to Live)** parameter.

### 7. **Types of DNS Queries**
   - **Recursive Query:** The resolver queries other DNS servers until the requested information is found.
   - **Iterative Query:** The resolver provides only the information it directly has or refers to another DNS server.
   - **Reverse Lookup:** Takes an IP address and finds the domain name associated with it.

### 8. **DNSSEC (DNS Security Extensions)**
   - DNSSEC is a security protocol that ensures the accuracy of DNS data by adding digital signatures to DNS responses, protecting users from DNS spoofing and ensuring they reach legitimate sites.

### How DNS Terminology Works Together
When a user enters `example.com` in their browser:
1. **Query Begins:** The user’s resolver server receives the query and sends it to a root server.
2. **Routing:** The root server directs the resolver to the appropriate TLD server (e.g., `.com` server).
3. **Finding the Authoritative Server:** The TLD server points to the authoritative DNS server for the domain.
4. **Response:** The authoritative DNS server returns the answer, such as an IP address.
5. **Caching:** The resolver caches the response for a specific time and sends the IP address back to the user’s browser.
6. **Accessing the Website:** The browser uses the IP address to connect to the site, allowing the user to view the website.

DNS terminology helps explain the structure of DNS, and understanding these terms clarifies how DNS functions.


Example Walkthrough
Imagine you type www.example.com in your browser:

The query starts and checks local cache.
If unresolved, it’s sent to the ISP's DNS resolver.
The resolver contacts a root DNS server, which directs it to a .com TLD server.
The .com server sends the address of example.com's authoritative DNS server.
The authoritative server provides the IP address for www.example.com.
The browser receives the IP address, connects to the site, and the page loads.
This entire process happens in milliseconds, making it nearly instant for users.




Amazon Route 53 is a highly scalable, reliable, and low-latency DNS (Domain Name System) service provided by Amazon Web Services (AWS). It translates domain names into IP addresses, enabling users to access resources on the internet easily. Route 53 also offers advanced routing features such as geo-routing, DNS failover, and latency-based routing to optimize web applications.

### Key Features of Amazon Route 53

1. **Domain Registration**:
   - Route 53 allows you to register domain names. You can purchase a domain through AWS or transfer an existing one to Amazon Route 53.

2. **DNS Routing**:
   - Amazon Route 53 can route incoming queries based on pre-defined criteria. Key routing types include:
     - **Simple Routing:** Provides straightforward routing to a single IP address or resource.
     - **Weighted Routing:** Distributes traffic among multiple targets based on assigned weights.
     - **Latency-Based Routing:** Directs users to the region with the lowest latency.
     - **Geolocation Routing:** Routes traffic based on the user's geographical location.
     - **Multivalue Answer Routing:** Returns multiple IP addresses for load distribution.
     - **Failover Routing:** Switches to a backup resource if the primary resource fails.

3. **DNS Resiliency and High Availability**:
   - Route 53 leverages a globally distributed infrastructure to provide high availability and low-latency DNS responses.

4. **Health Checks**:
   - Route 53 can monitor the health of specified resources. Health checks ensure that traffic is routed only to healthy resources during DNS queries.

5. **Private DNS for VPC Integration**:
   - Amazon Route 53 integrates with AWS Virtual Private Cloud (VPC) to provide private DNS services. This feature allows DNS routing to resources accessible only within the VPC.

6. **DNS Security**:
   - Route 53 supports DNS Security Extensions (DNSSEC) to ensure the authenticity and integrity of DNS responses.

### Advantages of Amazon Route 53

- **Global Reach and Speed**: With AWS's extensive global data center network, Route 53 delivers low-latency and high-speed DNS services.
- **Flexible and Customizable Routing**: Offers advanced options for traffic routing.
- **Integrated Health Checks and Failover**: Monitors resource health and quickly switches to backup resources in case of failure.
- **Ease of Management**: Fully integrated with AWS, making it easy to use alongside other AWS services.

Route 53 is an effective solution for managing DNS in AWS-based infrastructures, enhancing user experience, and ensuring high-performance, reliable DNS operations.


Amazon Route 53 supports various types of DNS records that allow for flexible and powerful domain management. Here are the primary types of records available in Route 53:

### 1. **A Record (Address Record)**
   - Maps a domain name to an IPv4 address, allowing users to reach resources like websites by typing in a domain instead of an IP address.
   - Example: `example.com` -> `192.0.2.1`

### 2. **AAAA Record**
   - Similar to an A record but maps a domain name to an IPv6 address.
   - Example: `example.com` -> `2001:0db8:85a3:0000:0000:8a2e:0370:7334`

### 3. **CNAME Record (Canonical Name Record)**
   - Redirects a domain name to another domain name. Commonly used to point subdomains to the main domain.
   - Example: `www.example.com` -> `example.com`

### 4. **MX Record (Mail Exchange Record)**
   - Specifies mail servers for email routing. The priority number indicates the preference for the email server.
   - Example: `example.com` -> `mail1.example.com` (Priority 10), `mail2.example.com` (Priority 20)

### 5. **TXT Record (Text Record)**
   - Stores arbitrary text. Often used for verification purposes, such as domain ownership verification, and to hold security-related information like SPF, DKIM, and DMARC records for email security.
   - Example: `example.com` -> `v=spf1 include:example.com ~all`

### 6. **NS Record (Name Server Record)**
   - Specifies the authoritative DNS servers for a domain. These are required for the domain to be discoverable on the internet.
   - Example: `example.com` -> `ns-2048.awsdns-64.com`

### 7. **SRV Record (Service Record)**
   - Defines the location of services within a domain. Often used for SIP or XMPP protocols, with priority, weight, port, and target fields.
   - Example: `_sip._tcp.example.com` -> `5 0 5060 sipserver.example.com`

### 8. **PTR Record (Pointer Record)**
   - Used for reverse DNS lookups, mapping an IP address back to a domain name. Generally managed by ISPs or data center providers.
   - Example: `192.0.2.1` -> `example.com`

### 9. **SOA Record (Start of Authority Record)**
   - Every DNS zone has one SOA record that defines global settings for the domain, such as primary DNS server, contact email, and caching parameters.
   - Example: `example.com` SOA with primary server `ns-2048.awsdns-64.com`

### 10. **Alias Record**
   - An Amazon-specific record that works similarly to a CNAME but at the root domain level (e.g., `example.com`). Can point to AWS resources (like ELB, CloudFront, S3) without incurring additional DNS query charges.
   - Example: `example.com` Alias to an AWS ELB or CloudFront distribution.

### 11. **CAA Record (Certification Authority Authorization)**
   - Specifies which certificate authorities (CAs) are permitted to issue SSL/TLS certificates for a domain. Adds an extra layer of security to prevent unauthorized CAs from issuing certificates.
   - Example: `example.com` -> `0 issue "letsencrypt.org"`

These record types in Amazon Route 53 provide flexibility and control for managing domain configurations and directing traffic based on different criteria and needs.


In Amazon Route 53, a **hosted zone** is a container used to manage the DNS settings of a domain. Simply put, a hosted zone is a logical unit that groups the DNS records for a domain or subdomain, allowing you to configure and organize all DNS settings for that domain.

### Types of Hosted Zones

There are two types of hosted zones in Route 53:

1. **Public Hosted Zone**:
   - Used for resources that are accessible over the internet.
   - For example, when you create a public hosted zone for a domain like `example.com`, the domain and its associated DNS records can be queried by anyone.
   - Suitable for public-facing services such as websites and email servers.

2. **Private Hosted Zone**:
   - Provides DNS management for resources within an AWS Virtual Private Cloud (VPC).
   - For instance, you can create a private domain (`internal.example.com`) that can only be accessed by resources inside the VPC.
   - Ideal for internal applications, private networks, or restricted access.

### What a Hosted Zone Contains

A hosted zone typically includes the following components:

- **SOA (Start of Authority) Record**:
  - Every hosted zone starts with an SOA record. This record contains basic information about the domain (e.g., the primary DNS server).

- **NS (Name Server) Records**:
  - The hosted zone specifies the name servers for the domain. These records are added to your domain registrar's DNS settings, allowing Route 53 to answer DNS queries.

- **Other DNS Records**:
  - The hosted zone includes other DNS records such as A, CNAME, MX, TXT, and Alias. These records enable the domain to be routed to various resources (e.g., a web server or an email server).

### Example Usage of Hosted Zones

1. **Public Hosted Zone**:
   - Create a public hosted zone for a domain (`example.com`).
   - Route 53 provides four name servers (NS records).
   - Add these name servers to your domain registrar’s DNS settings (e.g., GoDaddy, Namecheap).
   - Configure routing in the hosted zone with A records, CNAME records, and other necessary settings.

2. **Private Hosted Zone**:
   - Create a private hosted zone (`internal.example.com`) for applications running inside a VPC.
   - This hosted zone is accessible only within the specified VPC and is not visible to the public.
   - For example, you can make a database server accessible with a DNS name like `db.internal.example.com`.

### Advantages of Hosted Zones

- **Easy Management**: Allows centralized management of DNS records.
- **AWS Integration**: Offers seamless integration with AWS services (e.g., S3, ELB, CloudFront) using Alias records.
- **Flexibility**: Provides solutions for both public and private environments with public and private hosted zones.
- **High Performance and Reliability**: Delivers fast and reliable DNS services through AWS’s global infrastructure.

A hosted zone is the cornerstone of DNS management in Route 53, organizing and managing all DNS configurations associated with a domain or subdomain.

In Amazon Route 53, **TTL (Time to Live)** is a setting that determines how long a DNS record will be cached. TTL controls how frequently DNS records are refreshed and is measured in seconds.  

### How Does TTL Work?

- When a user queries a domain name, the query is often answered by the Internet Service Provider's (ISP) or a DNS cache's server.
- This server caches the query response and retains it for a specific period determined by the TTL value.
- Once the TTL expires, the DNS records are queried again and refreshed.

### Advantages and Disadvantages of TTL

#### High TTL (Long Duration):
- **Advantages**:
  - Fewer DNS queries, reducing network traffic and costs.
  - Faster DNS query responses as the information is retrieved from the cache.
- **Disadvantages**:
  - Changes to records (e.g., IP address changes) take longer to propagate. Users may continue using outdated records.

#### Low TTL (Short Duration):
- **Advantages**:
  - DNS records update faster, allowing quick propagation of IP address changes.
- **Disadvantages**:
  - More DNS queries, increasing network traffic and costs.
  - Response times might be slightly longer without caching.

### Applying TTL in Route 53

In Route 53, TTL is configured individually for each DNS record. For example:

- **A Record**: When creating an A record for `example.com`, you can set the TTL value to `60` seconds, meaning the IP address will be cached for 1 minute.
- **CNAME Record**: For a CNAME record like `www.example.com` -> `example.com`, you can set the TTL value to `300` seconds (5 minutes).

### TTL for Alias Records

In Route 53, Alias records do not have a manually configurable TTL. Instead, Alias records automatically inherit the TTL value of the associated AWS service (e.g., Amazon S3 or Elastic Load Balancer).

### TTL Examples

1. **When Migrating a Web Server**:
   - Before migrating a web server, it is helpful to temporarily lower the TTL (e.g., to 60 seconds). This ensures that IP address changes propagate quickly during the migration.

2. **For Static IP Addresses**:
   - For a static IP address, setting a long TTL (e.g., 86400 seconds, equivalent to 24 hours) can improve performance and reduce query costs.

### Managing TTL Settings

When creating or editing a DNS record in Route 53, the TTL value can be easily configured. Selecting the right TTL value ensures a balanced approach between system performance and the speed of record updates.

The key difference between **Route 53 CNAME Records** and **Route 53 Alias Records** lies in their functionality, use cases, and integration with AWS services. Here's a detailed comparison:

---

### **1. Basic Definition**

| **Feature**        | **CNAME Record**                              | **Alias Record**                                   |
|---------------------|-----------------------------------------------|--------------------------------------------------|
| **Purpose**         | Maps a domain name (alias) to another domain name (canonical name). | Directly points a domain or subdomain to an AWS resource or another DNS name. |
| **Integration**     | Works with any DNS provider; not AWS-specific. | Specifically designed for AWS services (S3, ELB, CloudFront, etc.). |

---

### **2. Supported Usage**

| **Feature**                  | **CNAME Record**                     | **Alias Record**                                |
|------------------------------|---------------------------------------|------------------------------------------------|
| **Root Domain (e.g., example.com)** | **Not supported**: Cannot use CNAME at the root of a domain due to DNS standards. | **Supported**: Alias records can point the root domain to AWS resources. |
| **Subdomains (e.g., www.example.com)** | Supported for mapping subdomains to another domain or resource. | Supported and preferred when pointing to AWS services. |
| **Non-AWS Resources**         | Can point to non-AWS domain names like `example.net`. | Cannot point to non-AWS resources. |

---

### **3. Performance and Costs**

| **Feature**                  | **CNAME Record**                     | **Alias Record**                                |
|------------------------------|---------------------------------------|------------------------------------------------|
| **Query Costs**              | Standard DNS query costs apply.       | No additional query cost when pointing to AWS services (free queries). |
| **Latency**                  | Resolves the canonical name first, adding a small delay. | Directly resolves to the AWS service, improving performance. |

---

### **4. AWS-Specific Features**

| **Feature**                  | **CNAME Record**                     | **Alias Record**                                |
|------------------------------|---------------------------------------|------------------------------------------------|
| **AWS Services Integration** | Limited; cannot directly point to services like S3, ELB, or CloudFront. | Fully integrates with AWS services such as S3 buckets, Elastic Load Balancers, and CloudFront distributions. |
| **Health Checks**            | Cannot associate health checks with a CNAME record. | Can integrate with Route 53 health checks to monitor and route traffic dynamically. |

---

### **5. Examples**

#### **CNAME Record Example**  
You want to redirect `www.example.com` to `example.com` or a third-party service:

```
Name: www.example.com  
Type: CNAME  
Value: example.com  
TTL: 300
```

#### **Alias Record Example**  
You want to point the root domain (`example.com`) to an AWS CloudFront distribution:

```
Name: example.com  
Type: Alias  
Value: d1234567890abcdef.cloudfront.net  
Target: AWS CloudFront Distribution  
```

---

### **When to Use Each**

| **Scenario**                                | **Recommended Record**    |
|---------------------------------------------|---------------------------|
| Pointing a subdomain to another domain       | **CNAME**                 |
| Redirecting the root domain to an AWS service | **Alias**                 |
| Integrating with AWS services like S3, ELB, or CloudFront | **Alias** |
| Using a domain with third-party DNS records | **CNAME**                 |

---

### **Key Takeaways**

1. **CNAME records** are more general and work with any domain-to-domain mapping, but they cannot be used at the root domain.
2. **Alias records** are specific to AWS and are optimized for performance, cost, and AWS service integration. They are also the only option for pointing a root domain to an AWS resource.

For AWS services and root domains, **Alias Records** are the preferred choice. For other use cases involving non-AWS domains or third-party services, **CNAME Records** are better suited.


In Amazon Route 53, **Alias Targets** refer to the specific AWS resources or endpoints to which an **Alias Record** can point. Alias Records allow Route 53 to seamlessly integrate with AWS services, enabling you to route traffic to these resources efficiently.

### **Supported Alias Targets in Route 53**

Route 53 Alias Records can point to the following AWS resources:

---

### **1. Elastic Load Balancers (ELBs)**
- **Purpose**: Direct traffic to an Application Load Balancer (ALB), Network Load Balancer (NLB), or Gateway Load Balancer (GWLB).
- **Use Case**: Route incoming traffic for a domain or subdomain (e.g., `www.example.com`) to an ELB.
- **Alias Example**:
  ```
  Name: www.example.com
  Type: Alias
  Target: my-alb-1234567890.us-east-1.elb.amazonaws.com
  ```

---

### **2. Amazon S3 Buckets Configured as Static Websites**
- **Purpose**: Point a domain or subdomain to an S3 bucket hosting a static website.
- **Use Case**: Route traffic for a root domain (e.g., `example.com`) or subdomain to the S3 website endpoint.
- **Alias Example**:
  ```
  Name: example.com
  Type: Alias
  Target: s3-website-us-east-1.amazonaws.com
  ```

---

### **3. Amazon CloudFront Distributions**
- **Purpose**: Point traffic to a CloudFront distribution for content delivery.
- **Use Case**: Route traffic for a domain (e.g., `cdn.example.com`) to a CloudFront distribution for improved latency and caching.
- **Alias Example**:
  ```
  Name: cdn.example.com
  Type: Alias
  Target: d123456abcdefg.cloudfront.net
  ```

---

### **4. Amazon API Gateway Custom Regional APIs**
- **Purpose**: Point traffic to an API Gateway endpoint for APIs hosted in AWS.
- **Use Case**: Route traffic for a domain (e.g., `api.example.com`) to a custom API Gateway regional endpoint.
- **Alias Example**:
  ```
  Name: api.example.com
  Type: Alias
  Target: abc123.execute-api.us-east-1.amazonaws.com
  ```

---

### **5. AWS Global Accelerator**
- **Purpose**: Direct traffic to a Global Accelerator endpoint for improved global performance and availability.
- **Use Case**: Route traffic for a domain to a Global Accelerator DNS name.
- **Alias Example**:
  ```
  Name: global.example.com
  Type: Alias
  Target: a1234567890.globalaccelerator.amazonaws.com
  ```

---

### **6. VPC Endpoint Services**
- **Purpose**: Point traffic to an AWS PrivateLink VPC endpoint service.
- **Use Case**: Route traffic from a custom domain to a VPC endpoint for private applications or services.
- **Alias Example**:
  ```
  Name: private.example.com
  Type: Alias
  Target: vpce-1234abcd.vpce.amazonaws.com
  ```

---

### **7. Another Route 53 Record in the Same Hosted Zone**
- **Purpose**: Create a chain of DNS records where an Alias Record points to another record (e.g., A or CNAME).
- **Use Case**: Simplify DNS management within a hosted zone.
- **Alias Example**:
  ```
  Name: shop.example.com
  Type: Alias
  Target: www.example.com
  ```

---

### **Advantages of Alias Targets**

- **Root Domain Support**: Alias Records can be used with root domains (e.g., `example.com`), unlike CNAME records.
- **No Extra Cost**: Queries to Alias Targets for AWS services are free.
- **AWS Integration**: Alias Targets are deeply integrated with AWS services, ensuring seamless routing and updates.
- **Health Checks**: Alias Targets can work with Route 53 health checks to improve fault tolerance.

---

### **When to Use Alias Targets**

- **For AWS Resources**: Always use Alias Records when pointing to AWS services like S3, ELB, or CloudFront.
- **For Root Domains**: Alias Records are essential when routing root domains to any endpoint, as CNAME records cannot be used at the root.

Alias Targets in Route 53 simplify routing traffic to AWS resources, providing a powerful tool for managing DNS with optimal performance and cost-effectiveness.

Amazon Route 53 offers **routing policies** to control how DNS queries are answered, allowing you to direct traffic based on various rules and configurations. Here's an overview of the different **Route 53 routing policies**:

---

### **1. Simple Routing Policy**
- **Purpose**: Directs traffic to a single resource without any advanced logic.
- **How It Works**:
  - Responds to DNS queries with a single record (e.g., an IP address or a domain name).
  - Cannot have multiple records with the same name.
- **Use Case**: A static website hosted on a single server or a single AWS resource.
- **Example**:
  - `example.com` -> `192.0.2.1` (an EC2 instance).

---

### **2. Weighted Routing Policy**
- **Purpose**: Distributes traffic across multiple resources based on assigned weights.
- **How It Works**:
  - Each record is given a weight (e.g., 70 and 30).
  - Higher weight means more traffic is routed to that resource.
- **Use Case**: Gradually migrating traffic from one server to another or load testing.
- **Example**:
  - `example.com` -> 70% to `192.0.2.1`, 30% to `192.0.2.2`.

---

### **3. Latency Routing Policy**
- **Purpose**: Routes traffic to the resource with the lowest latency to the user.
- **How It Works**:
  - Route 53 determines latency based on the user’s location and the region where the resources are hosted.
  - Ideal for applications requiring low-latency responses.
- **Use Case**: Multi-region deployments of web applications or APIs.
- **Example**:
  - Users in the US are routed to an EC2 instance in the **us-east-1** region, while users in Europe are routed to an EC2 instance in the **eu-west-1** region.

---

### **4. Geolocation Routing Policy**
- **Purpose**: Routes traffic based on the geographic location of the user making the DNS query.
- **How It Works**:
  - Route 53 directs users to resources closest to their geographic region.
  - If a match isn’t found, a default resource can be configured.
- **Use Case**: Region-specific content delivery or compliance with local regulations.
- **Example**:
  - Users in Japan are routed to a Tokyo server, and users in the US are routed to a California server.

---

### **5. Geoproximity Routing Policy (with Traffic Flow)**
- **Purpose**: Routes traffic based on the geographic location of the user and resource, with the ability to shift traffic by bias.
- **How It Works**:
  - Resources are defined by geographic regions, and you can adjust bias to increase or decrease traffic to a specific resource.
  - Requires Route 53 Traffic Flow.
- **Use Case**: Gradually shifting traffic between regions during a migration.
- **Example**:
  - Users near Asia-Pacific regions are directed to a Singapore server, with a bias applied to favor or exclude certain regions.

---

### **6. Failover Routing Policy**
- **Purpose**: Provides high availability by routing traffic to a primary resource, with automatic failover to a secondary resource if the primary is unhealthy.
- **How It Works**:
  - Requires health checks to monitor the primary resource.
  - If the primary fails, traffic is routed to the secondary resource.
- **Use Case**: High availability setups for critical services.
- **Example**:
  - `example.com` -> Primary: `192.0.2.1`, Secondary: `192.0.2.2`.

---

### **7. Multivalue Answer Routing Policy**
- **Purpose**: Returns multiple IP addresses in response to a single DNS query, with health checks to ensure only healthy resources are included.
- **How It Works**:
  - Route 53 includes up to 8 healthy resources in the response.
  - Allows clients to choose which IP address to use.
- **Use Case**: Load balancing across multiple servers without an ELB.
- **Example**:
  - `example.com` -> `192.0.2.1`, `192.0.2.2`, `192.0.2.3`.

---

### **Comparison Table**

| **Routing Policy**       | **Best For**                                                                 | **Key Feature**                                                    |
|--------------------------|-----------------------------------------------------------------------------|--------------------------------------------------------------------|
| Simple                   | Single resource or straightforward setups                                  | Basic, no advanced logic.                                          |
| Weighted                 | Traffic distribution or load testing                                       | Proportional traffic control.                                      |
| Latency                  | Applications requiring low-latency responses                              | Routes based on proximity and latency.                            |
| Geolocation              | Region-specific traffic delivery                                           | Routes by user location.                                           |
| Geoproximity             | Regional traffic management with bias                                     | Advanced geographic control with Traffic Flow.                    |
| Failover                 | High availability and disaster recovery setups                            | Automatically switches to a backup resource when the primary fails.|
| Multivalue Answer        | Load balancing without ELB or other tools                                 | Returns multiple healthy IPs.                                      |

---

### **Choosing the Right Routing Policy**
- **High Availability**: Use **Failover Routing**.
- **Load Testing or Migration**: Use **Weighted Routing**.
- **Multi-Region Low Latency**: Use **Latency Routing**.
- **Region-Specific Content**: Use **Geolocation Routing**.
- **Dynamic Regional Control**: Use **Geoproximity Routing**.
- **Basic or Simple Needs**: Use **Simple Routing**.
- **Multiple Servers Without ELB**: Use **Multivalue Answer Routing**. 

Each policy can be tailored to your specific DNS needs, ensuring optimal performance and reliability for your applications.


*/

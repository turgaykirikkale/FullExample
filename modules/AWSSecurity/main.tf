/*

Encryption on AWS is crucial for securing sensitive data and meeting compliance requirements. Here are the main reasons why encryption is essential:  

### **1. Data Security**  
- **Data at Rest:** Encrypting stored data ensures it remains secure, even if storage devices are compromised.  
- **Data in Transit:** Encryption protects data moving between services or clients, preventing interception.

### **2. Regulatory Compliance**  
- AWS encryption helps meet industry standards like GDPR, HIPAA, and PCI-DSS by securing personal and financial information.  

### **3. Access Control**  
- AWS integrates encryption with services like IAM and KMS, allowing granular control over who can access encrypted data.  

### **4. Data Integrity**  
- Encryption ensures data hasn't been tampered with by verifying its integrity when accessed or transferred.

### **5. Reduced Risk of Data Breaches**  
- In case of a breach, encrypted data is unreadable without proper decryption keys, minimizing data exposure.  

### **6. Built-in AWS Services**  
- AWS offers managed encryption services like AWS Key Management Service (KMS), S3 server-side encryption, and RDS encryption, simplifying implementation.



**Encryption in Flight** refers to encrypting data while it is being transmitted between two systems, such as from a client to a server or between AWS services. This prevents unauthorized interception or tampering during transit.  

### **How Encryption in Flight Works**  
1. **Data Transmission Protocols:** Secure protocols like HTTPS, TLS (Transport Layer Security), and SSL (Secure Sockets Layer) are commonly used.  
2. **Certificate Management:** Digital certificates ensure that communication is authenticated and encrypted.  
3. **Key Exchange:** Cryptographic keys are exchanged securely to establish a trusted connection.  

### **AWS Services Supporting Encryption in Flight**  
- **Amazon S3:** Supports HTTPS for secure uploads and downloads.  
- **Amazon RDS:** Encrypts data during transfer with SSL/TLS.  
- **Amazon EC2:** Can use secure protocols like SSH for remote access.  
- **AWS API Gateway & Lambda:** Encrypt requests and responses using HTTPS.  

### **Why Use Encryption in Flight?**  
- **Prevent Data Interception:** Protects sensitive data from being read by attackers during transfer.  
- **Ensure Data Integrity:** Guarantees that transmitted data is not altered.  
- **Comply with Regulations:** Helps meet compliance standards requiring secure data transfer.  


### **Server-Side Encryption (SSE)**  

**Server-side encryption (SSE)** is the process where AWS automatically encrypts data at rest after it is uploaded to a service. AWS manages the encryption, decryption, and key management, ensuring secure storage without requiring client-side implementation.  

---

### **Types of Server-Side Encryption on AWS**  

1. **SSE-S3 (Managed by S3)**  
   - **Encryption Type:** AES-256  
   - **Key Management:** Fully managed by AWS S3.  
   - **Use Case:** Standard encryption for data stored in S3.  
   - **How to Enable:**  
     - S3 Console > Bucket > Properties > Default Encryption > Enable AES-256  

   - **Terraform Example:**  
     ```hcl
     resource "aws_s3_bucket" "my_bucket" {
       bucket = "my-example-bucket"

       server_side_encryption_configuration {
         rule {
           apply_server_side_encryption_by_default {
             sse_algorithm = "AES256"
           }
         }
       }
     }
     ```

---

2. **SSE-KMS (Managed by AWS Key Management Service)**  
   - **Encryption Type:** AES-256 with AWS KMS integration  
   - **Key Management:** Managed via AWS KMS.  
   - **Use Case:** For greater control and auditability.  
   - **How to Enable:**  
     - S3 Console > Bucket > Properties > Default Encryption > Enable SSE-KMS  
     - Select a KMS key (default or custom).  

   - **Terraform Example:**  
     ```hcl
     resource "aws_s3_bucket" "my_bucket" {
       bucket = "my-example-bucket"
     }

     resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_sse" {
       bucket = aws_s3_bucket.my_bucket.id

       rule {
         apply_server_side_encryption_by_default {
           sse_algorithm   = "aws:kms"
           kms_master_key_id = aws_kms_key.my_key.arn
         }
       }
     }

     resource "aws_kms_key" "my_key" {
       description = "My KMS key for S3"
     }
     ```

---

3. **SSE-C (Customer-Provided Keys)**  
   - **Encryption Type:** Custom encryption key provided by the user.  
   - **Key Management:** Managed by the customer.  
   - **Use Case:** When you need full control over encryption keys.  
   - **How to Use:**  
     - Upload data using SDK/CLI with a custom encryption key.  

---

### **Why Use Server-Side Encryption?**  

- **Data Security:** Automatically protects data at rest.  
- **Compliance:** Meets regulatory standards like PCI-DSS, HIPAA, and GDPR.  
- **Ease of Use:** Minimal configuration and built-in AWS key management.  
- **Integration:** Works seamlessly with services like S3, RDS, DynamoDB, and EBS.  


*/

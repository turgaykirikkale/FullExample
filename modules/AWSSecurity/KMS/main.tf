/*

AWS KMS (Key Management Service) is a service that allows you to securely create, manage, and use encryption keys in AWS. KMS enables you to manage cryptographic keys for protecting your data and allows you to control which users can read or write data encrypted with those keys.

KMS offers the following functionalities:
- **Key Creation and Management**: You can create and manage cryptographic keys, including both symmetric (e.g., AES) and asymmetric (e.g., RSA) keys.
- **Encryption and Decryption**: It can encrypt and decrypt data, ensuring secure storage of your data.
- **Key Access Control**: KMS allows you to define access control policies on the keys, enabling specific users or services to use the keys.
- **Monitoring and Auditing**: With AWS CloudTrail integration, you can track and audit all actions performed with KMS.

AWS KMS (Key Management Service) supports two main types of encryption keys:

1. **Symmetric Keys**:
   - These keys use the same key for both encryption and decryption.
   - AWS KMS primarily uses symmetric keys for most cryptographic operations, such as encrypting data at rest or securing communication between services.
   - **Default Behavior**: Symmetric keys are the default key type when you create a key in KMS.
   - **Use Cases**: Data encryption, Amazon S3 encryption, Amazon EBS volume encryption, etc.
   - **Key Size**: Typically uses AES-256 encryption.

2. **Asymmetric Keys**:
   - These keys use a pair of keys: a public key for encryption and a private key for decryption.
   - AWS KMS supports asymmetric key pairs that can be used with algorithms such as RSA or Elliptic Curve (ECC).
   - **Use Cases**: Digital signatures, key exchange protocols, and encryption/decryption operations that require public/private key pairs.
   - **Supported Algorithms**: 
     - RSA (e.g., RSA_2048, RSA_3072, RSA_4096)
     - ECC (e.g., ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521)

### Key Usage:
- **Symmetric keys** are generally used for encrypting and decrypting data directly.
- **Asymmetric keys** are typically used for signing data (such as in digital signatures) or encrypting data with the public key, where only the holder of the private key can decrypt it.


AWS KMS (Key Management Service) supports **multi-region keys**, which allow you to create and manage encryption keys that can be used across different AWS regions. These keys are designed to simplify key management and encryption in multi-region architectures, ensuring that you can use the same encryption key in multiple regions without needing to create and manage separate keys for each region.

### Key Features of Multi-Region Keys:

1. **Same Key Across Regions**:
   - A **multi-region key** allows you to create a key in one region and replicate it in other regions, making the same encryption key available in multiple regions for consistent encryption and decryption.
   - The multi-region key has a global key identifier (Key ID), and the key material (the actual cryptographic material used for encryption) is replicated across regions.

2. **Replication of Key Material**:
   - The actual cryptographic key material is **replicated** across the regions you specify when creating the multi-region key. This means that once you create a key in a primary region, you can replicate it to other regions as needed.

3. **Simplified Key Management**:
   - You do not need to manage separate keys in each region. With multi-region keys, you can perform encryption and decryption operations in multiple regions using the same key, reducing complexity in managing encryption for cross-region applications.

4. **Same Key ID**:
   - The key retains the same key ID across all the regions where it is replicated. This simplifies operations, such as creating encrypted resources, since you can refer to the same key across multiple regions.
   
5. **Cross-Region Access**:
   - The key can be used in one region for encryption and in another region for decryption, making it useful for multi-region architectures such as disaster recovery, replication, and multi-region applications.

### Steps to Create and Use Multi-Region Keys:

1. **Create the Key in the Primary Region**:
   - First, create a customer-managed key in the primary region (the region where you initially want to create the key). This key will be the **origin key**.

   Example command:
   ```bash
   aws kms create-key --region <primary-region> --description "My Multi-Region Key"
   ```

2. **Enable Multi-Region Replication**:
   - To enable multi-region functionality, use the **AWS KMS `replicate-key`** feature to replicate the key to additional regions.
   
   Example of replicating the key to another region:
   ```bash
   aws kms replicate-key --source-key-id <source-key-id> --destination-region <destination-region>
   ```

3. **Use the Key Across Regions**:
   - Once the key is replicated, you can use the same key ID in the other regions for encryption or decryption.
   - When performing encryption operations in a different region, you can refer to the multi-region key by its ID, just like in the primary region.

4. **Manage Permissions**:
   - Ensure that the appropriate **IAM policies** are in place to allow access to the multi-region key in all regions. You will need to grant permissions for users and services to use the key in any region where it's replicated.

5. **Key Rotation**:
   - You can configure **automatic key rotation** for multi-region keys. When key rotation occurs in one region, the same key material is rotated across all regions.

### Example Use Cases for Multi-Region Keys:
- **Cross-Region Encryption**: If your application stores encrypted data in multiple regions (e.g., for redundancy or disaster recovery), you can use the same multi-region key to encrypt data in one region and decrypt it in another.
- **Replication**: When replicating Amazon S3 buckets or RDS databases across regions, you can use the same encryption key for data protection across regions.
- **Compliance**: For organizations that need to comply with regulations requiring encryption, multi-region keys help maintain consistent encryption policies across different geographic locations.

### Important Considerations:
- **Key Availability**: Multi-region keys are only available for customer-managed keys and not for AWS-managed keys (e.g., `aws/aws-key`).
- **Region-Specific Constraints**: Some AWS services or features may still have region-specific limitations, even if you are using multi-region keys.
- **Cost**: Multi-region keys incur costs related to key management, key replication, and encryption operations in each region where the key is used.

In summary, AWS KMS multi-region keys are a powerful feature for organizations that require consistent encryption across multiple regions, making it easier to manage and secure data in distributed applications.

### DynamoDB Global Tables and KMS Multi-Region Keys with Client-Side Encryption

When using **DynamoDB Global Tables** in combination with **AWS KMS multi-region keys** and **client-side encryption**, you're enabling encryption and replication of your data across multiple AWS regions, while also ensuring that the data is securely encrypted before it even reaches DynamoDB. This approach is ideal for highly available and globally distributed applications with additional security requirements.

### Overview:
- **DynamoDB Global Tables** allow you to replicate your DynamoDB tables across multiple AWS regions automatically. This provides low-latency read and write operations in each region and ensures your data is available even if a region goes down.
- **KMS Multi-Region Keys** are used to manage the encryption of data in a consistent and secure manner across multiple AWS regions.
- **Client-Side Encryption** ensures that data is encrypted on the client side before it is sent to DynamoDB, making sure the data is encrypted from the moment it leaves your application to when it's stored in DynamoDB.

### Key Concepts and Steps:

1. **DynamoDB Global Tables**:
   - **Global Tables** automatically replicate changes made to your DynamoDB table in one region to other regions, making them globally distributed.
   - The replication is performed asynchronously and ensures eventual consistency across regions.
   - You can set up Global Tables with any number of AWS regions.

2. **KMS Multi-Region Keys**:
   - You can create a **multi-region key** in AWS KMS that can be used across multiple regions for the encryption of data.
   - The same KMS key can be used in all the regions where your DynamoDB Global Tables are replicated, ensuring consistency in encryption.
   - **Encryption at rest** for DynamoDB can be enabled with KMS-managed keys, but **client-side encryption** ensures the data is encrypted before reaching DynamoDB and is decrypted only on the client-side.

3. **Client-Side Encryption**:
   - With client-side encryption, your application encrypts the data before it is sent to DynamoDB, and only the application with the correct KMS key can decrypt it.
   - This is a great way to ensure that even if someone has access to the DynamoDB tables, they cannot read the encrypted data without access to the decryption keys.
   - This is especially important for **data privacy** and **compliance** with regulations such as GDPR, HIPAA, and others.

### Implementing Client-Side Encryption with DynamoDB Global Tables and KMS Multi-Region Keys

#### 1. **Create DynamoDB Global Tables**:
   - Start by creating a DynamoDB table and configure it as a **Global Table** across multiple regions.
   - In the DynamoDB console or using the AWS SDK, choose multiple AWS regions and link them to the same table to enable cross-region replication.

   Example AWS CLI command to create a Global Table:
   ```bash
   aws dynamodb create-table \
     --table-name MyGlobalTable \
     --attribute-definitions \
         AttributeName=UserId,AttributeType=S \
     --key-schema \
         AttributeName=UserId,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
     --replica-update \
         RegionName=us-west-2,RegionName=eu-central-1
   ```

#### 2. **Create a Multi-Region KMS Key**:
   - Create a multi-region key in AWS KMS in your primary region (where your DynamoDB Global Table will initially be created).
   - Replicate the KMS key to other regions where your DynamoDB Global Tables are configured.

   Example CLI command to create a KMS key:
   ```bash
   aws kms create-key --region us-west-2 --description "Multi-region encryption key"
   ```

   To replicate the key to another region:
   ```bash
   aws kms replicate-key --source-key-id <source-key-id> --destination-region eu-central-1
   ```

#### 3. **Enable Client-Side Encryption**:
   - To enable **client-side encryption**, you can use the AWS SDK, such as the **AWS SDK for JavaScript** or **AWS SDK for Python (Boto3)**, which supports client-side encryption by encrypting data before it is sent to DynamoDB.
   - The AWS SDK provides the `AWS.DynamoDB.DocumentClient` with built-in encryption capabilities. You can configure it to use your KMS key for client-side encryption.

   Example using AWS SDK for JavaScript:
   ```javascript
   const AWS = require('aws-sdk');
   const dynamoDB = new AWS.DynamoDB.DocumentClient();
   const kms = new AWS.KMS();

   // Set up encryption options with the multi-region KMS key
   const encryptParams = {
     KeyId: '<kms-key-id>',  // The multi-region KMS key ID
     Plaintext: 'Sensitive Data'
   };

   // Encrypt data before sending to DynamoDB
   kms.encrypt(encryptParams, function(err, data) {
     if (err) console.log(err, err.stack);
     else {
       // Store encrypted data in DynamoDB
       const params = {
         TableName: 'MyGlobalTable',
         Item: {
           UserId: '12345',
           Data: data.CiphertextBlob
         }
       };

       dynamoDB.put(params, function(err, data) {
         if (err) console.log(err, err.stack);
         else console.log('Data encrypted and saved:', data);
       });
     }
   });
   ```

#### 4. **Data Replication and Security**:
   - Once the data is encrypted client-side and stored in DynamoDB, it will be replicated across all the regions where your Global Tables are configured.
   - The encryption key used for client-side encryption is managed by KMS, and since you’re using multi-region keys, the same encryption key can be used in all regions where your DynamoDB Global Table is available.
   - **Security**: The data is protected throughout its lifecycle—during transmission (via HTTPS), at rest (via DynamoDB’s encryption with KMS), and before it even reaches DynamoDB (via client-side encryption).

#### 5. **Decryption**:
   - When reading data from DynamoDB, your application will retrieve the encrypted data and decrypt it using the appropriate KMS key.

   Example of decrypting the data after retrieving it from DynamoDB:
   ```javascript
   const decryptParams = {
     CiphertextBlob: encryptedData
   };

   kms.decrypt(decryptParams, function(err, data) {
     if (err) console.log(err, err.stack);
     else {
       const decryptedData = data.Plaintext.toString();
       console.log('Decrypted Data:', decryptedData);
     }
   });
   ```

### Benefits of This Setup:
- **Data Encryption**: The data is encrypted before reaching DynamoDB, and it is stored encrypted in DynamoDB, ensuring strong data security.
- **Global Availability**: DynamoDB Global Tables provide high availability with data replication across regions. The use of KMS multi-region keys ensures consistent encryption across these regions.
- **Compliance**: Client-side encryption helps meet compliance standards by ensuring that data is encrypted from the client’s side and only decrypted by authorized parties.

### Important Considerations:
- **Encryption Key Management**: Ensure that the KMS key used for encryption is properly managed and that all regions have access to the key. Pay attention to key policies, access control, and rotation.
- **Latency**: Multi-region tables introduce some latency due to the cross-region replication of data.
- **Cost**: There may be additional costs for using DynamoDB Global Tables and KMS key replication.


When setting up **Amazon S3 Cross-Region Replication (CRR)** or **Same-Region Replication (SRR)**, **encryption** plays a critical role in ensuring that data remains secure during transfer, storage, and replication. Here are key considerations for **S3 Replication Encryption**:

### 1. **Source and Destination Bucket Encryption**
   - When replicating objects between S3 buckets (whether in the same region or across regions), both the source and destination buckets can use encryption to protect the data.
   - **Encryption** can be handled by:
     - **S3-managed keys (SSE-S3)**: S3 automatically manages the keys for encryption.
     - **AWS Key Management Service (KMS)**: Use **SSE-KMS** for more control over encryption keys, such as setting up access policies for the keys.
     - **Customer-Provided Keys (SSE-C)**: You manage the keys. S3 will use them for encryption, but you must provide the key with each request.

### 2. **Encryption during Replication**
   - **Replication with encryption** ensures that data is encrypted during transit and at rest in the destination bucket.
   
   - **S3 Replication Encryption Requirements**:
     - If **SSE-S3** is used in the source bucket, the destination bucket can either use **SSE-S3** or **SSE-KMS** encryption.
     - If **SSE-KMS** is used in the source bucket, the destination bucket must either use the **same KMS key** or a **different KMS key**. You can specify whether the destination objects should use the same key or a new key when setting up replication.
     - **KMS Key Permissions**: For **SSE-KMS** encryption, ensure the IAM role used for replication has permissions to use the KMS key in the destination bucket. This requires the correct **key policy** and **IAM policies**.
     - If **SSE-C** is used, replication cannot occur unless the **customer-provided key (SSE-C)** is also provided in the destination region, which may require manually managing the keys.

### 3. **Replicating Encrypted Objects**
   - By default, **S3 Replication** replicates encrypted objects as-is to the destination bucket, meaning the encryption status (SSE-S3, SSE-KMS) is maintained.
   - **Replicate Encrypted Data**: If the source object is encrypted with **SSE-S3** or **SSE-KMS**, the destination object will be replicated with the same encryption method, unless explicitly configured to use a different encryption setting.
   - **Changing Encryption during Replication**: If you want the destination to use different encryption (e.g., change from SSE-S3 to SSE-KMS), you must specify the encryption settings in the replication configuration.
   
   Example of specifying **SSE-KMS** in the destination bucket in replication:
   ```json
   {
     "Role": "arn:aws:iam::account-id:role/replication-role",
     "Rules": [
       {
         "ID": "replicate-all-objects",
         "Status": "Enabled",
         "Filter": {},
         "Destination": {
           "Bucket": "arn:aws:s3:::destination-bucket",
           "Encryption": {
             "SSEKMS": {
               "KeyId": "arn:aws:kms:region:account-id:key/key-id"
             }
           }
         }
       }
     ]
   }
   ```

### 4. **S3 Replication Time Control (RTC) with Encryption**
   - **S3 Replication Time Control (RTC)** ensures that objects are replicated in under 15 minutes. For **RTC** to be used with **SSE-KMS** encryption, the **KMS key** used for encryption in the source and destination buckets must support **replication time control**. 
   - Ensure that **KMS key policies** are configured to allow the replication process to complete within the designated time.

### 5. **Encryption Settings in the Replication Configuration**
   - When setting up **replication**, you specify the **encryption** for the destination bucket in the replication configuration.
     - **SSE-S3**: S3 will use a default encryption key.
     - **SSE-KMS**: You can specify a particular **KMS key** (either the same or a new one). Make sure the IAM role has permission to use the KMS key in the destination bucket.
   - If **SSE-S3** is used in the source bucket, replication can use either **SSE-S3** or **SSE-KMS** in the destination bucket. If **SSE-KMS** is used, ensure the **KMS key** allows the replication process.

### 6. **Access Control and Permissions**
   - To use **SSE-KMS** for replication, the **IAM role** performing the replication must have the following permissions:
     - **kms:Encrypt**, **kms:Decrypt**: Permissions to encrypt and decrypt data with the KMS key.
     - **kms:GenerateDataKey**: Required to generate data keys for encryption operations.
     - Ensure that both the **source** and **destination bucket policies** and **IAM roles** are properly configured with the required permissions.

### 7. **Audit and Monitoring Encryption**
   - Use **AWS CloudTrail** to monitor **S3 replication events** and verify that the data is encrypted correctly during replication.
   - Ensure that the **replication status** and **error logs** are checked, especially if there are issues with encryption or KMS key access.

### 8. **Impact of Encryption on Replication**
   - **SSE-S3**: Simpler to set up, with no management of encryption keys. It is the default encryption for S3.
   - **SSE-KMS**: Offers more granular control, such as key management, access control policies, and auditing. However, it introduces additional complexity and management overhead, particularly for cross-account or cross-region replication.
   - When you use **SSE-KMS**, be mindful of **KMS quota limits**, which might impact large-scale replication if you're replicating a high volume of data.

### Best Practices for S3 Replication Encryption:
- **KMS Key Policy Management**: Ensure the correct KMS key policies are in place to allow cross-region or cross-account replication with **SSE-KMS**.
- **Consistent Encryption**: Ensure that you use consistent encryption across source and destination buckets to avoid unexpected behavior. If encryption changes are needed, configure them explicitly in the replication settings.
- **Versioning**: Enable **versioning** in both source and destination buckets, as replication only happens for versioned objects.
- **Replication Monitoring**: Use **CloudTrail** and **Amazon S3 metrics** to monitor the encryption and status of the replication process.



*/
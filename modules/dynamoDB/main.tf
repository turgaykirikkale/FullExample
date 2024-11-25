
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}


/*
### **What is AWS DynamoDB?**

AWS DynamoDB is a **fully managed NoSQL database service** provided by Amazon Web Services (AWS). It is designed for applications requiring high performance, scalability, and flexibility. DynamoDB is ideal for storing unstructured or semi-structured data and is often preferred for applications needing low-latency access and high data throughput. Here are its key features:

---

### **Key Features**

1. **NoSQL Structure**:  
   DynamoDB uses a table-based structure but does not require strict schema definitions like relational databases. Data can be stored in **key-value pairs** or **document format**.

2. **Fully Managed Service**:  
   AWS automatically handles tasks such as server management, scaling, and backups, allowing developers to focus solely on their applications.

3. **High Scalability**:  
   DynamoDB can automatically scale its read/write capacity. Its **auto-scaling** feature dynamically adjusts performance based on usage needs.

4. **Fast and Low-Latency Performance**:  
   DynamoDB provides sub-millisecond response times, enabling quick data access ideal for real-time applications.

5. **Built-In Backup and Recovery**:  
   The **Point-in-Time Recovery (PITR)** feature allows users to recover data to a specific time in case of accidental data loss.

6. **Global Distribution and Replication**:  
   With **DynamoDB Global Tables**, the database can be automatically replicated across multiple AWS regions worldwide, ensuring low-latency global access.

7. **Event-Driven Architecture Support**:  
   With AWS Lambda integration, database changes can act as triggers for event-driven workflows.

8. **Security and Access Control**:  
   AWS IAM provides fine-grained access control. With data encryption (both in transit and at rest), DynamoDB ensures high-security standards.

---

### **Use Cases for DynamoDB**

- **Real-Time Database Requirements**: For example, gaming leaderboards or real-time chat applications.
- **IoT and Mobile Applications**: Applications that require low latency and high transaction capacity.
- **E-commerce Systems**: Managing inventory, shopping cart data, and user session storage.
- **Log and Telemetry Storage**: Processing and storing large amounts of log and analytics data.
- **Globally Distributed Applications**: Applications that require high performance across multiple geographic regions.

---

### **Advantages**

1. High performance and low latency.  
2. Flexible and schema-less structure.  
3. No server management required.  
4. Advanced security and backup features.  
5. Tight integration with the AWS ecosystem.

---

### **Disadvantages**

1. Does not support relational database features (e.g., complex queries and joins).  
2. Costs can increase if read and write capacities are not configured correctly.  
3. Limited support for ACID transactions.

DynamoDB is a powerful option for **modern applications requiring high scalability**, especially those with demanding performance requirements. 
Its seamless integration with other AWS services allows users to save significant time and resources.


### **AWS DynamoDB Basics**

Amazon DynamoDB is a **NoSQL database service** that provides fast, predictable performance and seamless scalability. It’s fully managed, so developers don’t need to worry about infrastructure, making it ideal for applications requiring high throughput and low latency.

Here are the key foundational concepts to understand DynamoDB:

---

### **1. Core Components**

#### **Tables**:  
- Data in DynamoDB is organized into **tables**.  
- Each table has a unique name within an AWS account and region.

#### **Items**:  
- A table is composed of multiple **items** (similar to rows in relational databases).  
- Each item is uniquely identifiable by a **primary key**.

#### **Attributes**:  
- Attributes are the data elements within an item (similar to columns in relational databases).  
- Each attribute can store different types of data (strings, numbers, binary, sets, etc.).

---

### **2. Primary Keys**

DynamoDB requires a primary key for each table, which uniquely identifies each item:

#### **Partition Key (Hash Key)**:  
- A single attribute used to determine where data is stored in the backend.  
- Example: `UserID`.

#### **Composite Key (Partition + Sort Key)**:  
- Combines two attributes: a partition key and a sort key.  
- Allows querying items that share the same partition key.  
- Example: `UserID` (partition key) + `OrderDate` (sort key).

---

### **3. Read/Write Operations**

#### **Provisioned Mode**:  
- You define the read and write capacity units (RCUs and WCUs) the table requires.  
- **RCU**: One strongly consistent read of up to 4 KB per second.  
- **WCU**: One write of up to 1 KB per second.

#### **On-Demand Mode**:  
- DynamoDB automatically handles capacity scaling based on your application's needs.  
- No upfront provisioning; you pay only for what you use.

---

### **4. Data Consistency**

DynamoDB provides two types of read operations:  
1. **Eventually Consistent Reads**: Default, where data may not reflect the most recent changes immediately.  
2. **Strongly Consistent Reads**: Ensures the most recent data is returned, but it costs more in terms of RCUs.

---

### **5. Query and Scan**

- **Query**: Retrieves items based on the primary key. Efficient and fast.
- **Scan**: Retrieves all items in a table. Slower and more resource-intensive.

---

### **6. Secondary Indexes**

Indexes allow querying data using attributes other than the primary key:

#### **Global Secondary Index (GSI)**:  
- Allows querying across any attribute.  
- Independent read/write capacity from the main table.

#### **Local Secondary Index (LSI)**:  
- Allows querying with the same partition key but a different sort key.  
- Shares the table’s read/write capacity.

---

### **7. Security and Access Control**

- Uses **IAM roles and policies** for access management.  
- Data encryption is supported both **at rest** and **in transit**.

---

### **8. DynamoDB Streams**

- Tracks changes to the data in real-time.  
- Useful for event-driven architectures, such as syncing data to another service or triggering AWS Lambda functions.

---

### **9. Pricing**

- Based on the chosen capacity mode (Provisioned or On-Demand).  
- Additional costs may include data storage, backup, and DynamoDB Streams.

---

### **Example Use Cases**

- **Real-Time Applications**: Chat apps, gaming leaderboards.  
- **E-Commerce**: Managing inventory, shopping carts, and order tracking.  
- **IoT**: High-throughput and low-latency data storage.  
- **Session Management**: Tracking user sessions or application states.

By mastering these basics, you'll have a solid foundation for designing and optimizing applications using DynamoDB.

**What is DynamoDB Accelerator (DAX)?**

**DynamoDB Accelerator (DAX)** is a fully managed, **in-memory caching service** for Amazon DynamoDB, designed to deliver **sub-millisecond latency** for data access. It is specifically optimized for applications with high read request volumes.

### **Key Features of DAX**
1. **In-Memory Caching:**
   - Stores data in memory, so repeated queries fetch data directly from DAX instead of DynamoDB.
   - Can improve read performance by up to **10x**.

2. **Fully Managed:**
   - Provided as a managed service by AWS, eliminating the need to manage infrastructure, maintenance, or updates.

3. **API Compatible:**
   - Fully compatible with the existing DynamoDB API, meaning you can integrate DAX into your application without major changes.

4. **Data Consistency:**
   - DAX supports **Eventually Consistent** reads but does not support **Strongly Consistent** reads.

5. **Transparent Integration:**
   - Simply add the DAX client to your application to start using it—no significant changes are required.

---

### **Benefits of DAX**
- **Performance:** Provides fast access to data with low latency, especially under heavy read workloads.
- **Cost Efficiency:** Reduces DynamoDB costs by serving repeated read requests from the cache.
- **High Scalability:** Automatically scales to handle increased traffic loads.
- **Easy Setup:** You can quickly create a DAX cluster using the AWS Management Console, CLI, or SDK.

---

### **Use Cases for DAX**
- **High Read Workloads:** For frequently accessed data such as user profiles or product catalogs.
- **Low Latency Requirements:** Ideal for real-time applications like gaming or financial services.
- **High Traffic Systems:** Especially those handling millions of read requests per second.

---

### **How Does DAX Work?**
DAX acts as a **cache layer** for read operations. When an application requests data:
1. **Cache Hit:** If the requested data is available in the cache, DAX directly responds.
2. **Cache Miss:** If the requested data is not in the cache, DAX fetches it from DynamoDB and stores the result in the cache for future use.

This approach reduces database access and latency, enhancing performance and lowering costs.


**DAX vs ElastiCache**  

**DynamoDB Accelerator (DAX)** and **Amazon ElastiCache** are both AWS caching solutions but are designed for different use cases and data storage requirements. Here’s a detailed comparison of the two services:  

---

### **1. Key Differences**  
| **Feature**              | **DAX**                                                                                           | **ElastiCache**                                                                                       |
|---------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| **Scope**                | A caching solution specifically designed for Amazon DynamoDB.                                     | A general-purpose caching solution based on Redis or Memcached, compatible with various databases and applications. |
| **Primary Use Case**      | Accelerates DynamoDB queries and provides low-latency access.                                     | Broad use cases such as application-wide caching, session management, and message queues.            |
| **API Support**           | Only compatible with DynamoDB API.                                                               | Supports Redis and Memcached protocols; integrates with many different applications.                 |
| **Consistency**           | Supports **Eventually Consistent** reads only.                                                   | Consistency depends on how Redis or Memcached is configured by the user.                             |
| **Data Storage**          | Caches data only for read operations. Writes go directly to DynamoDB.                            | Can be used as a caching layer for both read and write operations.                                   |  

---

### **2. Performance**  
- **DAX:**  
  - Specifically optimized for **DynamoDB**.  
  - Delivers sub-millisecond latency for frequently accessed data.  
  - Reduces direct queries to DynamoDB.  

- **ElastiCache:**  
  - Offers high-speed data processing and caching.  
  - Leverages Redis or Memcached for low-latency, high-throughput performance.  
  - Supports complex data structures (e.g., sets, sorted sets, lists).  

---

### **3. Management and Integration**  
- **DAX:**  
  - Exclusively for DynamoDB, making integration simple.  
  - Requires minimal code changes since it’s based on the existing DynamoDB API.  
  - Fully managed by AWS.  

- **ElastiCache:**  
  - More flexible due to support for Redis and Memcached.  
  - Can be used with multiple databases or applications.  
  - Users manage certain aspects of cluster configuration (e.g., Redis clustering).  

---

### **4. Use Cases**  
| **Service**  | **Use Case**                                                                                                   |
|--------------|---------------------------------------------------------------------------------------------------------------|
| **DAX**      | - Accelerating queries for DynamoDB.                                                                          |
|              | - E-commerce product catalogs, user profiles, or real-time database queries.                                   |
| **ElastiCache** | - Session management, game leaderboards, messaging queues.                                                    |
|              | - Complex data processing (e.g., working with Redis data structures like sorted sets or lists).                |
|              | - A general-purpose caching solution across multiple applications.                                             |  

---

### **5. Cost**  
- **DAX:** Designed to reduce DynamoDB query costs, typically lowering the cost per query.  
- **ElastiCache:** Flexible use cases; costs depend on cluster size and workload.  

---

### **When to Choose Which?**  
- **Choose DAX if:**  
  - You are already using **DynamoDB** and want to improve query performance.  
  - **Eventually Consistent** reads are suitable for your application.  

- **Choose ElastiCache if:**  
  - You need a general-purpose caching solution across applications.  
  - You want to leverage Redis or Memcached for a wide variety of use cases.  
  - You need to work with data structures like lists, sets, or sorted sets.  

### **DynamoDB Stream Architecture**

**DynamoDB Streams** is an optional feature in Amazon DynamoDB that captures a time-ordered sequence of item-level modifications in a table. These modifications are stored as stream records, which can be consumed and processed asynchronously. The architecture of DynamoDB Streams revolves around capturing, storing, and processing these change events effectively.

---

### **Components of DynamoDB Streams Architecture**

1. **Source Table**  
   - The DynamoDB table where item-level changes occur.
   - Supported events include `INSERT`, `MODIFY`, and `REMOVE`.

2. **Stream Records**  
   - Each change to an item generates a stream record.
   - Records are stored in a time-ordered manner for 24 hours by default.
   - A record can include:
     - `Keys`: The primary key of the modified item.
     - `OldImage`: The item’s state before the change.
     - `NewImage`: The item’s state after the change.
     - `StreamViewType`: Defines what data is included in the stream (`KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES`).

3. **DynamoDB Stream**  
   - A durable, distributed, and fault-tolerant stream that holds the change data.
   - Serves as the event source for downstream processing.

4. **AWS Lambda**  
   - Often used as a consumer for processing DynamoDB Streams.
   - Automatically scales to handle the event volume.
   - Can execute custom business logic when an event is detected, such as updating a secondary database or triggering notifications.

5. **AWS SDK and Kinesis Adapter**  
   - DynamoDB Streams are compatible with the Kinesis Client Library (KCL).
   - Developers can use KCL to write custom consumers for fine-grained control over stream processing.

6. **Destination Services**  
   - After processing, the data from the stream can be sent to other AWS services or external systems:
     - **Amazon S3** for archiving.
     - **Amazon Redshift** for analytics.
     - **Amazon OpenSearch Service** for search indexing.
     - **Other DynamoDB tables** for replication or materialized views.

---

### **Workflow of DynamoDB Streams**
1. **Change Detection**  
   - Every change to the table generates a stream record and pushes it to the DynamoDB Stream.

2. **Stream Storage**  
   - The stream stores these records for 24 hours, providing a buffer for downstream consumers.

3. **Event Consumption**  
   - Consumers (e.g., Lambda functions, custom applications using KCL) poll the stream for new records.

4. **Event Processing**  
   - Consumers process the records according to application logic, such as:
     - Synchronizing changes with a data warehouse.
     - Triggering notifications.
     - Updating search indices.

---

### **Architecture Diagram**
Here’s how the architecture typically looks:

1. **DynamoDB Table:** The source table where changes happen.  
2. **DynamoDB Stream:** Stores item-level change events.  
3. **Stream Consumer:** A Lambda function or custom KCL application.  
4. **Destination Systems:** Receives processed data for further action.

---

### **Key Features of DynamoDB Streams**
- **Event Order:** Guarantees item-level event ordering.
- **Durability:** Stores records for 24 hours with fault tolerance.
- **Integration:** Easily integrates with AWS Lambda and other AWS services.
- **Scalability:** Scales with the DynamoDB table's throughput.

---

### **Use Cases for DynamoDB Streams**
1. **Data Replication:**
   - Replicate changes to another DynamoDB table in the same or different region.
   
2. **Search Indexing:**
   - Update search indices in Amazon OpenSearch Service based on table updates.

3. **Real-Time Analytics:**
   - Push change data to analytics services like Amazon Redshift or Amazon Kinesis Data Analytics.

4. **Audit Trails:**
   - Maintain a complete change history for compliance or debugging purposes.

5. **Event-Driven Workflows:**
   - Trigger downstream workflows in response to table updates.

---

DynamoDB Streams provides a powerful way to build real-time, event-driven architectures, allowing seamless integration between DynamoDB and other AWS or external systems.


### **Amazon DynamoDB Global Tables**

**DynamoDB Global Tables** is a fully managed, multi-region replication feature provided by Amazon DynamoDB. It allows you to replicate your DynamoDB tables across multiple AWS regions, enabling **high availability**, **low-latency reads and writes**, and **disaster recovery** for global-scale applications.

---

### **Key Features of DynamoDB Global Tables**

1. **Multi-Region Replication**  
   - Automatically replicates data across multiple regions in near real-time.  
   - Ensures data consistency and availability globally.

2. **Global Read and Write Operations**  
   - Enables applications in different regions to perform local read and write operations with low latency.  
   - Avoids cross-region delays by reading and writing data from the nearest replica.

3. **Fault Tolerance**  
   - Provides automatic failover to other regions in case of a regional outage, ensuring application availability.

4. **Active-Active Architecture**  
   - All replicas in different regions can simultaneously handle read and write requests, eliminating the need for a single primary region.

5. **Conflict Resolution**  
   - DynamoDB resolves write conflicts using a **last-writer-wins** strategy, based on the timestamp of changes.

6. **No Application-Level Changes**  
   - Applications can continue using DynamoDB APIs without modifications.  
   - Global Tables handle replication and synchronization automatically.

---

### **How DynamoDB Global Tables Work**

1. **Table Creation**  
   - When creating a global table, you define multiple AWS regions where the table should be replicated.

2. **Data Replication**  
   - DynamoDB replicates data from the source table to all specified regions.  
   - Changes made in one region are asynchronously propagated to other regions.

3. **Conflict Management**  
   - DynamoDB ensures eventual consistency across all replicas.  
   - In case of simultaneous writes to the same item in different regions, the latest change (based on timestamp) is retained.

4. **Integration with Other AWS Services**  
   - Seamlessly integrates with AWS services like Lambda, Kinesis, and CloudWatch, enabling event-driven and highly scalable architectures.

---

### **Use Cases for DynamoDB Global Tables**

1. **Global Applications**  
   - Applications with a global user base can use regional replicas to reduce latency and improve user experience.

2. **Disaster Recovery**  
   - Protects data against regional outages by automatically failing over to other regions.

3. **Multi-Region Analytics**  
   - Enables analytics and reporting by synchronizing data across regions for parallel processing.

4. **Regulatory Compliance**  
   - Ensures data residency compliance by maintaining replicas in specific regions.

5. **E-Commerce and Gaming Platforms**  
   - Handles high-volume, low-latency operations for global user bases, ensuring consistency and high availability.

---

### **Benefits of DynamoDB Global Tables**

- **Low Latency:**  
  Serve users with low-latency access to data by replicating to the nearest AWS region.

- **Scalability:**  
  Handles millions of requests per second globally with DynamoDB's serverless, automatically scaling architecture.

- **Simplicity:**  
  AWS manages all aspects of replication, synchronization, and conflict resolution.

- **Resilience:**  
  Built-in disaster recovery capabilities with automatic failover across regions.

- **Cost-Effective:**  
  Avoids the need for custom replication solutions, reducing operational overhead.

---

### **Considerations for Global Tables**

1. **Eventual Consistency:**  
   - Data across replicas might not be immediately consistent due to asynchronous replication.

2. **Conflict Resolution:**  
   - Applications must be designed to handle potential conflicts caused by simultaneous writes in different regions.

3. **Replication Costs:**  
   - Replicating data across regions incurs additional costs for storage, write requests, and data transfer.

4. **Regional Limitations:**  
   - Global Tables can only replicate across regions where DynamoDB is available.

---

### **How to Set Up Global Tables**

1. **Enable DynamoDB Streams:**  
   - Streams are required for tracking data changes and replicating them to other regions.

2. **Create the Global Table:**  
   - Use the AWS Management Console, CLI, or SDK to define the regions for replication.

3. **Write and Read Locally:**  
   - Applications automatically interact with the nearest replica based on the AWS region they are running in.

4. **Monitor and Optimize:**  
   - Use CloudWatch metrics and DynamoDB auto-scaling to optimize performance and cost.

---

### **Global Tables Architecture**

1. **Primary Table:**  
   - A DynamoDB table in one AWS region, serving as the initial data source.

2. **Replicas:**  
   - Synchronized tables in other regions that serve as read/write endpoints for local applications.

3. **Replication Streams:**  
   - DynamoDB Streams propagate changes asynchronously to all replicas.

---

DynamoDB Global Tables provide a robust solution for building resilient, low-latency, and globally distributed applications, simplifying the complexities of multi-region data management.

### **DynamoDB Time to Live (TTL)**

**Time to Live (TTL)** is a feature in Amazon DynamoDB that allows you to define a timestamp attribute in your items, enabling automated expiration and deletion of items once the specified time is reached. TTL helps reduce storage costs and simplifies data lifecycle management by automatically removing expired data from your table.

---

### **How TTL Works**

1. **TTL Attribute**  
   - You define a specific attribute (e.g., `expiry_date`) in your table as the TTL attribute.  
   - The attribute must store a timestamp value in **Unix epoch time** format (seconds since January 1, 1970, UTC).

2. **Expiration Check**  
   - DynamoDB continuously monitors the TTL attribute.  
   - When the current time surpasses the TTL timestamp, the item is marked as expired.

3. **Automatic Deletion**  
   - Expired items are automatically deleted by DynamoDB in the background.  
   - The deletion process is asynchronous and does not immediately occur after the timestamp is reached.

4. **Eventual Consistency**  
   - Deleted items might still appear in queries or scans for a short period due to eventual consistency.

---

### **Enabling TTL**

1. **Define TTL Attribute:**  
   - Choose an attribute that will store the expiration timestamp. This attribute must be a **Number** type in epoch time.

2. **Enable TTL in Table Settings:**  
   - In the AWS Management Console, navigate to your DynamoDB table.
   - Go to **Time to Live settings** and enable TTL for your chosen attribute.

3. **Set Expiration Values:**  
   - When inserting or updating items, populate the TTL attribute with a future Unix epoch timestamp.

---

### **Key Benefits of TTL**

1. **Automatic Data Expiry**  
   - Removes expired data without the need for manual deletion scripts or additional processing.

2. **Cost Savings**  
   - Reduces storage costs by cleaning up unused or outdated data.

3. **Simplified Data Management**  
   - Ideal for managing temporary data such as session tokens, logs, or caches.

4. **Improved Performance**  
   - Removes unnecessary data, leading to more efficient queries and scans.

---

### **Use Cases for TTL**

1. **Session Management:**  
   - Automatically expire user sessions after a certain period of inactivity.

2. **Temporary Caching:**  
   - Store temporary results or data snapshots that expire after a defined interval.

3. **Audit Logs and Metrics:**  
   - Manage time-sensitive logs or metrics by expiring them after their retention period.

4. **IoT Data Management:**  
   - Remove outdated sensor data after a specific time window.

---

### **Considerations**

1. **Asynchronous Deletion:**  
   - Items are not deleted instantly when they expire. Deletion may take from minutes to hours, depending on system activity.

2. **Query Behavior:**  
   - Expired items may still appear in query results temporarily due to eventual consistency.

3. **TTL Attribute Updates:**  
   - If the TTL attribute is updated with a future timestamp before expiration, the item will not be deleted.

4. **Data Size Limits:**  
   - TTL does not bypass DynamoDB limits for table size or provisioned throughput.

5. **No Additional Cost:**  
   - TTL is included at no extra charge, but the regular costs for read, write, and storage still apply.

---

### **Example: Using TTL in DynamoDB**

1. **Defining the TTL Attribute**  
   Suppose you have a table named `Sessions` with the following attributes:
   - `session_id` (Primary Key)
   - `user_id`
   - `expiry_date` (TTL Attribute)

2. **Adding Items with TTL**  
   Insert a session that expires in 1 hour:
   ```json
   {
     "session_id": "abc123",
     "user_id": "user42",
     "expiry_date": 1701032400 // Unix epoch time for 1 hour from now
   }
   ```

3. **Behavior After Expiry**  
   - After the `expiry_date` is reached, DynamoDB automatically removes the item.  

---

### **Monitoring TTL**

1. **CloudWatch Metrics:**  
   - Use the `ExpiredItemDeletions` metric in Amazon CloudWatch to monitor TTL activity.

2. **DynamoDB Streams:**  
   - Enable streams to capture deletion events for expired items, which can trigger further processing (e.g., logging, notifications).

---

**DynamoDB TTL** is a powerful feature for automating data lifecycle management, saving costs, and improving application efficiency by eliminating outdated or temporary data seamlessly.

### **DynamoDB Backups for Disaster Recovery**

Amazon DynamoDB offers several backup and restore options to protect your data against accidental deletion, corruption, or unexpected outages. These features are essential for disaster recovery (DR) planning, ensuring your data can be quickly restored with minimal downtime.

---

### **Backup Options in DynamoDB**

#### **1. On-Demand Backup**
- **What It Is:**  
  - You can create full backups of your DynamoDB tables at any time with a single click or API call.  
  - These backups include all table data and settings, except for auto-scaling policies or DynamoDB Streams.

- **Key Features:**
  - Backups are retained until explicitly deleted.
  - No performance impact on the table during the backup process.
  - Supports point-in-time recovery by creating periodic backups.

- **Use Cases:**
  - Ad-hoc backups before significant changes or updates.
  - Long-term storage for compliance and regulatory purposes.

#### **2. Point-in-Time Recovery (PITR)**
- **What It Is:**  
  - Automatically creates incremental backups for your DynamoDB table every second.  
  - Enables restoring a table to any second within the last 35 days.

- **Key Features:**
  - Continuous data protection (CDP) for accidental deletion or corruption.
  - Works in the background without affecting table performance.
  - Can restore data to a specific second (precision recovery).

- **Use Cases:**
  - Protect against accidental writes or deletes.
  - Revert to a known good state after identifying data corruption.

---

### **Steps to Enable and Use Backups**

#### **1. On-Demand Backup**
- **Enable:**  
  - Go to the DynamoDB console, select your table, and choose **Backups** > **Create Backup**.
- **Restore:**  
  - Restore the backup to a new table from the console or using AWS CLI.

#### **2. Point-in-Time Recovery (PITR)**
- **Enable:**  
  - In the DynamoDB console, select your table and turn on **Point-in-Time Recovery**.  
  - Alternatively, use the AWS CLI or SDK to enable it programmatically.
- **Restore:**  
  - Specify the exact timestamp within the 35-day retention window to restore data.

---

### **Considerations for Disaster Recovery**

1. **Replication and Global Tables**  
   - Use **Global Tables** for multi-region replication and high availability.  
   - In a disaster scenario, switch your application to the replica table in another region.

2. **Data Consistency**  
   - Be aware of the consistency model when restoring data.  
   - Restored tables are always consistent with the backup state but may require reconciliation for replicated tables.

3. **Costs**  
   - **Backup Costs:** Charged based on the size of the table and the duration of storage.  
   - **Restore Costs:** Charged for restoring data to a new table.  
   - Optimize costs by deleting obsolete backups.

4. **Limitations**  
   - You cannot restore to the same table; a new table must be created.
   - PITR retains backups for up to 35 days, not suitable for long-term archival.

---

### **Best Practices for Disaster Recovery**

1. **Combine Backups and Global Tables**  
   - Use **Global Tables** for immediate failover and backups for long-term data retention and recovery.

2. **Automate Backup Management**  
   - Use AWS Backup or custom scripts to automate regular on-demand backups.

3. **Regular Testing**  
   - Periodically test your recovery process by restoring backups to ensure data integrity and application compatibility.

4. **Monitor Backups**  
   - Use Amazon CloudWatch to monitor backup-related activities, such as backup creation and restore processes.

5. **Data Archival**  
   - For long-term storage, export DynamoDB data to **Amazon S3** using the export-to-S3 feature or AWS Glue.

---

### **DynamoDB Backup Architecture for DR**

1. **Primary Table:** The active DynamoDB table handling live traffic.
2. **Backup Layer:**  
   - On-demand backups or PITR enabled for regular snapshots.  
   - Export backups to S3 for longer retention.
3. **Multi-Region Replication:**  
   - Use Global Tables to replicate the primary table across multiple AWS regions.
4. **Recovery Process:**  
   - Restore from backups to a new table in case of data loss.
   - Use the global table replica as a failover endpoint during regional outages.

---

By integrating **DynamoDB Backups** and **Global Tables** into your disaster recovery strategy, you ensure both data durability and high availability for critical applications, minimizing downtime and data loss risks during unforeseen events.

### **DynamoDB Integration with Amazon S3**

Amazon DynamoDB and Amazon S3 can be integrated in various ways to create robust, scalable, and cost-efficient data storage and processing pipelines. Each service is optimized for specific use cases—DynamoDB for low-latency, high-speed NoSQL data access, and S3 for large-scale, durable object storage. Together, they enable advanced data management solutions.

---

### **Use Cases for Integration**

1. **Data Archiving and Export**  
   - DynamoDB data can be periodically exported to S3 for long-term storage or compliance.  

2. **Data Import and Synchronization**  
   - Import pre-existing datasets from S3 into DynamoDB to enable faster access for applications.

3. **Data Backup and Recovery**  
   - Use S3 as a durable storage layer for DynamoDB backups to ensure recoverability during disasters.

4. **Analytics and Reporting**  
   - Export DynamoDB data to S3 for integration with analytics tools such as Amazon Athena, QuickSight, or third-party platforms.

5. **Event-Driven Workflows**  
   - Trigger workflows using DynamoDB Streams and process or archive data in S3 through services like AWS Lambda.

---

### **Methods of Integration**

#### **1. Exporting Data from DynamoDB to S3**
- **Export to S3 Feature:**  
  DynamoDB allows direct export of table data to S3 without impacting the performance of your live table.  
  - Exported data is stored in Apache Parquet format, which is highly efficient for analytics.
  - Ideal for large-scale data exports and analysis workflows.

- **Steps to Export:**
  1. In the DynamoDB console, choose the table you want to export.
  2. Select **Export to Amazon S3** and specify an S3 bucket.
  3. Monitor the export job status in the **Export/Import** section.

- **Applications:**  
  - Archiving old data.  
  - Enabling analysis using Amazon Athena or Redshift Spectrum.

#### **2. Importing Data from S3 to DynamoDB**
- **AWS Data Pipeline:**  
  Use AWS Data Pipeline to transfer large datasets from S3 to DynamoDB.  
  - Define the data source (S3), transformation logic (if any), and destination (DynamoDB).

- **Custom Solutions:**  
  - Develop custom scripts using AWS SDKs to read data from S3 and write it to DynamoDB.

- **Applications:**  
  - Migrating data into DynamoDB.  
  - Loading pre-processed datasets for applications.

#### **3. Backup and Restore**
- **On-Demand Backups with S3:**  
  While DynamoDB manages its own backups, you can also export them to S3 for long-term retention and compliance.

- **Steps:**
  1. Enable DynamoDB backups or PITR.
  2. Export these backups to S3 for archiving.
  3. Use S3 lifecycle policies to manage storage costs.

- **Applications:**  
  - Long-term data archival.  
  - Meeting regulatory or compliance requirements.

#### **4. Event-Driven Workflows with DynamoDB Streams and S3**
- **Use DynamoDB Streams:**  
  - Enable DynamoDB Streams to capture data changes in real time.  
  - Trigger AWS Lambda functions to process these changes and store results or logs in S3.

- **Steps:**
  1. Enable **DynamoDB Streams** on your table.
  2. Create an **AWS Lambda** function to process stream events.
  3. Use the Lambda function to write data to an S3 bucket.

- **Applications:**  
  - Real-time archiving of transactions.  
  - Audit trail generation.

---

### **Best Practices for Integration**

1. **Data Partitioning**  
   - For large datasets, partition data in S3 based on criteria such as time or key ranges to optimize query performance.

2. **Use Parquet Format**  
   - Export data in Apache Parquet format when integrating with analytics services for faster queries and reduced storage costs.

3. **Automate with Lambda**  
   - Automate data transfer between DynamoDB and S3 using event-driven architecture.

4. **Cost Management**  
   - Use S3 lifecycle rules to transition data to lower-cost storage classes, such as S3 Glacier or S3 Intelligent-Tiering.

5. **Security**  
   - Apply AWS Identity and Access Management (IAM) roles to ensure secure data access between DynamoDB and S3.

---

### **Example Architectures**

#### **1. Real-Time Data Synchronization**
   - DynamoDB table updates trigger DynamoDB Streams.  
   - AWS Lambda processes these updates and writes data to S3 for further processing or archival.

#### **2. Analytics Pipeline**
   - Data is exported from DynamoDB to S3 in Parquet format.  
   - Use Amazon Athena to query the data directly from S3 without importing it back to DynamoDB.

#### **3. Disaster Recovery**
   - DynamoDB backups are stored in S3 for long-term storage.  
   - Restore backups from S3 to a new DynamoDB table in case of data loss.

---

By combining DynamoDB's low-latency database capabilities with S3's scalable object storage, you can build powerful, cost-effective, and reliable solutions for a wide range of application needs.

*/


/*resource "aws_athena_data_catalog" "example" {
  name        = "glue-data-catalog"
  description = "Glue based Data Catalog"
  type        = "GLUE"

  parameters = {
    "catalog-id" = "123456789012"
  }
}
*/

resource "aws_athena_data_catalog" "example" {
  name        = var.catalog_name
  description = var.catalog_description
  type        = var.catalog_type

  parameters = var.catalog_paramaters
}


/*
AWS Athena is a **fully managed query service** provided by Amazon Web Services (AWS). It is specifically designed to **query data stored on Amazon S3** using SQL, making it easy to analyze large datasets. Athena works efficiently on unstructured, semi-structured, or structured data.

### Key Features of Athena:
1. **Serverless Architecture**: Athena requires no infrastructure management. There is no need to set up, configure, or maintain servers.

2. **SQL Support**: You can use familiar **SQL** to query your data. Athena supports **ANSI SQL** standards.

3. **Fast and Efficient**: Athena directly reads data stored on **Amazon S3**. It supports columnar data formats like **Parquet** and **ORC**, which improve query performance.

4. **Multiple Data Formats**: Athena supports popular data formats such as **CSV, JSON, Avro, Parquet, and ORC**.

5. **Simplified ETL Processes**: Athena simplifies Extract, Transform, Load (ETL) processes for big data analytics by allowing you to query raw data directly.

6. **Cost-Efficient**: You only pay for the amount of data scanned during your queries, making it more cost-effective compared to many other big data analytics solutions.

### Use Cases:
- **Log Analysis**: Athena can be used to analyze application and system logs, such as examining CloudTrail logs.
- **ETL Alternative**: Eliminates complex data transformation processes, allowing you to query raw data directly.
- **Ad-hoc Data Analysis**: Enables quick queries on large datasets for analysis.
- **Data Reporting and Visualization**: Integrates with tools like **QuickSight** or other BI platforms for reporting purposes.

### How Athena Works:
1. **Data Stored on S3**: Your data must already be stored on Amazon S3.
2. **Defining a Table**: A schema is defined in Athena, describing how to access the data (e.g., column names and data formats).
3. **Querying**: Use SQL queries to analyze the data.
4. **Results**: Query results are typically saved in an S3 folder, from where they can be downloaded or integrated with other systems.

Athena provides a simple and fast solution for big data analytics, especially for analyzing large volumes of data stored on S3.


Improving performance in AWS Athena involves optimizing your data storage, query design, and usage of efficient data formats. Here are some best practices and strategies to enhance Athena's performance:

---

### 1. **Optimize Data Storage in S3**
- **Partitioning Data**:
  - Divide your dataset into partitions based on frequently queried columns (e.g., date, region).
  - Athena reads only the relevant partitions, reducing the amount of data scanned.
  - Example: Store data in S3 paths like `s3://my-bucket/logs/year=2024/month=11/day=26/`.

- **Use Columnar Data Formats**:
  - Prefer **Parquet** or **ORC** formats over row-based formats like CSV or JSON.
  - Columnar formats are optimized for analytical queries and reduce the amount of data scanned.

- **Compress Data**:
  - Use compression algorithms such as **Snappy** (for Parquet and ORC) or **GZIP** (for CSV/JSON).
  - Compression reduces the amount of data read from S3, improving query speed.

---

### 2. **Design Efficient Queries**
- **Avoid SELECT ***:
  - Query only the columns you need instead of using `SELECT *`. This minimizes the amount of data scanned.

- **Use WHERE Clauses**:
  - Filter data early by specifying conditions in your `WHERE` clause to limit the data scanned.

- **Use Partition Pruning**:
  - Design your queries to take advantage of partition columns. For example:
    ```sql
    SELECT * 
    FROM logs 
    WHERE year = '2024' AND month = '11';
    ```

- **Avoid Complex Joins and Subqueries**:
  - Simplify queries by minimizing nested subqueries and joins, especially on large datasets.
  - Consider denormalizing data for faster querying.

- **Optimize Aggregations**:
  - Aggregate data at the source if possible (e.g., pre-aggregate data in your ETL process).

---

### 3. **Efficient Table Design**
- **Glue Crawler and Schema Design**:
  - Use **AWS Glue Crawlers** to automatically infer and update table schemas.
  - Ensure your schema aligns with the data format to avoid scanning unnecessary rows.

- **External Tables and Views**:
  - Use external tables in Athena and avoid creating multiple unnecessary views as they can add complexity and impact performance.

---

### 4. **Leverage Query Results and Caching**
- **Query Result Caching**:
  - Athena caches query results for 30 days. If a query doesn't need fresh data, re-run the cached query to avoid scanning the dataset again.

- **Materialized Views**:
  - Use materialized views to precompute and store query results, especially for frequently accessed data.

---

### 5. **Parallelize Workloads**
- **Split Large Queries**:
  - Break down large queries into smaller ones, especially when dealing with massive datasets.

- **Use Multiple Queries for Batch Processing**:
  - Process data in parallel using multiple queries to minimize processing time.

---

### 6. **Monitor and Analyze Performance**
- **Query Execution Plan**:
  - Use the Athena Query Editor to view execution plans. Identify which steps take the most time or scan excessive data.

- **AWS CloudWatch Metrics**:
  - Monitor Athena's performance metrics in CloudWatch, including query runtime and scanned data size.

- **Use AWS Cost and Usage Reports**:
  - Analyze costs related to scanned data and optimize queries to reduce unnecessary scans.

---

### 7. **Enable Partition Projection**
- Use **Partition Projection** for large datasets with numerous partitions. This avoids recursive listing in S3, improving query performance.

---

### Example Optimization Workflow
1. Convert raw data to **Parquet** or **ORC** format.
2. Compress the data using **Snappy**.
3. Partition data by logical keys such as date or region.
4. Create an Athena table with proper schema and partitions.
5. Design queries to use `WHERE` clauses on partition keys.

By following these steps and optimizing both your data storage and queries, you can significantly improve Athena's query performance and reduce costs.


**Athena Federated Query** is a feature of Amazon Athena that allows you to query data from multiple sources, not just Amazon S3, using standard SQL. With Federated Query, you can analyze data across a wide variety of AWS services and external systems, such as relational databases, NoSQL databases, and even custom data stores.

---

### How Athena Federated Query Works:
1. **Data Source Connectors**:
   - Athena uses **AWS Lambda-based data source connectors** to integrate with external data systems.
   - These connectors fetch data from the target source, convert it into a format Athena understands, and return the results for processing.

2. **Unified SQL Interface**:
   - You write SQL queries in Athena, which can access both S3-based datasets and external sources seamlessly.

3. **Glue Data Catalog**:
   - Federated Query integrates with the **AWS Glue Data Catalog**, allowing you to manage metadata for multiple data sources.

4. **Result Storage**:
   - Query results are stored in an S3 bucket, just like with traditional Athena queries.

---

### Supported Data Sources
Athena Federated Query supports multiple AWS services and external databases, including:
- **AWS Services**:
  - DynamoDB
  - RDS (MySQL, PostgreSQL)
  - Redshift
- **External Databases**:
  - Microsoft SQL Server
  - Snowflake
  - Apache Kafka
  - MongoDB
- **Custom Data Sources**:
  - Custom-built connectors can be deployed using AWS Lambda to integrate with proprietary systems.

---

### Use Cases
1. **Cross-Service Analytics**:
   - Combine data from S3, RDS, DynamoDB, and Redshift into a single query for comprehensive analytics.

2. **Join Across Data Sources**:
   - Perform SQL joins between data stored in S3 and external systems (e.g., join transactional data from RDS with historical logs in S3).

3. **Data Lake Expansion**:
   - Extend your data lake by including external systems without migrating all data to S3.

4. **Operational Reporting**:
   - Query operational databases like RDS or DynamoDB directly for real-time reporting.

---

### Setting Up Athena Federated Query
1. **Install a Connector**:
   - Use **AWS Serverless Application Repository** to deploy a pre-built connector for your data source.
   - Example: Deploy the **Amazon Athena DynamoDB Connector** for querying DynamoDB.

2. **Register the Connector**:
   - Register the connector in Athena using SQL commands or the Athena management console.

3. **Update Glue Data Catalog**:
   - Define tables and schemas for the external data source in **AWS Glue Data Catalog**.

4. **Write Queries**:
   - Use SQL to query the external data directly. Example:
     ```sql
     SELECT * 
     FROM "dynamodb"."my_table" 
     WHERE attribute = 'value';
     ```

---

### Best Practices
1. **Optimize Lambda Functions**:
   - Ensure your Lambda-based connectors are optimized for performance and cost efficiency.

2. **Minimize Data Transfer**:
   - Use filters in SQL queries (`WHERE` clauses) to reduce the amount of data transferred between Athena and the data source.

3. **Partition External Data**:
   - If the external data source supports partitioning, design schemas to take advantage of it for faster queries.

4. **Monitor and Tune**:
   - Use **AWS CloudWatch** to monitor the performance and cost of your federated queries.

---

### Limitations
- **Performance**: Query performance depends on the external data source's speed and the Lambda function's efficiency.
- **Cost**: Federated queries can incur additional charges, such as Lambda execution costs and data transfer fees.

---

### Example Query with Federated Source
Suppose you have S3 logs and DynamoDB customer data:

```sql
SELECT logs.session_id, logs.event, customers.customer_name
FROM "s3_logs"."events" AS logs
JOIN "dynamodb"."customers" AS customers
ON logs.customer_id = customers.customer_id
WHERE logs.event_date = '2024-11-25';
```

This query joins logs from S3 with customer data in DynamoDB, enabling cross-source analytics in a single SQL query.

---

Athena Federated Query is ideal for building unified analytics solutions without the need to move or replicate data across systems.

*/

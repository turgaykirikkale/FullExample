
resource "aws_cloudwatch_metric_alarm" "cloud_watch" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description

  dimensions = var.dimensions

  actions_enabled = true
  alarm_actions   = var.alarm_actions
}


/*
**What is Amazon CloudWatch?**

Amazon CloudWatch is a **monitoring and observability service** that runs on **AWS (Amazon Web Services)**. It collects real-time data about applications, infrastructure, system performance, and operational health, enabling you to visualize and analyze this information effectively.

### Key Features
1. **Metric Collection and Monitoring:**
   - Collects performance metrics from AWS services (EC2, RDS, S3, etc.) and your applications.
   - Enables tracking of metrics such as CPU usage, memory, disk read/write, and more.

2. **Log Monitoring and Management:**
   - Collects and manages application and system logs for analysis and troubleshooting.
   - For instance, it can store error messages from a Lambda function or logs from an EC2 instance.

3. **Alarms:**
   - Triggers alerts when a specified metric crosses predefined thresholds.
   - For example, sends an email notification if CPU usage exceeds 80%.

4. **Dashboards and Visualization:**
   - Allows the creation of custom dashboards to visualize collected data through graphs and charts.
   - Helps you quickly understand your systems and detect issues.

5. **Automation and Response:**
   - Automates responses based on alarms (e.g., adding more instances to an Auto Scaling group).
   - Can be integrated with AWS Lambda to perform custom actions.

6. **Application Performance Monitoring (APM):**
   - Features like **CloudWatch ServiceLens** help identify performance issues in microservices or distributed systems.

7. **Integration:**
   - Can collect data from applications and systems running outside AWS.
   - Enables reporting of custom application metrics.

### Use Cases
- **Performance Monitoring:** Analyze the performance of your EC2 instances or RDS databases.
- **Event Detection:** Quickly identify and resolve errors in application logs.
- **Automation:** For instance, automatically extend an EBS volume when disk usage reaches a critical level.
- **Security:** Detect suspicious activities through log analysis.
- **Custom Metrics:** Collect and analyze custom metrics from your software.

### Advantages
- **Seamless AWS Integration:** Works perfectly with all AWS services.
- **Real-Time Data:** Allows you to take immediate actions.
- **Flexibility:** You can define custom metrics and alarms.
- **Comprehensive Coverage:** Provides monitoring at both the infrastructure and application levels.

Amazon CloudWatch is an indispensable tool for anyone managing and optimizing AWS environments. It ensures that your applications and infrastructure resources operate smoothly and effectively.



### What are CloudWatch Metrics?

**CloudWatch Metrics** are data points used to measure the performance and health of AWS resources. AWS services automatically send certain metrics to CloudWatch, and you can also create custom metrics from your own applications.

---

### Characteristics of CloudWatch Metrics
1. **Namespace:**
   - Metrics are grouped within namespaces. For example:
     - `AWS/EC2`: Metrics for EC2 instances.
     - `AWS/S3`: Metrics for S3 buckets.
   - You can define custom namespaces for user-defined metrics.

2. **Dimensions:**
   - Metrics are associated with dimensions for more specific monitoring.
   - For instance, an EC2 instance metric may have a dimension like `InstanceId`.

3. **Data Points:**
   - Metrics are measured at specific intervals (e.g., every minute).
   - CloudWatch aggregates these data points over a period (e.g., minimum, maximum, average).

---

### Common AWS CloudWatch Metrics

#### **1. EC2 Metrics**
- **CPUUtilization:** Percentage of CPU usage.
- **DiskReadOps / DiskWriteOps:** Number of disk read and write operations.
- **NetworkIn / NetworkOut:** Volume of data received and sent via the network.
- **StatusCheckFailed:** Failed system and instance status checks.
- **MemoryUtilization (Custom):** Requires a custom metric to monitor memory usage.

#### **2. S3 Metrics**
- **BucketSizeBytes:** Total size of all objects in an S3 bucket.
- **NumberOfObjects:** Total number of objects in a bucket.
- **4xxErrors / 5xxErrors:** Count of client (4xx) and server (5xx) errors.
- **GetRequests / PutRequests:** Number of GET and PUT requests to the bucket.

#### **3. RDS (Relational Database Service) Metrics**
- **CPUUtilization:** CPU usage of the RDS instance.
- **DatabaseConnections:** Number of active database connections.
- **FreeStorageSpace:** Available storage space in the database.
- **ReadIOPS / WriteIOPS:** Number of read/write operations in the database.

#### **4. ELB (Elastic Load Balancer) Metrics**
- **RequestCount:** Total number of requests received by ALB or NLB.
- **HealthyHostCount / UnhealthyHostCount:** Number of healthy and unhealthy backend instances.
- **TargetResponseTime:** Response time of target instances.
- **HTTPCode_ELB_4XX_Count / HTTPCode_ELB_5XX_Count:** Count of 4xx and 5xx error codes returned by the load balancer.

#### **5. Lambda Metrics**
- **Invocations:** Number of times the Lambda function was invoked.
- **Duration:** Execution time of the Lambda function (in milliseconds).
- **Errors:** Number of errors encountered during execution.
- **Throttles:** Number of throttled requests due to exceeded limits.

#### **6. Auto Scaling Metrics**
- **GroupMinSize / GroupMaxSize:** Minimum and maximum number of instances in the Auto Scaling group.
- **GroupInServiceInstances:** Number of running instances.
- **GroupPendingInstances:** Number of instances in the pending state.

#### **7. DynamoDB Metrics**
- **ConsumedReadCapacityUnits / ConsumedWriteCapacityUnits:** Usage of read/write capacity.
- **ThrottledRequests:** Number of throttled requests.
- **ProvisionedThroughputExceeded:** Occurrences where the defined capacity was exceeded.

---

### Adding Custom Metrics
AWS allows you to add **Custom Metrics** from your applications. For example:
- Monitoring application processing times or error rates.
- Reporting the frequency of specific operations in microservices.

You can send these custom metrics to CloudWatch using the **PutMetricData API**.

---

### Metric Retention Periods
- **1-minute metrics:** Retained for 15 days.
- **5-minute metrics:** Retained for 63 days.
- **1-hour metrics:** Retained for 455 days.

---

CloudWatch Metrics are critical for real-time monitoring and optimizing the performance of your systems. Both default AWS metrics and custom metrics play a significant role in providing operational visibility.


### What are CloudWatch Log Streams?

**CloudWatch Log Streams** are a component of the Amazon CloudWatch Logs service. A **Log Stream** is a sequence of log events that originate from a specific source (e.g., an EC2 instance, a Lambda function, or an application). Log streams are organized within **Log Groups**, which act as logical groupings of logs.

---

### Key Features of CloudWatch Log Streams

1. **Relationship with Log Groups:**
   - One or more log streams reside within a **Log Group**.
   - For example:
     - `Log Group`: `/aws/lambda/my-function`
     - `Log Stream`: `2024/11/28/[LATEST]`

2. **Source-Based Streams:**
   - Each source has its own log stream.
   - For example, each EC2 instance in an Auto Scaling group can create its own log stream.

3. **Sequential Data:**
   - A Log Stream is a collection of sequential log events, each marked with a timestamp.

4. **Access and Management:**
   - Log streams can be accessed via the CloudWatch Logs console, AWS CLI, or SDKs.
   - Log data can be read, analyzed, or exported as needed.

---

### Use Cases for CloudWatch Log Streams

1. **Application Log Management:**
   - Logs from your application can be stored in a specific log stream.
   - For example, each invocation of a Lambda function writes logs to its associated log stream.

2. **EC2 Instance Logs:**
   - Application or system logs from EC2 instances can be sent to a log stream for centralized storage.
   - The **CloudWatch Agent** makes it easy to stream these logs.

3. **Troubleshooting:**
   - To analyze logs for a specific source, log streams allow you to isolate and investigate the logs from that resource.

4. **Microservices Monitoring:**
   - Create separate log streams for each microservice, simplifying monitoring and debugging.

---

### Key Terms Related to CloudWatch Log Streams

- **Log Event:** Each individual log entry within a log stream.
- **Timestamp:** Each log event is recorded with a timestamp.
- **Sequence Token:** A mechanism to ensure log events are written in the correct order.

---

### Advantages

- **Centralized Management:** Allows you to manage all logs from AWS resources in one place.
- **Real-Time Monitoring:** Log streams are updated in real-time as new log entries are added.
- **Query and Analysis:** Use CloudWatch Logs Insights to query and analyze log streams.
- **Flexibility:** Log data can be separated by source, making analysis easier.

---

### Relationship Between Log Groups and Log Streams

A **Log Group** acts as a collection of log streams representing the same function or service. For example:
- **Log Group:** `/aws/lambda/my-lambda-function`
- **Log Streams:**
  - `2024/11/28/[$LATEST]abcdef1234567890`
  - `2024/11/27/[$LATEST]123456abcdef7890`

---

### Summary

CloudWatch Log Streams are a powerful tool for organizing and analyzing logs from your AWS resources. Each resource stores its logs in its own stream, providing both scalability and ease of management. This is especially valuable in distributed systems and microservices architectures, where efficient log management is critical.


### What are CloudWatch Logs?

**CloudWatch Logs** is a service provided by Amazon CloudWatch for storing, monitoring, and analyzing log data collected from your AWS resources and applications. It allows you to review logs in real time and retain them for long-term storage. You can also run custom queries on logs to gain valuable insights.

---

### Key Features of CloudWatch Logs

1. **Log Groups:**
   - Logs are organized into logical units called **Log Groups**.
   - Logs related to the same application or service are typically stored in one log group.
   - Example:
     - Log Group: `/aws/lambda/my-function`

2. **Log Streams:**
   - Each log group contains one or more **Log Streams**, which collect log data from specific sources (e.g., a Lambda invocation or an EC2 instance).

3. **Log Events:**
   - A log stream consists of a series of **Log Events**.
   - Each log event is recorded with a timestamp and a message.

4. **Real-Time Monitoring:**
   - CloudWatch Logs allows you to monitor log data in real time and set up alerts when certain conditions are met.

5. **Query and Analysis:**
   - Use **CloudWatch Logs Insights** to run queries and perform detailed analysis on log data.

6. **Long-Term Retention:**
   - Logs are stored by default, and you can configure the retention period based on your needs.

---

### Use Cases for CloudWatch Logs

1. **Monitoring Application Performance:**
   - Log custom messages or error records from your application to analyze performance and troubleshoot issues.

2. **AWS Service Logs:**
   - Centralize logs from AWS services (e.g., Lambda, RDS, ELB) for easy monitoring.

3. **Security and Compliance:**
   - Forward CloudTrail logs to CloudWatch Logs for security event monitoring and compliance analysis.

4. **Real-Time Alerts:**
   - Set up alerts for specific log patterns (e.g., error messages or critical events).

5. **Long-Term Archiving:**
   - Store logs in CloudWatch Logs or back them up to services like Amazon S3 for archival purposes.

---

### Examples of AWS Resources and CloudWatch Logs Integration

1. **EC2:**
   - Use the **CloudWatch Agent** to stream application and system logs from EC2 instances to CloudWatch Logs.

2. **Lambda:**
   - Logs generated by Lambda functions are automatically sent to CloudWatch Logs.

3. **CloudTrail:**
   - Analyze AWS API calls and activities with CloudWatch Logs.

4. **RDS (Relational Database Service):**
   - Monitor RDS logs (e.g., MySQL, PostgreSQL error logs) in CloudWatch Logs.

5. **Elastic Load Balancer (ELB):**
   - Stream ELB access logs to CloudWatch Logs for centralized analysis.

---

### Advantages of CloudWatch Logs

- **Centralized Log Management:** Collect and analyze logs from all your resources in one place.
- **Flexibility and Scalability:** Handle large volumes of log data efficiently.
- **Integration:** Easily integrates with AWS services.
- **Analytical Power:** Perform deep analysis using Logs Insights.
- **Customizable Retention Period:** Configure how long you want logs to be stored.

---

### Using CloudWatch Logs Insights for Custom Queries
The **Logs Insights** tool enables you to run custom queries on your logs for meaningful insights. For example:
- To find Lambda errors:
  ```sql
  fields @timestamp, @message  
  | filter @message like /error/  
  | sort @timestamp desc  
  ```
- To monitor EC2 CPU utilization:
  ```sql
  stats avg(CPUUtilization) by InstanceId  
  ```

---

### Summary
CloudWatch Logs provides a centralized solution for collecting, analyzing, and monitoring logs from your AWS environment and applications. It supports use cases like security, performance monitoring, troubleshooting, and long-term log retention.


### What are CloudWatch Sources?

**CloudWatch Sources** are the origins from which Amazon CloudWatch collects metrics, logs, and events. These sources can include AWS services, on-premises systems, custom applications, or external tools. CloudWatch uses these sources to monitor performance, detect issues, and provide insights across your infrastructure and applications.

---

### Common CloudWatch Sources

1. **AWS Services:**
   CloudWatch natively integrates with many AWS services, automatically collecting their metrics and logs.
   - **EC2:** CPU usage, disk I/O, network traffic, and system logs.
   - **RDS:** Database connections, read/write latency, and performance insights.
   - **Lambda:** Invocation count, duration, error rates, and logs for each execution.
   - **S3:** Bucket metrics like total storage, number of requests, and access logs.
   - **DynamoDB:** Read/write capacity, throttling events, and item metrics.
   - **ELB (Elastic Load Balancer):** Request count, latency, and HTTP response metrics.
   - **CloudFront:** Cache hit/miss ratios and request statistics.

2. **CloudTrail:**
   - CloudTrail logs API calls and events in your AWS account.
   - You can forward these logs to CloudWatch for monitoring and analysis.

3. **Custom Applications:**
   - Applications can send custom metrics and logs to CloudWatch using the **CloudWatch Agent** or the AWS SDK.
   - Examples:
     - Application performance metrics (e.g., response time, user activity).
     - Custom log messages or structured events.

4. **On-Premises Systems:**
   - You can monitor on-premises servers or hybrid environments by installing the **CloudWatch Agent**.
   - Collects metrics like CPU usage, memory, disk I/O, and logs from local servers.

5. **Operating Systems:**
   - Use the CloudWatch Agent to collect OS-level metrics and logs.
   - Examples: System logs, application logs, or resource utilization metrics.

6. **Third-Party Tools:**
   - Tools like Prometheus or Datadog can integrate with CloudWatch to forward their metrics and logs.
   - These integrations enable unified monitoring across platforms.

7. **CloudWatch Logs:**
   - Sources include:
     - Application logs from EC2 instances.
     - Lambda function logs.
     - Logs from AWS services like API Gateway or Step Functions.
     - Log data forwarded from external systems.

8. **Events from AWS Services:**
   - AWS services emit events to **CloudWatch Events** (now called Amazon EventBridge).
   - Examples:
     - State changes in EC2 instances.
     - Autoscaling events.
     - RDS instance modifications.

---

### How CloudWatch Sources Work

1. **Automatic Data Collection:**
   - Many AWS services automatically send their metrics and logs to CloudWatch without requiring additional configuration.

2. **Custom Data Collection:**
   - For custom sources, developers or administrators must configure the CloudWatch Agent or SDK to push data to CloudWatch.

3. **Centralized Monitoring:**
   - All sources feed data into CloudWatch, where it can be visualized on dashboards, analyzed with logs insights, or used to trigger alarms.

---

### Advantages of CloudWatch Sources

- **Diverse Inputs:** Supports a wide range of data sources, from native AWS services to external systems.
- **Unified Monitoring:** Centralizes metrics, logs, and events in one place for streamlined analysis.
- **Customizability:** Enables users to send specific application or system-level data.
- **Real-Time Alerts:** Detects and responds to issues across all monitored sources in real time.

---

### Summary

CloudWatch Sources include AWS services, custom applications, on-premises systems, and external tools that provide metrics, logs, and events for centralized monitoring. By integrating data from diverse sources, CloudWatch enables organizations to monitor their entire infrastructure effectively and gain actionable insights.


### What is CloudWatch Insights?

**CloudWatch Logs Insights** is a feature within Amazon CloudWatch that enables you to run interactive queries on your log data to analyze and troubleshoot issues efficiently. With this tool, you can gain actionable insights from your log files, allowing you to monitor application performance, detect anomalies, and debug problems across your infrastructure.

---

### Key Features of CloudWatch Logs Insights

1. **Powerful Query Language:**
   - Logs Insights uses a flexible and efficient query language to extract, analyze, and visualize data.
   - You can filter, aggregate, and sort logs to find specific events or trends.

2. **Pre-Built Queries:**
   - AWS provides pre-built queries for common use cases, such as finding errors or monitoring latency.

3. **Scalable Analysis:**
   - Logs Insights can analyze terabytes of log data quickly, ensuring scalability for large environments.

4. **Integration with CloudWatch Dashboards:**
   - Query results can be visualized in **CloudWatch Dashboards** to provide real-time monitoring and reporting.

5. **Rich Visualization Options:**
   - Supports graphical views like time-series graphs for visualizing query results.

---

### Use Cases for CloudWatch Logs Insights

1. **Troubleshooting and Debugging:**
   - Quickly find errors, exceptions, or anomalies in application logs.
   - Example query to find error messages:
     ```sql
     fields @timestamp, @message
     | filter @message like /error/
     | sort @timestamp desc
     ```

2. **Performance Monitoring:**
   - Track performance metrics like response times or request rates from your logs.
   - Example query to calculate average response time:
     ```sql
     stats avg(responseTime) by bin(5m)
     ```

3. **Security Auditing:**
   - Identify suspicious activity or unauthorized access attempts by analyzing CloudTrail logs.

4. **Usage Analytics:**
   - Monitor user behavior and usage patterns by analyzing application logs.

5. **Infrastructure Monitoring:**
   - Track system-level metrics (e.g., CPU usage, memory) by integrating with CloudWatch Logs Agent.

---

### Example Queries in CloudWatch Logs Insights

1. **Find the Most Frequent HTTP Status Codes:**
   ```sql
   stats count(*) by statusCode
   ```

2. **Search for Specific IP Addresses in Logs:**
   ```sql
   fields @timestamp, @message
   | filter @message like "192.168.0.1"
   ```

3. **Count Errors Over Time:**
   ```sql
   filter @message like /ERROR/
   | stats count() by bin(1h)
   ```

4. **Top N Items:**
   - Find the top 5 users accessing an application:
     ```sql
     stats count(*) as accessCount by userId
     | sort accessCount desc
     | limit 5
     ```

---

### Advantages of CloudWatch Logs Insights

- **Cost Efficiency:** Pay only for the queries you run, making it cost-effective for sporadic analysis.
- **Real-Time Analysis:** Analyze log data in near real-time to identify issues faster.
- **Ease of Use:** Intuitive interface and pre-built queries simplify log analysis.
- **Integration:** Works seamlessly with other AWS services and CloudWatch features.

---

### Getting Started with CloudWatch Logs Insights

1. **Access Logs Insights:**
   - Open the **CloudWatch Console**, navigate to **Logs**, and choose **Logs Insights**.

2. **Select a Log Group:**
   - Choose the relevant log group(s) you want to query.

3. **Write a Query:**
   - Use the Logs Insights query language or select from predefined queries.

4. **Run and Analyze:**
   - Execute the query and analyze the results in the interface.

---

### Summary

CloudWatch Logs Insights is a powerful tool for querying and analyzing log data stored in CloudWatch Logs. It provides developers, DevOps teams, and security analysts with the tools needed to troubleshoot, monitor, and optimize applications and infrastructure efficiently. Its scalability and integration with AWS services make it an essential part of log management in AWS environments.


CloudWatch S3 Exports allow you to move CloudWatch Logs to an S3 bucket for long-term storage, analysis, and cost-effective archiving. This feature provides flexibility for processing log data with other AWS services or external tools and is useful for compliance, backup, and sharing log data.



What is CloudWatch Subscription?
CloudWatch Subscription refers to the feature that allows you to stream CloudWatch Logs data in real time to other AWS services, such as Amazon Kinesis, 
AWS Lambda, or Amazon Elasticsearch Service (now Amazon OpenSearch Service). 
This enables you to process log data on the fly, trigger custom actions, or index logs for search and analytics purposes.
CloudWatch Logs subscriptions provide a mechanism to forward log data immediately after it is ingested, enabling real-time analytics, 
monitoring, and event-driven automation.



CloudWatch Aggregation for Multi-Account and Multi-Region
CloudWatch Aggregation refers to the process of collecting and combining monitoring data from multiple accounts and regions into a centralized location for easier analysis and management. In large AWS environments with multiple accounts and regions, aggregation helps to streamline the monitoring process by allowing users to view and analyze metrics, logs, and alarms from different AWS accounts and regions in a unified dashboard.



CloudWatch Agent and CloudWatch Logs Agent
AWS offers multiple ways to collect and send metrics, logs, and other data from your instances and resources to Amazon CloudWatch. 
Two common components used for this purpose are the CloudWatch Agent and the CloudWatch Logs Agent.
These agents help gather system-level metrics (CPU, memory, disk usage, etc.) and log data (application logs, system logs)
from your EC2 instances, on-premises servers, or containers, and send it to CloudWatch for monitoring, storage, and analysis.



CloudWatch Alarms
Amazon CloudWatch Alarms allow you to monitor and respond to changes in your AWS resources and applications. 
Alarms enable you to take automated actions based on metric thresholds, ensuring that you're notified about critical conditions or that you can automatically respond to certain events.
Alarms in Amazon CloudWatch can monitor metrics, and you can set thresholds for when these metrics trigger the alarm. 
Once the alarm state is triggered (either "OK," "ALARM," or "INSUFFICIENT_DATA"), it can take actions such as sending notifications, performing auto-scaling, or even invoking AWS Lambda functions to address the situation.


Amazon CloudWatch Container Insights
Amazon CloudWatch Container Insights, özellikle Amazon ECS (Elastic Container Service), Amazon EKS (Elastic Kubernetes Service), ve Kubernetes ortamlarındaki konteyner tabanlı uygulamalar için bir izleme ve gözlemlenebilirlik çözümüdür. CloudWatch Container Insights, konteynerlerin ve mikroservislerin performansını izlemenizi, sorunları tespit etmenizi ve bu sistemlerin sağlık durumunu anlamanızı sağlar.

Container Insights, konteyner altyapınızla ilgili kapsamlı metrikler, günlükler (logs), ve izlemenin (tracing) birleştirilmesi sayesinde, container tabanlı uygulamaların verimli bir şekilde yönetilmesine olanak tanır.



### Amazon CloudWatch Lambda Insights

**Amazon CloudWatch Lambda Insights**, **AWS Lambda** işlevlerinin performansını izlemek ve hataları tespit etmek için kullanılan bir izleme çözümüdür. Lambda Insights, Lambda işlevlerinin davranışlarını anlamanıza ve bu işlevlerin içindeki uygulama performansını analiz etmenize yardımcı olur. Lambda'nın hızını, kaynak kullanımını, hatalarını ve potansiyel darboğazları belirlemek için güçlü bir gözlemlenebilirlik sağlar.

Lambda Insights, **Amazon CloudWatch** içinde yer alan ve Lambda işlevlerine özel metrikler, günlükler (logs), ve ayrıntılı analizler sunarak, Lambda tabanlı uygulamalarınızın daha iyi yönetilmesini sağlar.

### Temel Özellikler

1. **Lambda İşlevlerinin Derinlemesine İzlenmesi**:
   - CloudWatch Lambda Insights, Lambda işlevlerinizin CPU kullanımı, bellek tüketimi, süre (latency), hata oranları ve daha fazlasını izler.
   - Bu metrikler, Lambda işlevlerinizin ne kadar verimli çalıştığını anlamanıza yardımcı olur.

2. **Özelleştirilmiş Metrikler ve Görselleştirme**:
   - Lambda Insights, her Lambda işlevi için kapsamlı metrikler sunar:
     - **Başarı ve Hata Oranları**: Lambda işlevlerinin başarı ve hata oranlarını takip etmenize olanak tanır.
     - **İşlem Süresi (Latency)**: Lambda işlevlerinizin işleme sürelerini izleyebilirsiniz.
     - **CPU ve Bellek Kullanımı**: Her Lambda işlevinin kullandığı CPU ve bellek kaynakları izlenebilir.

3. **Otomatik İzleme (Auto-Tuning)**:
   - CloudWatch Lambda Insights, Lambda işlevlerinin otomatik olarak doğru kaynakları kullanabilmesi için **otomatik ayarlamalar (auto-tuning)** sağlar. Bu, kaynak tüketimini optimize eder ve potansiyel darboğazları ortadan kaldırır.

4. **Lambda Günlükleri (Logs)**:
   - Lambda işlevlerinin çalıştırma geçmişine dair günlükler toplar ve hataların tespit edilmesine yardımcı olur.
   - Uygulamanın nasıl çalıştığını, hata mesajlarını, çıktıların doğru şekilde alınmadığını veya yanlış parametreler kullanıldığını görmek için bu günlükler üzerinde sorgular çalıştırabilirsiniz.

5. **Gerçek Zamanlı İzleme**:
   - Lambda işlevlerinizin çalıştığı anda gerçek zamanlı olarak performans verilerini toplayabilirsiniz. Bu, hemen müdahale edilmesi gereken sorunların hızla tespit edilmesini sağlar.

6. **Ayrıntılı İzleme ve Analiz**:
   - Lambda Insights, Lambda işlevlerinizdeki kaynak tüketimini ve işlevin geçirdiği süreyi ayrıntılı bir şekilde analiz etmenizi sağlar.
   - **Cold Start (Soğuk Başlangıç)** ve **Warm Start (Sıcak Başlangıç)** süreleri gibi performans detaylarını gösterir.
   - Ayrıca, Lambda işlevinin her bir çağrısının ve her bir iş akışının ne kadar sürdüğünü izleyebilirsiniz.

7. **Kapsamlı Uyarılar ve Alarmlar**:
   - Lambda işlevlerinin performansıyla ilgili belirli eşik değerlerine dayalı alarmlar oluşturabilirsiniz. Örneğin, bir işlevin işlem süresi (latency) belirli bir eşik değeri aşarsa, bir alarm tetiklenebilir.
   - Bu alarmlar, **SNS** bildirimleri veya **Lambda** fonksiyonları gibi çeşitli hedeflere yönlendirilebilir.

8. **Detaylı Hata Raporlaması**:
   - Hatalar, işlevlerin hangi koşullarda başarısız olduğunu gösterir. Bu sayede, Lambda işlevlerinde meydana gelen istisnaları hızlıca tespit edebilir ve çözüm yolları geliştirebilirsiniz.

9. **Kolay Entegrasyon**:
   - Lambda Insights, AWS Lambda işlevlerine entegre edilmesi kolay bir hizmettir. Lambda işlevlerinizi CloudWatch Lambda Insights ile izlemeye başlamak, yalnızca küçük bir yapılandırma ve CloudWatch Agent kurulumu gerektirir.

10. **Lambda ve AWS X-Ray Entegrasyonu**:
    - **AWS X-Ray** ile entegrasyon sayesinde, Lambda işlevlerinin çağrıları arasındaki bağlantıları ve bu çağrıların nasıl dağıldığını izleyebilirsiniz. Bu, dağıtık sistemlerin izlenmesi ve performans sorunlarının giderilmesi için çok faydalıdır.

### Lambda Insights Kullanım Senaryoları

1. **Performans Sorunlarını Tespit Etme**:
   - Lambda işlevlerinin **soğuk başlangıç (cold start)** sürelerinin uzun olduğunu fark edebilirsiniz. CloudWatch Lambda Insights, bu sorunun nereden kaynaklandığını anlamanızı sağlar ve performansı artırmak için önerilerde bulunur.

2. **Kaynak Kullanımını Optimizasyon**:
   - Lambda işlevlerinizin bellek kullanımını izleyerek, fazla bellek tahsis etmenin maliyetini düşürebilirsiniz. CloudWatch Lambda Insights, her işlevin kaynak tüketimini izlemenizi sağlar, böylece optimum kaynak ayarlarına ulaşabilirsiniz.

3. **Uygulama Hatalarının Hızla Tespiti**:
   - Lambda işlevleri hatalı çalıştığında, işlevlerin günlüklerinde hata mesajları görüntülenebilir. Bu, hatanın kaynağını hızlıca bulmanıza ve düzeltmenize yardımcı olur.

4. **Mikroservis Tabanlı Uygulamalarda İzleme**:
   - Lambda tabanlı mikroservislerdeki her bir işlevin performansını ve hatalarını izlemek için Lambda Insights kullanabilirsiniz. Bu sayede, uygulamanızın her bir bileşenini izleyebilir ve hatasız bir deneyim sağlayabilirsiniz.

5. **SLA ve Müşteri Deneyimi Yönetimi**:
   - Lambda işlevlerinizin başarısızlık oranlarını ve yanıt sürelerini izleyerek, **SLA (Service Level Agreement)** hedeflerinizi karşılayıp karşılamadığınızı kontrol edebilirsiniz.

6. **Dağıtık İzleme ve İleri Düzey Sorun Giderme**:
   - AWS X-Ray ile Lambda Insights'i kullanarak, mikroservisler arasında bağlantıları ve gecikmeleri inceleyebilirsiniz. Bu, uygulama genelindeki performans darboğazlarını tespit etmek için kullanılır.

### CloudWatch Lambda Insights’i Başlatmak

1. **Lambda Insights’i Etkinleştirme**:
   - Lambda Insights’i etkinleştirmek için Lambda işlevinizi **CloudWatch Lambda Insights** ile entegre etmeniz gerekir. Bu işlem genellikle AWS Console veya AWS CLI ile yapılabilir.

2. **CloudWatch Agent Kurulumu**:
   - CloudWatch Lambda Insights'i etkinleştirmek için, Lambda işlevlerinize CloudWatch agent'ı yüklemeniz gerekir. Bu işlem genellikle Lambda'nın doğru metrikleri toplamasını sağlar.

3. **Metrik ve Alarmlar**:
   - Lambda işlevinin izlediğiniz metriklerine dayalı alarmlar oluşturabilirsiniz. Örneğin, bir Lambda işlevinin işlem süresi, bellek kullanımı, hata oranı gibi metrikler üzerine alarmlar kurabilirsiniz.

4. **Günlükler (Logs)**:
   - Lambda işlevlerinden gelen günlükleri CloudWatch Logs’ta izleyebilir ve hata raporlarıyla ilgili ayrıntılı bilgi alabilirsiniz.

### CloudWatch Lambda Insights Metrikleri

CloudWatch Lambda Insights, aşağıdaki metrikleri sunar:

1. **Başarı ve Hata Oranı**:
   - Lambda işlevinizin başarılı ve başarısız çalıştırılma oranları.

2. **İşlem Süresi (Latency)**:
   - Lambda işlevlerinin ne kadar süreyle çalıştığını gösteren metrikler.

3. **Soğuk Başlangıç ve Sıcak Başlangıç Süreleri**:
   - Lambda işlevlerinin başlatılma süreleri, özellikle soğuk başlangıç süresi.

4. **Kaynak Kullanımı**:
   - Lambda işlevinizin kullandığı CPU ve bellek gibi kaynaklar.

5. **Hata ve Başarı Günlükleri**:
   - Hatalar ve başarılar için ayrıntılı günlükler.

### Sonuç

**CloudWatch Lambda Insights**, AWS Lambda işlevlerini izlemek ve yönetmek için güçlü bir araçtır. Lambda işlevlerinin performansını izleyerek, hataları tespit edebilir, kaynak kullanımını optimize edebilir ve uygulamanızın genel sağlığını artırabilirsiniz. Lambda Insights, Lambda tabanlı mikroservisler için gözlemlenebilirlik sağlar ve verimli bir uygulama yönetimi için kritik öneme sahiptir.

Amazon CloudWatch Contributor Insights
Amazon CloudWatch Contributor Insights, AWS uygulamalarınızda performans sorunlarını anlamak ve kaynak kullanımını optimize etmek için kullanılan bir izleme aracıdır. Bu hizmet, özellikle büyük miktarda veri veya log kaydına sahip uygulamalarda, hangi bileşenlerin veya kullanıcılardan gelen trafiğin en fazla kaynak kullandığını belirlemenizi sağlar. CloudWatch Contributor Insights, daha derinlemesine analizler yaparak, performans darboğazlarını ve anormallikleri tespit etmek için önemli bilgiler sunar.


Amazon CloudWatch Application Insights
Amazon CloudWatch Application Insights, AWS üzerinde çalışan uygulamaların performansını izlemek, yönetmek ve sorunları hızlı bir şekilde çözmek için kullanılan bir hizmettir. 
CloudWatch Application Insights, özellikle dağıtık uygulamalarda ve çok katmanlı sistemlerde karmaşık olayları ve performans sorunlarını tespit etmeye yardımcı olur. Uygulamanın bileşenlerini anlamak ve uygulama seviyesinde anormallikleri hızlı bir şekilde çözmek için derinlemesine analiz sağlar.
CloudWatch Application Insights, uygulamanın genel sağlığını izleyerek, genellikle Amazon EC2, Amazon RDS, Amazon DynamoDB, Amazon Lambda, Amazon SQS, Amazon SNS, ve Amazon Elastic Load Balancer (ELB) gibi kaynaklarla etkileşen multi-tier (çok katmanlı) uygulamalar için güçlü bir gözlemlenebilirlik sağlar.

*/



resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  version = var.cluster_version
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "eks-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]
}

/*
**Amazon EKS (Elastic Kubernetes Service)** is a fully managed Kubernetes service on **Amazon Web Services (AWS)**. **EKS** simplifies the creation, deployment, and management of Kubernetes clusters. Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications.  

---

### **Key Features of Amazon EKS**
1. **Managed Kubernetes Control Plane**: AWS automatically sets up and manages the Kubernetes control plane (API server, etcd data store).  
2. **Automatic Node Management**: EKS allows you to manage and auto-scale Kubernetes worker nodes.  
3. **High Availability**: EKS runs Kubernetes clusters redundantly across multiple **Availability Zones (AZs)**.  
4. **Integrations**: It provides deep integration with AWS services such as IAM, VPC, ALB, CloudWatch, and EC2 Auto Scaling.  
5. **Security**: EKS enhances security with IAM, Amazon VPC, AWS Shield, and AWS WAF.  
6. **Application Updates**: Applications can be updated continuously, and Kubernetes workloads can be deployed seamlessly.  

---

### **EKS Architecture**
1. **Control Plane**: The AWS-managed Kubernetes API server.  
2. **Worker Nodes**: EC2 instances or AWS Fargate-based containers.  
3. **EKS Cluster**: Represents the Kubernetes cluster, providing access to the API server and worker nodes.  
4. **Pods and Services**: Kubernetes Pods run containers, while Services expose workloads to external clients.  

---

### **Advantages of Amazon EKS**
- **Ease of Management**: AWS manages the Kubernetes control plane.  
- **High Availability and Reliability**: EKS ensures a highly available and secure Kubernetes environment.  
- **Scalability and Flexibility**: EKS supports automatic scaling of applications as workloads increase.  
- **AWS Integrations**: It integrates seamlessly with AWS services, enabling enterprise-grade solutions.  

---

### **How Amazon EKS Works**
1. **Create an EKS Cluster**: Use the AWS Management Console, CLI, or tools like Terraform.  
2. **Add Worker Nodes**: Add EC2 instances or Fargate-based containers.  
3. **Deploy Applications**: Use Kubernetes manifest files (`kubectl apply -f`) to deploy workloads.  
4. **Configure Services and Load Balancing**: Use AWS Load Balancers or Kubernetes services for traffic routing.  
5. **Monitor and Update**: Monitor using CloudWatch and Kubernetes tools, perform updates, and scale as needed.  

Amazon EKS offers a robust, flexible, and scalable Kubernetes solution for modern containerized applications.


**Amazon EKS Control Plane and Data Plane** are essential components of Kubernetes architecture, enabling workload management and application deployment. These two layers form the core infrastructure of Kubernetes operations.  

---

### **1. Control Plane**  
The **Control Plane** is the management layer responsible for overseeing the Kubernetes cluster and controlling the lifecycle of applications. Amazon EKS fully manages the Kubernetes Control Plane, ensuring high availability and reliability.  

#### **Control Plane Components:**  
- **API Server**: Manages all Kubernetes API requests (kubectl commands, SDKs, CLI, etc.).  
- **etcd (Data Store)**: A distributed key-value store that holds all cluster data and configurations.  
- **Scheduler**: Assigns newly created pods to suitable nodes.  
- **Controller Manager**: Runs Kubernetes controllers and ensures pod health.  

#### **Control Plane Features:**  
- Fully managed by AWS.  
- Automatic redundancy and scalability.  
- Distributed across different **Availability Zones (AZs)**.  
- No direct management required from users.  

---

### **2. Data Plane**  
The **Data Plane** consists of the infrastructure that runs Kubernetes workloads (application pods). Users manage the Data Plane directly, which includes Kubernetes nodes.  

#### **Data Plane Components:**  
- **Worker Nodes**: EC2 instances or AWS Fargate containers running application pods.  
- **Kubelet**: A process running on each worker node that monitors pod status and communicates with the Kubernetes API server.  
- **Kube-Proxy**: Manages network rules on each node and routes traffic to pods.  
- **Container Runtime**: Tools like Docker or Containerd used for running and managing containers.  

#### **Data Plane Features:**  
- Runs Kubernetes workloads.  
- Operates on EC2 instances or Fargate containers.  
- Managed by users (node groups, scaling, updates).  
- Supports automatic scaling and load balancing.  

---

### **Control Plane vs. Data Plane Comparison**  

| **Feature**              | **Control Plane**               | **Data Plane**           |
|-------------------------|----------------------------------|--------------------------|
| **Role**                | Manages Kubernetes operations   | Runs workloads           |
| **Components**          | API Server, etcd, Scheduler    | Worker Nodes, Kubelet    |
| **Management**          | Fully managed by AWS            | Managed by users         |
| **Scalability**         | Automatic (AWS-managed)         | Automatic or manual      |
| **Availability**        | Multi-AZ (AWS-managed)          | Managed with EC2 or Fargate |
| **Security**            | IAM, VPC, security groups       | Kubernetes RBAC, node security groups  |

---

### **Summary**  
- **Control Plane** is the management layer running Kubernetes’ administrative components, fully managed by AWS.  
- **Data Plane** runs Kubernetes workloads on EC2 instances or Fargate containers, managed by users.  
- This architecture ensures high availability, automatic scaling, and secure Kubernetes operations.
*/


resource "aws_ecr_repository" "this" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
data "aws_iam_policy_document" "this" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "public_policy" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this.json
}

/*

Amazon Elastic Container Registry (ECR) is a service used for storing, managing, and distributing Docker container images. ECR provides a fully managed Docker container image registry on AWS. With ECR, you can securely store your Docker containers and distribute them to various AWS services (such as ECS, EKS, Lambda) for use.

Some key features of ECR include:

1. **Security:** ECR integrates with IAM (Identity and Access Management) to provide access controls. Container images can only be accessed by authorized users and services.
2. **Integrated CI/CD:** ECR easily integrates with CI/CD tools like Jenkins and GitLab.
3. **High performance:** Since it operates on AWS infrastructure, it provides high performance and low latency.
4. **Version control:** You can switch between different versions of container images.

ECR is an essential tool for teams developing and managing containerized applications.


Here is the translation of the comparison between **Amazon Elastic Container Registry (ECR)** and **Docker Hub** in English:

---

### **Differences Between ECR and Docker Hub:**

1. **Service Provider:**
   - **Docker Hub:** Provided by Docker and is an independent platform.
   - **ECR:** Provided by AWS and works within the AWS ecosystem.

2. **Integration:**
   - **Docker Hub:** Works well with the Docker ecosystem and is compatible with most container platforms.
   - **ECR:** Deeply integrated with AWS services (ECS, EKS, Lambda, etc.).

3. **Security and Access Control:**
   - **Docker Hub:** Provides basic security and access control, but customization options are limited.
   - **ECR:** Offers IAM (Identity and Access Management) integration, enabling more comprehensive and customized access controls.

4. **Customization and Configuration:**
   - **Docker Hub:** More straightforward for general use, with fewer customization options.
   - **ECR:** Provides more configuration and customization options, especially in the AWS ecosystem.

5. **Repository Options:**
   - **Docker Hub:** Offers both public and private repositories.
   - **ECR:** Primarily designed for private repositories and provides advanced security features.

6. **Pricing:**
   - **Docker Hub:** Offers both free and paid plans. The free plan comes with limited private repositories.
   - **ECR:** Follows AWS’s pricing model, where storage and data transfer are charged. It may be more cost-effective for larger-scale projects.

---

### **Advantages and Disadvantages:**

#### **Docker Hub:**

**Advantages:**
- **General Use:** Docker Hub is the official platform for Docker and is widely used by the open-source community.
- **Large Library:** Docker Hub has a large number of ready-to-use container images created by the community, which speeds up development.
- **Simple to Use:** It is user-friendly and easy to set up. It integrates well with Docker CLI and Docker Compose.
- **Community Support:** Docker Hub is supported by a large community and open-source software.

**Disadvantages:**
- **Security:** Docker Hub doesn’t offer as deep security features as ECR. It lacks IAM integration for fine-grained access control.
- **Private Repository Limitations:** The free plan only allows a limited number of private repositories, and there are restrictions in paid plans as well.
- **Performance:** While Docker Hub is widely distributed, it does not offer the same performance and low-latency access as ECR.

#### **ECR:**

**Advantages:**
- **AWS Integration:** ECR is fully integrated with AWS services. It provides seamless integration with ECS, EKS, Lambda, and other AWS services.
- **Advanced Security:** Offers IAM integration, encryption, security scanning, and more advanced security features. AWS VPC integration provides a more secure environment.
- **Performance:** Leverages AWS infrastructure for low latency and high performance.
- **Scalability:** Easily scalable and optimized for large data sets, benefiting from AWS’s infrastructure.

**Disadvantages:**
- **AWS Dependency:** ECR is only integrated with the AWS ecosystem, so it cannot be used independently on other platforms.
- **Pricing Complexity:** AWS’s usage-based pricing model can be cost-effective for small-scale usage but may lead to higher costs for larger projects.
- **Less Community Support:** ECR does not have as large a community as Docker Hub, as it is primarily used by AWS customers.

---

### **Summary:**

- **Docker Hub** is more suitable for general-purpose use and provides wider community support, making it a good option for Docker users.
- **ECR** is more powerful for applications that run on AWS, offering stronger integration, security, and scalability benefits.

If you are working within the AWS ecosystem and need features like security, performance, and deep integration, **ECR** is the better choice. On the other hand, if you need broader use and community support, **Docker Hub** may be more suitable.

*/

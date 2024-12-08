
resource "aws_amplify_app" "example" {
  name       = "example"
  repository = "https://github.com/example/app"

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}

/***What is AWS Amplify?**  

**AWS Amplify** is a platform provided by Amazon Web Services for **developing mobile and web applications**. It helps developers with tasks such as **configuring backend services, connecting applications, and deploying them**. Amplify works seamlessly with popular frontend frameworks like **React, Angular, Vue, and Next.js**.  

### **Key Components of AWS Amplify:**  

1. **Amplify Libraries:**  
   - JavaScript, Android, and iOS libraries that enable AWS service integration on the front end.  
   - Example: Authentication, data storage, API requests.  

2. **Amplify CLI:**  
   - A command-line tool for creating and managing AWS resources.  
   - Example: Adding features like Auth, API, and hosting.  

3. **Amplify Hosting:**  
   - A fully managed service for hosting static web applications and managing CI/CD processes.  
   - It can automatically deploy code from sources like GitHub and Bitbucket.  

4. **Amplify Studio:**  
   - A visual development environment.  
   - It allows integrating application designs directly into code.  

---

### **What Can You Do with AWS Amplify?**  

- **Authentication:** User login and registration using AWS Cognito.  
- **Data Storage:** Managing data with NoSQL database Amazon DynamoDB.  
- **API Management:** Creating GraphQL or REST APIs.  
- **File Storage:** Hosting media files with S3.  
- **Notifications:** Integrating SNS or push notifications.  
- **Hosting and Deployment:** Deploying web and mobile apps globally.  

---

### **Who Can Use AWS Amplify?**  

- **Startups and Entrepreneurs:** For rapid prototyping.  
- **Frontend Developers:** To build applications without configuring backends.  
- **Enterprise Teams:** For projects integrated into the AWS ecosystem.  


*/

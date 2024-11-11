resource "aws_ami_from_instance" "custom_ami" {
  name                    = "CustomAMI-${var.base_instance_id}"
  source_instance_id      = var.base_instance_id
  snapshot_without_reboot = true # It takes snapshot before instance restart.

  tags = {
    Name = "CustomAMI"
  }
}

/*


**AMI (Amazon Machine Image)** is a complete "image" of a virtual machine (EC2 instance) running on AWS, 
which includes the operating system, application software, settings, and data. 
AMIs are used to quickly launch, copy, or scale EC2 instances.

### Contents of an AMI:
An AMI contains the following components:

- **Operating System (OS)**: Linux, Windows, or other operating systems.
- **Applications and Software**: The applications or software that will run on the EC2 instance.
- **Data and Configurations**: Configurations and data stored on the instance.
- **Operating System Configuration**: Kernel settings and system configurations.
- **EBS Volume (Optional)**: An AMI can be stored with an EBS volume, which can also be part of the AMI.

### Types of AMIs:
- **Amazon-provided AMIs**: AMIs provided by AWS, generally preconfigured for basic use. Examples include Amazon Linux, Ubuntu, and Windows Server images.
- **Custom AMIs**: AMIs customized and configured by users according to their specific needs. For example, an AMI with a particular software stack installed.
- **Marketplace AMIs**: AMIs available for purchase from AWS Marketplace, often containing third-party software.

### Use Cases for AMIs:
- **Scalability**: When multiple EC2 instances are needed for an application, the same AMI can be used to quickly create new instances.
- **Backup and Restore**: When an AMI of an EC2 instance is created, an instance with the same configuration can be easily restored using that image.
- **Automation**: AMIs can be used to launch EC2 instances with a specific configuration, simplifying infrastructure automation.
- **Deployment**: AMIs can be used to quickly deploy applications across multiple regions or accounts.

### Benefits of AMIs:
- **Fast Launching**: New EC2 instances can be launched quickly because the AMI brings the operating system and software pre-configured.
- **Reusability**: The same configuration, software stack, or application can be reused, ensuring consistency across environments.
- **Backup and Recovery**: When an AMI of an instance is taken, it can be restored from backups whenever needed.

### Drawbacks of AMIs:
- **Storage Cost**: AMIs are stored in S3, which incurs storage costs. If you have many AMIs, the cost can increase over time.
- **Difficulty in Updates**: If the software within an AMI needs to be updated, a new AMI must be created; it is not possible to update the existing AMI.

### Conclusion:
AMI is a crucial tool for creating, distributing, and managing EC2 instances on AWS. Customized AMIs simplify application deployments, backups, and restores.

---

Let me know if you need any further clarification!

*/

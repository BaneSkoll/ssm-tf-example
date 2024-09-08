
# AWS Infrastructure with VPC Endpoints for SSM Access

This Terraform project sets up AWS infrastructure to enable secure access to EC2 instances via AWS Systems Manager (SSM). By leveraging VPC endpoints, you can connect to instances without opening Security Group (SG) rules for SSH or RDP. This approach enhances security by eliminating the need to expose your instances to the internet.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine.
- AWS credentials configured (`~/.aws/credentials` or through environment variables).
- IAM permissions to create VPC, EC2, and related resources.

## Project Overview

This Terraform configuration will:

- Create a VPC with private and public subnets, internet gateway, NAT gateway, and route tables.
- Set up a VPC endpoint for AWS Systems Manager, allowing SSM to connect to instances privately.
- Launch an EC2 instance within the VPC.
- Configure Security Groups to allow necessary SSM traffic without opening SSH or RDP ports.
- Enable SSM access to the instance, allowing you to connect securely.

## How to Use

### Step 1: Initialize Terraform

Clone this repository and navigate to the project directory. Run the following command to initialize the Terraform project:

```bash
terraform init
```

### Step 2: Review and Modify the Configuration

Review the Terraform configuration files (`main.tf`, `variables.tf`, etc.) to ensure they fit your requirements. Modify the following if needed:

- VPC CIDR ranges
- Subnet CIDR blocks
- EC2 instance type and AMI
- Tags and naming conventions

### Step 3: Apply the Terraform Configuration

Run the following command to create the AWS infrastructure:

```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment. Terraform will provision the resources as defined.

### Step 4: Access Your Instance

Once the resources are created, you can connect to your EC2 instance using AWS Systems Manager Session Manager without exposing SSH or RDP ports. Ensure your IAM user or role has the necessary permissions to use SSM.

### Step 5: Destroy the Infrastructure (Optional but Recommended)

When you are finished, it is important to clean up the resources to avoid unnecessary costs. Destroy the infrastructure using:

```bash
terraform destroy
```

When prompted, type `yes` to confirm the destruction of the resources.

## Important Notes and Warnings

1. **Customization Required**: This Terraform configuration is a template. You must review and modify it to suit your specific needs, such as adjusting instance types, VPC settings, and IAM permissions.

2. **Cost Implications**: Deploying AWS resources will incur costs, especially if instances, VPC endpoints, or other resources are kept running. Make sure to monitor your AWS billing dashboard and destroy the resources when they are no longer needed to avoid unexpected charges.

3. **Security Considerations**: Ensure that only authorized IAM users have permissions to access the SSM service and the created infrastructure. Always follow best practices for AWS security.

## Troubleshooting

- **SSM Connection Issues**: If you cannot connect to your instance via SSM, check that the IAM role attached to the instance has the correct SSM permissions and that the VPC endpoint for SSM is configured properly. [Troubleshooting] (https://docs.aws.amazon.com/systems-manager/latest/userguide/troubleshooting-managed-nodes-using-ssm-cli.html)
- **Terraform Errors**: Ensure you have the latest version of Terraform and that your AWS credentials are correctly configured.

## Support

For issues or questions, please refer to the [Terraform documentation](https://www.terraform.io/docs/) or the [AWS Systems Manager documentation](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html).

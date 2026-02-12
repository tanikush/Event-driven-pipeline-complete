# 🚀 Event-Driven Data Processing Pipeline

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-purple?logo=terraform)](https://www.terraform.io/)
[![Python](https://img.shields.io/badge/Python-3.9-blue?logo=python)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> An automated, serverless data processing pipeline built on AWS that captures incoming data, processes it in real-time, and generates daily summary reports.

## 🏆 Hackathon Submission
* **Track:** General Track (Track 1) 
* **Project Name:** CloudFlow: Event-Driven Automation Pipeline
 — Track 1 
* **Theme Alignment:** This project automates manual data processing workflows using a serverless cloud architecture, directly reducing operational costs and eliminating human error. 
* **Presentation File:** [CloudFlow Event-Driven Automation Pipeline.pdf](https://github.com/user-attachments/files/25252206/CloudFlow.Event-Driven.Automation.Pipeline.pdf)


---

## 📋 Table of Contents
- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Technologies](#-technologies)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Testing](#-testing)
- [Cleanup](#-cleanup)

---

## 🎯 Overview

This project demonstrates a **fully automated event-driven architecture** on AWS that:
- ✅ Automatically processes data files uploaded to S3
- ✅ Stores processed data in DynamoDB
- ✅ Generates daily summary reports
- ✅ Sends notifications via SNS
- ✅ Uses Infrastructure as Code (Terraform)
- ✅ Implements CI/CD best practices

---

## 🏗️ Architecture

![Architecture Diagram](architecture-diagram.png)

---

## 🏗️ Lambda

<img width="1916" height="1020" alt="222" src="https://github.com/user-attachments/assets/adbb719b-fe0b-4f34-aeca-5c917125da65" />

---

## 🏗️ Dynamodb

<img width="1080" height="574" alt="333" src="https://github.com/user-attachments/assets/64117f35-7feb-4495-a3b1-04976e7c7aa4" />

---

## 🏗️ S3

![666](https://github.com/user-attachments/assets/ada6bfc8-5ad5-4f15-906e-8bf00beb6c01)

---

## 🏗️ Terraform Vs Code

<img width="1905" height="986" alt="5555" src="https://github.com/user-attachments/assets/8519cfff-b48d-46bd-92af-99790f0ae9e5" />

---


---

## ✨ Features

- 🔄 **Event-Driven**: Automatic processing on file upload
- ⚡ **Serverless**: No server management required
- 📊 **Automated Reports**: Daily summaries generated automatically
- 💰 **Cost-Effective**: Uses AWS Free Tier services
- 🔧 **Infrastructure as Code**: Fully automated deployment with Terraform
- 🔒 **Secure**: IAM roles with least privilege access
- 📈 **Scalable**: Auto-scales with demand
- 🔍 **Monitored**: CloudWatch logs for debugging

---

## 🛠️ Technologies

| Technology | Purpose |
|------------|----------|
| **AWS Lambda** | Serverless compute for data processing |
| **Amazon S3** | Object storage for incoming data |
| **DynamoDB** | NoSQL database for processed data |
| **EventBridge** | Scheduled daily report generation |
| **SNS** | Email notifications |
| **Terraform** | Infrastructure as Code |
| **Python 3.9** | Lambda function runtime |
| **GitHub Actions** | CI/CD pipeline |

---

## 📦 Prerequisites

Before you begin, ensure you have:

- ✅ AWS Account ([Create Free Account](https://aws.amazon.com/free/))
- ✅ AWS CLI installed and configured
- ✅ Terraform >= 1.0 installed
- ✅ Python 3.9+ installed
- ✅ Git installed

---

## 🚀 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/tanikush/Event-driven-pipeline-complete.git
cd Event-driven-pipeline-complete
```

### Step 2: Configure AWS Credentials

```bash
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1`
- Output format: `json`

### Step 3: Package Lambda Functions

```bash
cd src
zip ../infrastructure/process_data.zip process_data.py
zip ../infrastructure/generate_report.zip generate_report.py
cd ..
```

### Step 4: Deploy Infrastructure

```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted.

---

## 📖 Usage

### Upload Test Data

```bash
aws s3 cp test-data.json s3://YOUR-BUCKET-NAME/
```

### View Lambda Logs

```bash
aws logs tail /aws/lambda/ProcessDataFunction --follow
```

### Check Processed Data

```bash
aws dynamodb scan --table-name ProcessedData
```

### Subscribe to Email Reports

```bash
aws sns subscribe \
  --topic-arn YOUR-SNS-TOPIC-ARN \
  --protocol email \
  --notification-endpoint your-email@example.com
```

Confirm subscription in your email.

### Manually Trigger Report

```bash
aws lambda invoke --function-name GenerateReportFunction response.json
```

---

## 📁 Project Structure

```
Event-driven-pipeline-complete/
├── infrastructure/
│   ├── main.tf              # Terraform configuration
│   ├── process_data.zip     # Lambda deployment package
│   └── generate_report.zip  # Lambda deployment package
├── src/
│   ├── process_data.py      # Data processing Lambda
│   └── generate_report.py   # Report generation Lambda
├── .gitignore               # Git ignore rules
├── test-data.json           # Sample test data
└── README.md                # This file
```

---

## 🧪 Testing

## 🛠️ Technical Challenges & Solutions
* **Challenge (Data Integrity):** Raw JSON data can often be inconsistent or malformed, which can crash databases.
* **Solution:** I implemented a custom validation layer within the AWS Lambda function to verify data structure before it is stored in DynamoDB. 
* **Challenge (Cost Management):** Small businesses often cannot afford 24/7 active servers.
* **Solution:** Used an asynchronous, event-driven model that costs $0 to run on the AWS Free Tier when no data is being processed.





### Test Data Processing

1. Upload test file:
   ```bash
   aws s3 cp test-data.json s3://event-pipeline-data-XXXXX/
   ```

2. Verify in DynamoDB:
   ```bash
   aws dynamodb scan --table-name ProcessedData
   ```

3. Check logs:
   ```bash
   aws logs tail /aws/lambda/ProcessDataFunction
   ```

### Test Report Generation

```bash
aws lambda invoke --function-name GenerateReportFunction output.json
cat output.json
```

---

## 🧹 Cleanup

To avoid AWS charges, destroy all resources:

```bash
cd infrastructure
terraform destroy
```

Type `yes` when prompted.

This will delete:
- S3 bucket and contents
- Lambda functions
- DynamoDB table
- SNS topic
- EventBridge rules
- IAM roles

---

## 📊 AWS Resources Created

| Resource | Name | Purpose |
|----------|------|----------|
| S3 Bucket | `event-pipeline-data-*` | Data storage |
| Lambda | `ProcessDataFunction` | Process incoming data |
| Lambda | `GenerateReportFunction` | Generate daily reports |
| DynamoDB | `ProcessedData` | Store processed records |
| SNS Topic | `daily-report` | Email notifications |
| EventBridge | `daily-report-schedule` | Daily trigger at 9 AM |
| IAM Role | `lambda_execution_role` | Lambda permissions |

---

## 💰 Cost Estimation

**All services used are within AWS Free Tier:**

- Lambda: 1M requests/month (Free)
- S3: 5GB storage (Free)
- DynamoDB: 25GB storage (Free)
- SNS: 1,000 emails/month (Free)
- EventBridge: Always free

**Estimated Monthly Cost: $0.00** ✅

---

## 🔒 Security Best Practices

- ✅ IAM roles with least privilege
- ✅ No hardcoded credentials
- ✅ Encrypted data at rest (S3, DynamoDB)
- ✅ CloudWatch logging enabled
- ✅ VPC endpoints (optional enhancement)

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License.

---

## 👤 Author

**Tanisha Kushwah**
- GitHub: [@tanikush](https://github.com/tanikush)

---

## 🙏 Acknowledgments

- AWS Documentation
- Terraform Documentation
- DevOps Community

---

## 📞 Support

If you have questions or issues:
- Open an [Issue](https://github.com/tanikush/Event-driven-pipeline-complete/issues)
- Check [AWS Documentation](https://docs.aws.amazon.com/)

---

⭐ **If you found this project helpful, please give it a star!** ⭐

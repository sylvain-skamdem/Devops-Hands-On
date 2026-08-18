# AWS Application Load Balancer
*3 Ubuntu EC2 Instances — CloudFormation IaC Deployment*

| | |
|---|---|
| **Student Name** | Sylvain Simo Kamdem |
| **Course** | UCT Cloud / DevOps Bootcamp |
| **Instructor** | Valery Nyandja |
| **Assignment** | AWS ALB with 3 Ubuntu EC2 Instances |
| **IaC Tool** | AWS CloudFormation (JSON) |
| **AWS Region** | us-east-1 (N. Virginia) |
| **Date Submitted** | August 6, 2026 |

*Conceptix Innovations LLC | Oak Lawn, IL*

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Prerequisites](#2-prerequisites)
3. [CloudFormation Template](#3-cloudformation-template)
4. [Deployment Steps](#4-deployment-steps)
5. [Validation — Verify Load Balancing in Browser](#5-validation--verify-load-balancing-in-browser)
6. [AWS Resource Summary](#6-aws-resource-summary)
7. [Cleanup — Delete the Stack](#7-cleanup--delete-the-stack)
8. [Lessons Learned](#8-lessons-learned)
9. [Conclusion](#9-conclusion)

---

## 1. Project Overview

This document records the deployment of a highly available web application on AWS using AWS CloudFormation as the Infrastructure as Code (IaC) tool. The architecture consists of three Ubuntu EC2 instances running Apache web servers, placed behind an Application Load Balancer (ALB). Traffic from users is distributed across all three instances, and each instance serves a unique message so that load balancing behavior can be verified directly in a browser.

All infrastructure was defined in a single CloudFormation JSON template and deployed through the AWS Management Console — no manual resource creation required.

### 1.1 What is an Application Load Balancer?

An Application Load Balancer (ALB) is an AWS managed service that receives incoming HTTP/HTTPS traffic and distributes it across a pool of backend servers called a Target Group. Key benefits include:

- **High availability** — traffic is spread across multiple servers and Availability Zones
- **Health checks** — the ALB automatically stops sending traffic to unhealthy instances
- **Single entry point** — users only need one URL (the ALB DNS name), never individual server IPs
- **Scalability** — add or remove instances from the target group without downtime

### 1.2 What is CloudFormation?

AWS CloudFormation is a native AWS IaC service. Instead of clicking through the Console to create resources one by one, you write a JSON or YAML template that describes the entire infrastructure, and CloudFormation provisions all resources as a single unit called a Stack. Key concepts used in this lab:

| Concept | What it does |
|---|---|
| **Stack** | The deployed instance of a template — all resources created together and managed as one unit |
| **Template** | The JSON or YAML file that describes every AWS resource to create |
| **Parameters** | User-supplied inputs at stack creation time — makes templates reusable without editing code |
| **Resources** | The core section — declares every AWS resource (EC2, SG, ALB, etc.) to be created |
| **Outputs** | Values CloudFormation exposes after stack creation, such as the ALB DNS name |
| **Fn::Base64** | CloudFormation function that Base64-encodes the UserData script, required by EC2 |
| **Fn::Sub** | Substitutes variable references (`${Param}`) into strings at deploy time |
| **Fn::GetAtt** | Retrieves an attribute of a created resource, such as the ALB's DNSName |
| **DependsOn** | Forces a resource to wait until another is fully created before starting |
| **CREATE_COMPLETE** | Stack status confirming all resources were provisioned successfully |

### 1.3 CloudFormation vs Terraform — Key Differences

| Aspect | CloudFormation | Terraform |
|---|---|---|
| **Provider** | AWS native — no install needed | Third-party — requires install |
| **Language** | JSON or YAML | `.tf` (HCL) files |
| **State file** | Managed by AWS automatically | Local `.tfstate` file (must manage) |
| **Rollback** | Automatic on failure | Manual cleanup required |
| **Console UI** | Full console integration | CLI only |
| **Multi-cloud** | AWS only | AWS, Azure, GCP, and more |
| **Cost** | Free (pay for resources only) | Free (OSS); paid enterprise tiers |

### 1.4 Architecture Diagram

The following diagram illustrates the deployed architecture:

```
                         Internet / Browser
                                 │
                             HTTP :80
                                 │
              Application Load Balancer (ALBResource)
                     ╱            │            ╲
              WebServer1     WebServer2     WebServer3
             (us-east-1a)   (us-east-1b)   (us-east-1b)
             Apache│Server1 Apache│Server2 Apache│Server3
                     ╲            │            ╱
                WebTargetGroup (HTTP :80, health check /)

         LabVPC — us-east-1 — CloudFormation Stack: alb-lab-cfn
```

---

## 2. Prerequisites

- AWS account with permissions for EC2, VPC, ELB, and CloudFormation
- An existing EC2 key pair in us-east-1 (for SSH access to instances if needed)
- AWS Management Console access — no CLI or local tools required for CloudFormation
- The CloudFormation template JSON file saved locally (created in Section 3 below)

> 📝 **Note:** Unlike Terraform, CloudFormation requires no local installation. The entire deployment happens through the AWS Console by uploading the JSON template file.

---

## 3. CloudFormation Template

The entire infrastructure is defined in a single JSON file, organized into three logical sections: **Parameters** (user inputs), **Resources** (AWS infrastructure — VPC/networking, security groups, EC2 instances, and the ALB/target group/listener), and **Outputs** (the ALB URL and instance IPs). Save the template below as `alb-lab.json` on your local machine.

```json
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "ALB with 3 Ubuntu EC2 Instances — UCT Lab",
  "Parameters": {
    "KeyName": {
      "Type": "AWS::EC2::KeyPair::KeyName",
      "Description": "EC2 key pair for SSH access to the web servers"
    },
    "InstanceType": {
      "Type": "String",
      "Default": "t3.micro",
      "AllowedValues": ["t2.micro", "t3.micro", "t3.small"],
      "Description": "EC2 instance size for all three web servers"
    },
    "UbuntuAmi": {
      "Type": "String",
      "Default": "ami-0c7217cdde317cfec",
      "Description": "Ubuntu 22.04 LTS AMI ID for us-east-1"
    }
  },
  "Resources": {
    "LabVPC": {
      "Type": "AWS::EC2::VPC",
      "Properties": {
        "CidrBlock": "10.0.0.0/16",
        "EnableDnsHostnames": true,
        "EnableDnsSupport": true,
        "Tags": [{ "Key": "Name", "Value": "alb-lab-vpc" }]
      }
    },
    "InternetGateway": {
      "Type": "AWS::EC2::InternetGateway",
      "Properties": {
        "Tags": [{ "Key": "Name", "Value": "alb-lab-igw" }]
      }
    },
    "VPCGatewayAttachment": {
      "Type": "AWS::EC2::VPCGatewayAttachment",
      "Properties": {
        "VpcId": { "Ref": "LabVPC" },
        "InternetGatewayId": { "Ref": "InternetGateway" }
      }
    },
    "PublicSubnetA": {
      "Type": "AWS::EC2::Subnet",
      "Properties": {
        "VpcId": { "Ref": "LabVPC" },
        "CidrBlock": "10.0.1.0/24",
        "AvailabilityZone": "us-east-1a",
        "MapPublicIpOnLaunch": true,
        "Tags": [{ "Key": "Name", "Value": "alb-lab-subnet-a" }]
      }
    },
    "PublicSubnetB": {
      "Type": "AWS::EC2::Subnet",
      "Properties": {
        "VpcId": { "Ref": "LabVPC" },
        "CidrBlock": "10.0.2.0/24",
        "AvailabilityZone": "us-east-1b",
        "MapPublicIpOnLaunch": true,
        "Tags": [{ "Key": "Name", "Value": "alb-lab-subnet-b" }]
      }
    },
    "PublicRouteTable": {
      "Type": "AWS::EC2::RouteTable",
      "Properties": {
        "VpcId": { "Ref": "LabVPC" },
        "Tags": [{ "Key": "Name", "Value": "alb-lab-rt" }]
      }
    },
    "DefaultRoute": {
      "Type": "AWS::EC2::Route",
      "DependsOn": "VPCGatewayAttachment",
      "Properties": {
        "RouteTableId": { "Ref": "PublicRouteTable" },
        "DestinationCidrBlock": "0.0.0.0/0",
        "GatewayId": { "Ref": "InternetGateway" }
      }
    },
    "SubnetARouteAssoc": {
      "Type": "AWS::EC2::SubnetRouteTableAssociation",
      "Properties": {
        "SubnetId": { "Ref": "PublicSubnetA" },
        "RouteTableId": { "Ref": "PublicRouteTable" }
      }
    },
    "SubnetBRouteAssoc": {
      "Type": "AWS::EC2::SubnetRouteTableAssociation",
      "Properties": {
        "SubnetId": { "Ref": "PublicSubnetB" },
        "RouteTableId": { "Ref": "PublicRouteTable" }
      }
    },
    "ALBSecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow HTTP from internet to ALB",
        "VpcId": { "Ref": "LabVPC" },
        "SecurityGroupIngress": [{
          "IpProtocol": "tcp", "FromPort": 80, "ToPort": 80,
          "CidrIp": "0.0.0.0/0"
        }],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-alb-sg" }]
      }
    },
    "EC2SecurityGroup": {
      "Type": "AWS::EC2::SecurityGroup",
      "Properties": {
        "GroupDescription": "Allow HTTP from ALB SG only; SSH from anywhere",
        "VpcId": { "Ref": "LabVPC" },
        "SecurityGroupIngress": [
          {
            "IpProtocol": "tcp", "FromPort": 80, "ToPort": 80,
            "SourceSecurityGroupId": { "Ref": "ALBSecurityGroup" }
          },
          {
            "IpProtocol": "tcp", "FromPort": 22, "ToPort": 22,
            "CidrIp": "0.0.0.0/0"
          }
        ],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-ec2-sg" }]
      }
    },
    "WebServer1": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "ImageId": { "Ref": "UbuntuAmi" },
        "InstanceType": { "Ref": "InstanceType" },
        "KeyName": { "Ref": "KeyName" },
        "SubnetId": { "Ref": "PublicSubnetA" },
        "SecurityGroupIds": [{ "Ref": "EC2SecurityGroup" }],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-server-1" }],
        "UserData": {
          "Fn::Base64": {
            "Fn::Sub": "#!/bin/bash\napt-get update -y\napt-get install -y apache2\nsystemctl start apache2\nsystemctl enable apache2\necho '<html><body style=\"font-family:Arial;padding:40px;\"><h1>Hello from Server 1</h1><p>AZ: us-east-1a</p><p>Host: $(hostname)</p></body></html>' > /var/www/html/index.html\n"
          }
        }
      }
    },
    "WebServer2": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "ImageId": { "Ref": "UbuntuAmi" },
        "InstanceType": { "Ref": "InstanceType" },
        "KeyName": { "Ref": "KeyName" },
        "SubnetId": { "Ref": "PublicSubnetB" },
        "SecurityGroupIds": [{ "Ref": "EC2SecurityGroup" }],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-server-2" }],
        "UserData": {
          "Fn::Base64": {
            "Fn::Sub": "#!/bin/bash\napt-get update -y\napt-get install -y apache2\nsystemctl start apache2\nsystemctl enable apache2\necho '<html><body style=\"font-family:Arial;padding:40px;\"><h1>Hello from Server 2</h1><p>AZ: us-east-1b</p><p>Host: $(hostname)</p></body></html>' > /var/www/html/index.html\n"
          }
        }
      }
    },
    "WebServer3": {
      "Type": "AWS::EC2::Instance",
      "Properties": {
        "ImageId": { "Ref": "UbuntuAmi" },
        "InstanceType": { "Ref": "InstanceType" },
        "KeyName": { "Ref": "KeyName" },
        "SubnetId": { "Ref": "PublicSubnetB" },
        "SecurityGroupIds": [{ "Ref": "EC2SecurityGroup" }],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-server-3" }],
        "UserData": {
          "Fn::Base64": {
            "Fn::Sub": "#!/bin/bash\napt-get update -y\napt-get install -y apache2\nsystemctl start apache2\nsystemctl enable apache2\necho '<html><body style=\"font-family:Arial;padding:40px;\"><h1>Hello from Server 3</h1><p>AZ: us-east-1b (backup)</p><p>Host: $(hostname)</p></body></html>' > /var/www/html/index.html\n"
          }
        }
      }
    },
    "WebTargetGroup": {
      "Type": "AWS::ElasticLoadBalancingV2::TargetGroup",
      "Properties": {
        "Name": "alb-lab-tg",
        "Port": 80,
        "Protocol": "HTTP",
        "VpcId": { "Ref": "LabVPC" },
        "TargetType": "instance",
        "HealthCheckPath": "/",
        "HealthCheckProtocol": "HTTP",
        "HealthCheckIntervalSeconds": 30,
        "HealthCheckTimeoutSeconds": 5,
        "HealthyThresholdCount": 2,
        "UnhealthyThresholdCount": 2,
        "Matcher": { "HttpCode": "200" },
        "Targets": [
          { "Id": { "Ref": "WebServer1" }, "Port": 80 },
          { "Id": { "Ref": "WebServer2" }, "Port": 80 },
          { "Id": { "Ref": "WebServer3" }, "Port": 80 }
        ],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-tg" }]
      }
    },
    "ALBResource": {
      "Type": "AWS::ElasticLoadBalancingV2::LoadBalancer",
      "Properties": {
        "Name": "alb-lab-alb",
        "Scheme": "internet-facing",
        "Type": "application",
        "SecurityGroups": [{ "Ref": "ALBSecurityGroup" }],
        "Subnets": [
          { "Ref": "PublicSubnetA" },
          { "Ref": "PublicSubnetB" }
        ],
        "Tags": [{ "Key": "Name", "Value": "alb-lab-alb" }]
      }
    },
    "ALBListener": {
      "Type": "AWS::ElasticLoadBalancingV2::Listener",
      "Properties": {
        "LoadBalancerArn": { "Ref": "ALBResource" },
        "Port": 80,
        "Protocol": "HTTP",
        "DefaultActions": [{
          "Type": "forward",
          "TargetGroupArn": { "Ref": "WebTargetGroup" }
        }]
      }
    }
  },
  "Outputs": {
    "ALBWebsiteURL": {
      "Description": "Open this URL in a browser to verify load balancing",
      "Value": {
        "Fn::Join": ["", ["http://", { "Fn::GetAtt": ["ALBResource", "DNSName"] }]]
      }
    },
    "WebServer1IP": {
      "Description": "Public IP of Server 1",
      "Value": { "Fn::GetAtt": ["WebServer1", "PublicIp"] }
    },
    "WebServer2IP": {
      "Description": "Public IP of Server 2",
      "Value": { "Fn::GetAtt": ["WebServer2", "PublicIp"] }
    },
    "WebServer3IP": {
      "Description": "Public IP of Server 3",
      "Value": { "Fn::GetAtt": ["WebServer3", "PublicIp"] }
    }
  }
}
```

---

## 4. Deployment Steps

All steps are performed in the AWS Management Console. Save the full JSON template from Section 3 as `alb-lab.json` on your local machine before starting.

1. **Open CloudFormation in the AWS Console** — Go to **Services > CloudFormation**. Confirm the region selector in the top-right shows `us-east-1`.
2. **Click Create Stack > With new resources (standard)** — This opens the stack creation wizard.
3. **Upload the template file** — Select **Upload a template file**. Click **Choose file** and select `alb-lab.json` from your computer. Click **Next**.
4. **Fill in the Stack name and Parameters** — Stack name: `alb-lab-cfn`. Fill in `KeyName` (select your key pair from the dropdown), `InstanceType` (t3.micro default), and `UbuntuAmi` (leave default). Click **Next**.
5. **Accept defaults on Configure stack options** — Leave all options at their defaults. Scroll to the bottom and click **Next**.
6. **Review and Submit** — Review all parameters and resource list on the summary screen. Click **Submit**. The stack status changes to `CREATE_IN_PROGRESS`.
7. **Wait for CREATE_COMPLETE** — Refresh the Events tab periodically. The full stack takes approximately 5–8 minutes — EC2 instances must boot and run the UserData script before Apache is ready. Status will show `CREATE_COMPLETE` when done.
8. **Copy the ALBWebsiteURL from the Outputs tab** — Click the Outputs tab. Copy the `ALBWebsiteURL` value — this is the URL for browser validation.
9. **Wait for health checks to pass** — Wait 2–3 additional minutes for Apache to finish installing. In **EC2 > Target Groups > alb-lab-tg > Targets**, all three instances must show "healthy" before the ALB forwards traffic.

---

## 5. Validation — Verify Load Balancing in Browser

Open the `ALBWebsiteURL` from the CloudFormation Outputs tab in a web browser. Each refresh may show a different server message, confirming the ALB is distributing traffic across all three Ubuntu EC2 instances.

> 📝 **Note:** Browsers cache connections aggressively. If the same server message appears on every refresh, try opening the URL in a private/incognito window, or use Ctrl+Shift+R (hard refresh) to bypass the connection cache.

### 5.1 Browser Verification

- Open `http://[ALBWebsiteURL]` in a browser
- First load: "Hello from Server 1" — us-east-1a
- Refresh: "Hello from Server 2" — us-east-1b
- Refresh again: "Hello from Server 3" — us-east-1b (backup)
- Each response confirms which EC2 instance handled the request

### 5.2 Console Verification

- **EC2 > Load Balancers** — ALBResource shows state "active"
- **EC2 > Target Groups > alb-lab-tg > Targets** — all 3 instances show "healthy"
- **EC2 > Instances** — all 3 instances in "running" state: alb-lab-server-1, server-2, server-3
- **CloudFormation > Stacks** — alb-lab-cfn shows `CREATE_COMPLETE`

---

## 6. AWS Resource Summary

CloudFormation created the following resources in `us-east-1` as part of the `alb-lab-cfn` stack. All resources are tagged with the `alb-lab` prefix.

| CloudFormation Resource | AWS Name / Tag | Details |
|---|---|---|
| LabVPC | alb-lab-vpc | 10.0.0.0/16, DNS enabled |
| InternetGateway | alb-lab-igw | Attached to LabVPC |
| VPCGatewayAttachment | (auto) | Links IGW to VPC |
| PublicSubnetA | alb-lab-subnet-a | 10.0.1.0/24 — us-east-1a |
| PublicSubnetB | alb-lab-subnet-b | 10.0.2.0/24 — us-east-1b |
| PublicRouteTable | alb-lab-rt | Default route → IGW |
| SubnetARouteAssoc | (auto) | Associates subnet-a to route table |
| SubnetBRouteAssoc | (auto) | Associates subnet-b to route table |
| DefaultRoute | (auto) | 0.0.0.0/0 → InternetGateway |
| ALBSecurityGroup | alb-lab-alb-sg | Inbound HTTP :80 from internet |
| EC2SecurityGroup | alb-lab-ec2-sg | HTTP from ALB SG; SSH :22 |
| WebServer1 | alb-lab-server-1 | t3.micro, us-east-1a, Apache |
| WebServer2 | alb-lab-server-2 | t3.micro, us-east-1b, Apache |
| WebServer3 | alb-lab-server-3 | t3.micro, us-east-1b, Apache |
| WebTargetGroup | alb-lab-tg | HTTP :80, health check /, 3 targets |
| ALBResource | alb-lab-alb | Internet-facing ALB, 2 subnets |
| ALBListener | (auto) | HTTP :80 → forward to alb-lab-tg |

---

## 7. Cleanup — Delete the Stack

When the lab is complete, delete the CloudFormation stack to remove all resources and stop incurring charges. CloudFormation deletes every resource it created, in the correct dependency order, automatically.

1. **Open CloudFormation > Stacks** — Select the `alb-lab-cfn` stack from the list.
2. **Click Delete** — Click the Delete button in the top-right. Confirm the deletion when prompted.
3. **Wait for DELETE_COMPLETE** — The stack status changes to `DELETE_IN_PROGRESS`. All 17 resources are deleted in order. This takes approximately 3–5 minutes.

> 📝 **Note:** If the stack gets stuck on `DELETE_FAILED`, check **EC2 > Network Interfaces** for any leftover ENIs attached to the ALB security group, detach them manually, then retry the stack deletion.

---

## 8. Lessons Learned

- **CloudFormation manages the full resource lifecycle.** Creating 17 interconnected AWS resources with a single JSON file — and deleting all of them with one click — shows the power of treating infrastructure as code.
- **DependsOn is critical for routing.** The `DefaultRoute` resource depends on `VPCGatewayAttachment` because the IGW must be attached to the VPC before a route to it can be created. Without `DependsOn`, CloudFormation might try to create the route before the attachment is ready and fail.
- **Security group chaining is a best practice.** The EC2 security group allows HTTP only from the ALB security group (not `0.0.0.0/0`), meaning the web servers are unreachable directly from the internet — traffic must flow through the ALB. This is the correct production pattern.
- **ALBs require at least two subnets in different AZs.** This is a hard AWS requirement. Subnets in us-east-1a and us-east-1b were created to meet it, which also provides genuine high availability.
- **Health checks bridge the gap between stack creation and traffic routing.** CloudFormation marks the stack `CREATE_COMPLETE` as soon as resources exist, but Apache may still be installing. Waiting for all targets to show "healthy" in the Target Group ensures the ALB is actually ready to serve traffic.
- **CloudFormation vs Terraform** — the main practical difference in this lab was simplicity: CloudFormation required only the Console and one JSON file. No local tools, no state file management, no init/plan/apply cycle. For AWS-only projects, CloudFormation is often the faster path.

---

## 9. Conclusion

The lab was completed successfully using AWS CloudFormation. Three Ubuntu EC2 instances running Apache were deployed behind an Application Load Balancer through a single JSON template uploaded to the CloudFormation console. Each instance serves a unique HTML page, and refreshing the ALB URL in a browser shows different server messages — confirming that load balancing is working correctly across all three backends in two Availability Zones.

Compared to the Terraform version of this same lab, CloudFormation required no local tooling, no state file management, and offered automatic rollback on failure — benefits that make it a strong choice for AWS-native teams. The same architecture, the same result, achieved through a different but equally valid Infrastructure as Code approach.

---

**Sylvain Simo Kamdem**
*August 6, 2026*

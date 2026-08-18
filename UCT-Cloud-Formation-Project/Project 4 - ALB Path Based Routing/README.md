# AWS Application Load Balancer — Path-Based Routing (AWS Console Lab)

| | |
|---|---|
| **Student Name** | Sylvain Simo Kamdem |
| **Course** | UCT Cloud / DevOps Bootcamp |
| **Instructor** | Valery Nyandja |
| **Assignment** | Configure AWS ALB with Path-Based Routing |
| **AWS Region** | us-east-1 |
| **Date** | August 11, 2026 |

---

## 1. Overview

This lab deploys four Ubuntu EC2 instances behind a single Application Load Balancer. The ALB uses path-based routing rules to direct `/app1` requests to two App1 servers and `/app2` requests to two App2 servers — both accessible through one DNS endpoint.

```
Browser → http://[ALB-DNS]/app1 or /app2
              │
              ▼
   Application Load Balancer (1 DNS, port 80)
        ↙ /app1*         /app2* ↘
 TG-App1                       TG-App2
(app1-server-1,               (app2-server-1,
 app1-server-2)                app2-server-2)
```

---

## 2. Step 1 — VPC & Network

**1.** Go to **VPC Console → Create VPC → select "VPC and more"**

> ▶ *Services → VPC → Your VPCs → Create VPC*

| Setting | Value |
|---|---|
| **Name tag** | alb-path-lab |
| **IPv4 CIDR** | 10.0.0.0/16 |
| **AZs** | 2 |
| **Public subnets** | 2 (one per AZ) |
| **Private subnets** | 0 |
| **NAT / Endpoints** | None |

**2.** Click **Create VPC** — wait for all resources to show **Created**

![VPC creation](media/image1.png)

---

## 3. Step 2 — Security Groups

> ▶ *VPC Console → Security Groups → Create security group*

### ALB Security Group

| Setting | Value |
|---|---|
| **Name** | alb-path-lab-alb-sg |
| **VPC** | alb-path-lab-vpc |
| **Inbound** | HTTP \| TCP \| 80 \| 0.0.0.0/0 |

### EC2 Security Group

| Setting | Value |
|---|---|
| **Name** | alb-path-lab-ec2-sg |
| **VPC** | alb-path-lab-vpc |
| **Inbound rule 1** | HTTP \| TCP \| 80 \| Source: alb-path-lab-alb-sg |
| **Inbound rule 2** | SSH \| TCP \| 22 \| 0.0.0.0/0 |

![Security groups](media/image2.png)

---

## 4. Step 3 — Launch 4 EC2 Instances

> ▶ *EC2 Console → Instances → Launch Instances*

Launch all four instances with these base settings, changing only **Name** and **Subnet** per server:

| Setting | Value |
|---|---|
| **AMI** | Ubuntu Server 26.04 LTS |
| **Instance type** | t3.micro |
| **Key pair** | your existing key pair |
| **Security group** | alb-path-lab-ec2-sg |
| **Auto-assign Public IP** | Enable |

| Instance Name | Subnet / AZ | App | User Data script |
|---|---|---|---|
| app1-server-1 | public-subnet-a (1a) | App1 | app1 script below |
| app1-server-2 | public-subnet-b (1b) | App1 | app1 script below |
| app2-server-1 | public-subnet-a (1a) | App2 | app2 script below |
| app2-server-2 | public-subnet-b (1b) | App2 | app2 script below |

Paste the correct User Data in the **Advanced details → User Data** field when launching each instance:

#### App1 User Data — paste for app1-server-1 and app1-server-2

```bash
#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
mkdir -p /var/www/html/app1
cat > /var/www/html/app1/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Application 1</title>
<style>
body{
  font-family: Arial, sans-serif;
  text-align:center;
  margin-top:100px;
  background-color:#e8f4fd;
}
.container{
  width:60%;
  margin:auto;
  padding:30px;
  background:white;
  border-radius:10px;
  box-shadow:0px 0px 10px gray;
}
h1{
  color:#0078d7;
}
</style>
</head>
<body>
<div class="container">
<h1>Welcome to Application 1</h1>
<h2>Path Accessed: /app1</h2>
<p>This request was routed by AWS ALB using Path-Based Routing.</p>
<p><strong>Target Group:</strong> TG-App1</p>
</div>
</body>
</html>
EOF
```

#### App2 User Data — paste for app2-server-1 and app2-server-2

```bash
#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
mkdir -p /var/www/html/app2
cat > /var/www/html/app2/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Application 2</title>
<style>
body{
  font-family: Arial, sans-serif;
  text-align:center;
  margin-top:100px;
  background-color:#fef3e2;
}
.container{
  width:60%;
  margin:auto;
  padding:30px;
  background:white;
  border-radius:10px;
  box-shadow:0px 0px 10px gray;
}
h1{
  color:#ff6b00;
}
</style>
</head>
<body>
<div class="container">
<h1>Welcome to Application 2</h1>
<h2>Path Accessed: /app2</h2>
<p>This request was routed by AWS ALB using Path-Based Routing.</p>
<p><strong>Target Group:</strong> TG-App2</p>
</div>
</body>
</html>
EOF
```

![EC2 instance launch](media/image3.png)

---

## 5. Step 4 — Create Target Groups

> ▶ *EC2 Console → Load Balancing → Target Groups → Create target group*

### TG-App1

| Setting | Value |
|---|---|
| **Name** | TG-App1 |
| **Protocol / Port** | HTTP / 80 |
| **VPC** | alb-path-lab-vpc |
| **Health check path** | /app1/index.html |
| **Targets to register** | app1-server-1 and app1-server-2 |

### TG-App2

| Setting | Value |
|---|---|
| **Name** | TG-App2 |
| **Protocol / Port** | HTTP / 80 |
| **VPC** | alb-path-lab-vpc |
| **Health check path** | /app2/index.html |
| **Targets to register** | app2-server-1 and app2-server-2 |

![Target groups](media/image4.png)

---

## 6. Step 5 — Create the Application Load Balancer

> ▶ *EC2 Console → Load Balancing → Load Balancers → Create load balancer → Application Load Balancer*

| Setting | Value |
|---|---|
| **Name** | alb-path-lab-alb |
| **Scheme** | Internet-facing |
| **IP type** | IPv4 |
| **VPC** | alb-path-lab-vpc |
| **Mappings** | us-east-1a → public-subnet-a \| us-east-1b → public-subnet-b |
| **Security group** | alb-path-lab-alb-sg (remove the default) |
| **Listener** | HTTP : 80 → default action: Forward to TG-App1 (temporary) |

**1.** Click **Create load balancer** — wait for **State: active**

**2.** Record the ALB DNS name from the **Details** tab:
**`alb-path-lab-alb-32948137.us-east-1.elb.amazonaws.com`**

![ALB creation](media/image5.png)

---

## 7. Step 6 — Add Path-Based Listener Rules

> ▶ *EC2 → Load Balancers → alb-path-lab-alb → Listeners and rules tab → HTTP:80 → Manage rules → Add rule*

### Rule 1 — `/app1` → TG-App1

| Setting | Value |
|---|---|
| **Rule name** | rule-app1 |
| **Priority** | 1 |
| **Condition** | Path is /app1* |
| **Action** | Forward to → TG-App1 |

### Rule 2 — `/app2` → TG-App2

| Setting | Value |
|---|---|
| **Rule name** | rule-app2 |
| **Priority** | 2 |
| **Condition** | Path is /app2* |
| **Action** | Forward to → TG-App2 |

### Default Rule — No path match

| Setting | Value |
|---|---|
| **Action** | Return fixed response |
| **Response code** | 404 |
| **Response body** | Page not found. Use /app1 or /app2 |

![Listener rules](media/image6.png)

---

## 8. Step 7 — Verify Health & Test in Browser

### 8.1 Verify Target Health

> ▶ *EC2 → Target Groups → select TG-App1 → Targets tab*

Both targets must show **Status: healthy** before testing. Repeat for TG-App2.

![TG-App1 health](media/image7.png)
![TG-App2 health](media/image8.png)

### 8.2 Browser Tests

Copy the ALB DNS name from **EC2 → Load Balancers → Details** tab, then test all three URLs:

| URL | Expected Result | Rule triggered |
|---|---|---|
| `http://alb-path-lab-alb-32948137.us-east-1.elb.amazonaws.com/app1/` | App1 HTML page loads | rule-app1 → TG-App1 |
| `http://alb-path-lab-alb-32948137.us-east-1.elb.amazonaws.com/app2/` | App2 HTML page loads | rule-app2 → TG-App2 |
| `http://alb-path-lab-alb-32948137.us-east-1.elb.amazonaws.com/` | 404 fixed response | Default rule |

![App1 test result](media/image9.png)
![App2 test result](media/image10.png)

> 📝 **Note:** If the same server responds on every refresh, open an incognito window or use `Ctrl+Shift+R` to bypass browser cache.

---

## 9. Cleanup

Delete resources in this order to avoid dependency errors:

| # | Resource | Console Path |
|---|---|---|
| 1 | Application Load Balancer | EC2 → Load Balancers → Actions → Delete |
| 2 | Target Groups (TG-App1, TG-App2) | EC2 → Target Groups → Actions → Delete |
| 3 | EC2 Instances (all 4) | EC2 → Instances → Instance State → Terminate |
| 4 | Security Groups (both) | VPC → Security Groups → Actions → Delete |
| 5 | VPC | VPC → Your VPCs → Actions → Delete VPC |

---

## 10. Summary

The ALB path-based routing lab was completed successfully through the AWS Console. Key outcomes:

- 1 ALB with a single DNS endpoint serving both applications
- 2 listener rules routing `/app1` and `/app2` to separate target groups
- 4 Ubuntu EC2 instances (2 per app) across 2 Availability Zones
- Browser tests confirmed correct routing for `/app1`, `/app2`, and the default 404 rule

**Sylvain Simo Kamdem**
*August 11, 2026*

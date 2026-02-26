# 🚀 AWS Application Load Balancer with EC2 (Terraform)

This repository documents a **real‑world AWS architecture** using **Application Load Balancer (ALB)**, **EC2 web servers**, and **Terraform**.

This README is intentionally detailed so that **anyone following it will NOT repeat the mistakes I made** while building this project.

---

## 📌 Architecture Overview

```
Internet
   |
   v
Application Load Balancer (Public)
   |
   v
Target Group (HTTP : 80)
   |
   v
EC2 Web Servers (Apache)
```

---

## 🧰 Tools & Services Used

* AWS EC2
* AWS Application Load Balancer (ALB)
* AWS Target Groups
* AWS Security Groups
* Terraform
* Apache Web Server

---

## 🎯 Project Goal

* Deploy **two EC2 web servers** using Terraform
* Place them behind an **Application Load Balancer**
* Ensure:

  * ALB DNS serves HTML output
  * Target Group stays **Healthy**
  * EC2 instances are **not publicly exposed**

---

## 📁 Terraform File Structure

```
project/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── security_groups.tf
├── output.tf
├── userdata1.sh
├── userdata2.sh
```

---

## 🛠 Step‑by‑Step Setup

### Step 1: Create VPC and Subnets

* Create a VPC
* Create at least **2 public subnets** (for ALB)
* Ensure route table has Internet Gateway attached

---

### Step 2: Create Security Groups (MOST IMPORTANT)

#### ✅ 1️⃣ ALB Security Group (`alb-sg`)

**Attached ONLY to ALB**

Inbound Rules:

```
HTTP 80 → 0.0.0.0/0
```

Outbound:

```
All traffic → 0.0.0.0/0
```

---

#### ✅ 2️⃣ EC2 Security Group (`ec2-sg`)

**Attached ONLY to Web EC2 instances**

Inbound Rules:

```
SSH 22  → Your IP
HTTP 80 → alb-sg
```

Outbound:

```
All traffic → 0.0.0.0/0
```

🚫 **Never add `0.0.0.0/0` to EC2 HTTP**

---

### Step 3: Create EC2 Web Servers (Terraform)

* Launch **2 EC2 instances** using Terraform
* Attach **only `ec2-sg`**
* Install Apache (manual or user_data)

Verification:

```bash
curl localhost
```

Should return HTML content.

---

### Step 4: Create Target Group

Target Group settings:

```
Protocol: HTTP
Port: 80
Health check path: /
Health check port: traffic port
```

Register **only Terraform‑created EC2 instances**.

---

### Step 5: Create Application Load Balancer

* Internet‑facing ALB
* Attach **only `alb-sg`**
* Place in public subnets

---

### Step 6: Create Listener

```
HTTP : 80 → Forward to Target Group
```

---

## ✅ Final Verification Checklist

✔ Target Group → **Healthy**
✔ ALB DNS → HTML output
✔ EC2 Public IP → NOT accessible

---

## ❌ MISTAKES I MADE (IMPORTANT SECTION)

### ❌ Mistake 1: Using the SAME Security Group for ALB and EC2

**This was the root cause of all issues.**

What I did:

* Attached `ec2-sg` to BOTH ALB and EC2

What happened:

* Target Group kept becoming unhealthy
* ALB DNS worked sometimes and failed sometimes
* Removing `0.0.0.0/0` broke everything again

✅ **Fix:**

> ALB and EC2 must ALWAYS have **separate security groups**.

---

### ❌ Mistake 2: Keeping `HTTP 80 → 0.0.0.0/0` on EC2

Why it was wrong:

* Exposed EC2 directly to the internet
* Bypassed ALB
* Hid the real problem

When it is acceptable:

* ONLY for temporary debugging

---

## 🎤 Interview‑Ready Explanation

> "My target group was unhealthy because I mistakenly attached the same security group to both the ALB and EC2 instances. This caused ALB health checks to fail intermittently. Once I separated the security groups and allowed EC2 to accept traffic only from the ALB security group, the target group became healthy and the application worked correctly."

---

## 🚀 Future Improvements

* Add `user_data` to automate Apache installation
* Add HTTPS using ACM
* Add Auto Scaling Group
* Modularize Terraform code

---

## 🏁 Final Note

This project taught me **real AWS debugging**, not just theory.
If you follow this README step‑by‑step, you will **avoid all the mistakes I made**.

Happy Cloud Building ☁️🚀

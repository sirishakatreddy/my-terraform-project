#!/bin/bash
yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
HOSTNAME=$(hostname)
DATE=$(date)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Cloud Web Application</title>
<style>
* {
  box-sizing: border-box;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
  margin: 0;
  min-height: 100vh;
  background: linear-gradient(135deg, #141e30, #243b55);
  display: flex;
  justify-content: center;
  align-items: center;
}

.container {
  background: #ffffff;
  width: 460px;
  padding: 30px;
  border-radius: 14px;
  box-shadow: 0 25px 50px rgba(0,0,0,0.3);
  animation: fadeIn 1s ease-in-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

h1 {
  margin-top: 0;
  color: #2563eb;
  text-align: center;
}

.subtitle {
  text-align: center;
  color: #555;
  margin-bottom: 25px;
}

.card {
  background: #f8fafc;
  border-radius: 10px;
  padding: 15px;
}

.card p {
  margin: 10px 0;
  padding: 10px;
  background: #e5e7eb;
  border-radius: 6px;
  font-size: 14px;
}

.footer {
  text-align: center;
  margin-top: 20px;
  font-size: 12px;
  color: #666;
}
.badge {
  display: inline-block;
  background: #22c55e;
  color: white;
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 12px;
  margin-bottom: 15px;
}
</style>
</head>

<body>
  <div class="container">
    <div class="badge">LIVE • Load Balanced</div>
    <h1>🚀 Cloud Web Application</h1>
    <div class="subtitle">Deployed using Terraform & AWS ALB</div>

    <div class="card">
      <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
      <p><strong>Hostname:</strong> $HOSTNAME</p>
      <p><strong>Availability Zone:</strong> $AZ</p>
      <p><strong>Private IP:</strong> $PRIVATE_IP</p>
      <p><strong>Server Time:</strong> $DATE</p>
    </div>

    <div class="footer">
      Infrastructure as Code • Secure • Scalable
    </div>
  </div>
</body>
</html>
EOF

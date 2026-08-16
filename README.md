╔══════════════════════════════╗
║        T O N I B Y T E       ║
╚══════════════════════════════╝ 
# Linux Server Hardening & Automation

Production-style initial setup of an Ubuntu server from scratch.  
This repository documents a clean, secure baseline configuration that follows common industry practices.

## Goals

- Minimize attack surface
- Enforce least privilege
- Automate basic health monitoring and backups
- Keep everything reproducible and version-controlled

## What Was Configured

| Component              | Purpose                                          |
|------------------------|--------------------------------------------------|
| Non-root user + sudo   | Avoid working as root                            |
| SSH key authentication | Disable password-based attacks                   |
| UFW firewall           | Allow only necessary ports                       |
| fail2ban               | Automatically ban repeated failed login attempts |
| Health & backup script | Daily system checks and configuration backups    |
| Cron job               | Run the script automatically                     |

---

## 1. Initial Server Setup

### 1.1 Update the system

#!/bin/bash
sudo apt update && sudo apt upgrade -y

Why: Always start with a fully patched system.
1.2 Create a dedicated user
Bashsudo adduser devops
sudo usermod -aG sudo devops
Why: Working as root is dangerous. Daily operations should be done from a regular user with sudo privileges.
Switch to the new user:
Bashsu - devops

2. SSH Hardening
2.1 Add your public key
Bashmkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys   # paste your public key
chmod 600 ~/.ssh/authorized_keys
2.2 Configure SSH daemon
Edit the SSH configuration:
Bashsudo nano /etc/ssh/sshd_config
Set the following values:
BashPermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
Restart SSH:
Bashsudo systemctl restart ssh
Why:

Root login over SSH is a major security risk
Password authentication is vulnerable to brute-force attacks
Key-based authentication is the modern standard

Important: Keep your current session open and test a new connection before closing the existing one.

3. Firewall (UFW)
Bashsudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status verbose
Why:
By default, a server should deny all incoming traffic except explicitly allowed ports (in this case only SSH).

4. Intrusion Prevention (fail2ban)
Bashsudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
Check status:
Bashsudo fail2ban-client status
sudo fail2ban-client status sshd
Why:
fail2ban monitors log files and automatically bans IP addresses that show malicious behavior (e.g. repeated failed SSH logins).

5. Useful Base Packages
Bashsudo apt install htop curl wget git vim tree net-tools -y
Why: These tools significantly improve day-to-day server administration and troubleshooting.

6. Health Check & Backup Script
The script scripts/server-health.sh performs the following actions:

Reports disk, memory and CPU usage
Checks whether the SSH service is running
Creates a compressed backup of critical configuration directories
Rotates old backups (keeps the last 5)
Writes all output to a log file

Installation
#!/bin/bash
mkdir -p ~/scripts ~/backups ~/logs
# copy server-health.sh into ~/scripts/
chmod +x ~/scripts/server-health.sh
Manual test
Bash~/scripts/server-health.sh
Schedule with cron
Bashcrontab -e
Add this line to run the script every day at 03:00:
Bash0 3 * * * /home/devops/scripts/server-health.sh

7. Project Structure
textlinux-server-setup/
├── scripts/
│   └── server-health.sh
├── docs/                  # screenshots (optional)
├── README.md
└── .gitignore

Security Checklist

 System updated
 Non-root user created
 Root SSH login disabled
 Password authentication disabled
 Firewall enabled (only SSH allowed)
 fail2ban active
 Automated health checks and backups


Notes
This setup is intentionally minimal and focused on security fundamentals.
It can later be extended with:

Automatic security updates (unattended-upgrades)
Centralized logging
Monitoring agents (Node Exporter, etc.)
Configuration management (Ansible)


License
This project is for educational and portfolio purposes.
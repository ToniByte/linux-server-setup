T O N I B Y T E
# Linux Server Hardening & Automation

Production-style initial setup of an Debian server from scratch.  
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

`sudo apt update && sudo apt upgrade -y`

Why: Always start with a fully patched system.

### 1.2 Create a dedicated user

`sudo adduser devops`
`sudo usermod -aG sudo devops`

• Working as root is dangerous. Daily operations should be done from a regular user with sudo privileges.

Switch to the new user:

`su - devops`

## 2. SSH Hardening
### 2.1 Add your public key

`mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys   # paste your public key
chmod 600 ~/.ssh/authorized_keys`

### 2.2 Configure SSH daemon
Edit the SSH configuration:

`sudo nano /etc/ssh/sshd_config`

Set the following values:

`PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication no`

Restart SSH:

`sudo systemctl restart ssh`

• Root login over SSH is a major security risk
• Password authentication is vulnerable to brute-force attacks
• Key-based authentication is the modern standard

Important: Keep your current session open and test a new connection before closing the existing one.

## 3. Firewall (UFW)

`sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status verbose`

• By default, a server should deny all incoming traffic except explicitly allowed ports (in this case only SSH).

## 4. Intrusion Prevention (fail2ban)

`sudo apt install fail2ban -y`
`sudo systemctl enable fail2ban`
`sudo systemctl start fail2ban`

Check status:

`sudo fail2ban-client status`
`sudo fail2ban-client status sshd`

• fail2ban monitors log files and automatically bans IP addresses that show malicious behavior (e.g. repeated failed SSH logins).

## 5. Useful Base Packages

`sudo apt install htop curl wget git vim nano tree net-tools -y`

• These tools significantly improve day-to-day server administration and troubleshooting.

## 6. Health Check & Backup Script
The script scripts/server-health.sh performs the following actions:

• Reports disk, memory and CPU usage 
• Checks whether the SSH service is running
• Creates a compressed backup of critical configuration directories
• Rotates old backups (keeps the last 5)
• Writes all output to a log file

Installation

`mkdir -p ~/scripts ~/backups ~/logs
chmod +x ~/scripts/server-health.sh`

Manual test

`~/scripts/server-health.sh`

Schedule with cron

`crontab -e`

Add this line to run the script every day at 04:00

`0 4 * * * /home/devops/scripts/server-health.sh`

## 7. Project Structure

linux-server-setup/
─ scripts/
  └─ server-health.sh
─ docs/                 
─ README.md
─ .gitignore


## Security Checklist

☑ System updated
☑ Non-root user created
☑ Root SSH login disabled
☑ Password authentication disabled
☑ Firewall enabled (only SSH allowed)
☑ fail2ban active
☑ Automated health checks and backups

Notes
This setup is intentionally minimal and focused on security fundamentals.

License
This project is for educational and portfolio purposes.

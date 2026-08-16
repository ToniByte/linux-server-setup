████████╗ ██████╗ ███╗   ██╗██╗██████╗ ██╗   ██╗████████╗███████╗
╚══██╔══╝██╔═══██╗████╗  ██║██║██╔══██╗╚██╗ ██╔╝╚══██╔══╝██╔════╝
   ██║   ██║   ██║██╔██╗ ██║██║██████╔╝ ╚████╔╝    ██║   █████╗  
   ██║   ██║   ██║██║╚██╗██║██║██╔══██╗  ╚██╔╝     ██║   ██╔══╝  
   ██║   ╚██████╔╝██║ ╚████║██║██████╔╝   ██║      ██║   ███████╗
   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═════╝    ╚═╝      ╚═╝   ╚══════╝

                         T O N I B Y T E
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

# Linux Server Setup

My first real Linux server configured from scratch.

## What was done

- Installed Ubuntu 24.04
- Created a non-root user with sudo privileges
- Configured SSH key-only authentication (password login disabled)
- Set up firewall with ufw
- Installed and configured fail2ban
- Wrote a server health check and backup script
- Added the script to cron

## Why this matters

These are the basic security and operational practices every production server should have. Without them, a server quickly becomes vulnerable.

## Project Structure

- `scripts/server-health.sh` — health check + backup script
- `docs/` — screenshots (htop, ufw status, fail2ban)

## How to reproduce

1. Create a VPS
2. Connect via SSH
3. Perform the security hardening steps
4. Clone this repository:

   git clone https://github.com/YOUR_USERNAME/linux-server-setup.git
   cd linux-server-setup
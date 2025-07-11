#!/bin/bash

# ----------------------------------------
# 📄 automation.sh - System Health Report
# Author: Ritesh Singh
# Description: Collects system health info like disk usage, memory, CPU, and top processes
# ----------------------------------------

# Get Current Date & Time
echo "📅 Date and Time: $(date)"
echo "----------------------------------------"

# Uptime
echo "🔄 System Uptime:"
uptime
echo "----------------------------------------"

# Disk Usage
echo "💽 Disk Usage:"
df -h
echo "----------------------------------------"

# Memory Usage
echo "🧠 Memory Usage:"
free -h
echo "----------------------------------------"

# Top 5 CPU-consuming processes
echo "🔥 Top 5 CPU-Consuming Processes:"
ps aux --sort=-%cpu | head -n 6
echo "----------------------------------------"

# Top 5 Memory-consuming processes
echo "💾 Top 5 Memory-Consuming Processes:"
ps aux --sort=-%mem | head -n 6
echo "----------------------------------------"

# Logged-in users
echo "👤 Currently Logged-in Users:"
who
echo "----------------------------------------"

# Network IP info
echo "🌐 IP Address Info:"
hostname -I
echo "----------------------------------------"

# Done
echo "✅ Report Complete"

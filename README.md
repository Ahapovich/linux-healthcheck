Linux System Health Check
A simple interactive Bash script for performing basic health checks on a Linux system and selected services.

The script monitors the status of nginx, sshd, and docker, gathers root disk and RAM usage metrics, displays results in the terminal, creates a timestamped local log file, and can optionally dispatch the report to Telegram.

Features
Interactive Startup
Before initiating diagnostics, the script prompts for user confirmation:

Plaintext
Hello, this script will run a health check on your Linux operating system. Would you like to continue?(y/n):
The script gracefully exits if the user declines.

Optional Telegram Notifications
Users can optionally send the diagnostic output directly to a Telegram chat. When enabled, the script prompts for:

Telegram Chat ID

Telegram Bot Token

Integration can be bypassed during execution if remote messaging is not needed.

Service Monitoring
Checks service statuses via systemctl for:

nginx

sshd

docker

Key Operations:

Tracks counts of active vs. failed services.

Formats array lists for active and failed services.

Handles fallback text (No active services / No failed services) when lists are empty.

Example Terminal Output:

Plaintext
======SERVICE=HEALTH======

☑ nginx OK

☑ sshd OK

☒ docker OFF

Working services: 2
Failed services: 1
Disk Usage
Inspects the root (/) filesystem to compute:

Total storage capacity (in GB).

Current capacity utilization percentage.

Example Terminal Output:

Plaintext
Total disk storage is 50 GB
The hard drive is 30% full.
RAM Usage
Calculates memory metrics using free:

Total installed system memory (in GB).

Current memory usage percentage.

Example Terminal Output:

Plaintext
RAM: 8 GB
RAM is 17% full

Local Logging
Regardless of whether Telegram messaging is enabled, the script appends timestamped diagnostic reports to a daily log file:

Filename pattern: healthcheck_YYYY-MM-DD.log

Entry format: [YYYY-MM-DD HH:MM:SS] Status: <Report Output>

Sample Output & Report
The final report combines service statuses, storage information, and memory metrics:

Plaintext
Working services: nginx sshd
Failed services: docker

Storage info: 
Total hard disk storage is: 50 GB | The hard drive is 30% full
Total RAM storage is: 8 GB | RAM is 17% full
The exact same text block is pushed to your specified Telegram chat when Telegram features are active.

Requirements
OS: Linux distribution with systemd (Debian, Ubuntu, RHEL, CentOS, Fedora, Arch, etc.)

Shell: Bash

Core Utilities: systemctl, df, free, awk, sed, tr, curl

Note: Elevated privileges (sudo or root) may be required to query certain service states depending on your system's security settings.

Quick Start
1. Clone the repository
Bash
git clone https://github.com/YOUR_USERNAME/linux-healthcheck.git
cd linux-healthcheck
2. Make the script executable
Bash
chmod +x healthcheck.sh
3. Execute the script
Bash
./healthcheck.sh
📲 Telegram Setup
Telegram integration requires your own personal bot.

Step 1 — Create Your Bot
Open Telegram and search for @BotFather.

Send /newbot and follow the prompts to specify a name and username for your bot.

BotFather will issue a unique Bot API Token (e.g., 123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ123456789).

Security Warning: Never commit or upload your Bot API Token to public repositories.

Step 2 — Initialize & Get Your Chat ID
Open your newly created bot in Telegram and press Start or send a message (bots cannot message you first).

Find your personal Chat ID by starting a conversation with @userinfobot or @raw_data_bot.

Step 3 — Run with Telegram Enabled
When prompted during execution:

Plaintext
Did you want take results by telegram? y/n?
Type y, then input your Chat ID and Bot Token.

Project Structure
Plaintext
linux-healthcheck/
├── healthcheck.sh
├── README.md
└── .gitignore
Recommended .gitignore to prevent committing logs or environment secrets:

Фрагмент кода
*.log
.env
What I Practiced With This Project
This project served as hands-on practice for Bash scripting and Linux system administration concepts:

Control Flow: case statements, if / else logic, and for loops.

Arrays: Appending items (+=), expanding array values ("${SERVICE_STATUS[*]}"), and checking array counts ("${#ARRAY[@]}").

Text Processing: awk, sed, and tr for parsing system tool outputs.

System Utilities: Querying state with systemctl, df, and free.

API Calls: Constructing HTTP POST requests via curl to interact with the Telegram Bot API.

File Operations: Redirecting timestamped string data to log files (>>).

Possible Future Improvements
Configurable target service lists via command-line flags or config files.

Threshold-based warnings (e.g., alert if disk space > 80% or RAM > 90%).

HTTP endpoint probing with curl.

Quiet mode for running via cron jobs.

Non-interactive flag parsing using getopts.

License
Provided for educational and personal utility use.

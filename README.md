# n8n Codespace Setup

Run n8n in GitHub Codespaces to create and test templates with full API access.

## Quick Start

### Option 1: One-Click Setup
1. Push this repo to GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for setup to complete
4. n8n will be running at http://localhost:5678

### Option 2: Manual Setup
1. Open this folder in VS Code
2. Install Dev Containers extension
3. Click **Reopen in Container**
4. n8n will be running at http://localhost:5678

## First Time Setup

1. Open http://localhost:5678
2. Create owner account:
   - Email: admin@n8n.local
   - Password: admin123
3. Import templates:
   ```bash
   chmod +x import-templates.sh
   ./import-templates.sh
   ```

## Templates Included

### FREE (4 templates - $0)
- F1-google-sheets-sync.json
- F2-form-to-google-sheets.json
- F3-slack-notification-bot.json
- F4-daily-digest-email.json

### STARTER (6 templates - $9-$12)
- S1-social-media-post-scheduler.json
- S2-email-auto-responder-ai.json
- S3-invoice-reminder.json
- S4-content-repurposer.json
- S5-lead-capture-sheets.json
- S6-csv-data-cleaner.json

### PRO (6 templates - $19-$29)
- P1-ai-lead-generation-pipeline.json
- P2-linkedin-outreach-automation.json
- P3-ai-content-repurposer-full.json
- P4-email-sequence-builder.json
- P5-social-media-autopilot.json
- P6-meeting-notes-crm-sync.json

### PREMIUM (4 templates - $29-$49)
- X1-customer-support-ai-triage.json
- X2-seo-content-workflow.json
- X3-competitor-price-monitor.json
- X4-invoice-automation-system.json

## Database

PostgreSQL is included in the docker-compose setup:
- Host: postgres
- Port: 5432
- Database: n8n
- User: n8n
- Password: n8npassword

## API Access

Full API access is available. Use the n8n REST API to:
- Create workflows
- Update workflows
- Delete workflows
- Import/export templates

Example:
```bash
# Login
TOKEN=$(curl -s -X POST http://localhost:5678/rest/login \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "emailOrLdapLoginId=admin@n8n.local&password=admin123" \
    -c - | grep n8n-auth | awk '{print $NF}')

# List workflows
curl -s http://localhost:5678/rest/workflows \
    -b "n8n-auth=$TOKEN"
```

## Export Templates for HuggingFace

After creating/testing templates in Codespace:
1. Go to http://localhost:5678
2. Open a workflow
3. Click **Download** (or use API)
4. Import into your HuggingFace n8n instance

## Cleanup

When done, stop the Codespace to avoid using free hours:
- Go to https://github.com/codespaces
- Delete the codespace

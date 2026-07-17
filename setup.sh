#!/bin/bash
# One-click n8n setup for GitHub Codespaces
echo "=== Starting n8n setup ==="

# Start n8n with Docker
echo "Starting n8n and PostgreSQL..."
docker compose up -d

# Wait for n8n to be ready
echo "Waiting for n8n to start (30 seconds)..."
sleep 30

# Create owner account
echo "Creating owner account..."
curl -s -X POST http://localhost:5678/rest/owner/setup \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@n8n.local","firstName":"Admin","lastName":"User","password":"admin123"}'

# Wait a bit more
sleep 5

# Login and get token
echo "Logging in..."
TOKEN=$(curl -s -X POST http://localhost:5678/rest/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "emailOrLdapLoginId=admin@n8n.local&password=admin123" \
  -c /tmp/n8n-cookies | grep n8n-auth | awk '{print $NF}')

# Import all templates
echo "Importing templates..."
count=0
for file in templates/*.json; do
  if [ -f "$file" ]; then
    count=$((count + 1))
    echo "  [$count] Importing $(basename $file)..."
    curl -s -X POST http://localhost:5678/rest/workflows \
      -H "Content-Type: application/json" \
      -b "n8n-auth=$TOKEN" \
      -d @"$file" > /dev/null
  fi
done

echo ""
echo "=== DONE! ==="
echo "n8n is running at: http://localhost:5678"
echo "Templates imported: $count"
echo ""
echo "Open http://localhost:5678 in your browser to use n8n"

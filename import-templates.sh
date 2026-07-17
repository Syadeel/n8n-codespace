#!/bin/bash
# Import all n8n templates via API
# Run this after n8n is up and running

N8N_URL="http://localhost:5678"
TEMPLATES_DIR="./templates"

echo "=== n8n Template Importer ==="
echo "Waiting for n8n to start..."

# Wait for n8n to be ready
for i in {1..30}; do
    if curl -s "$N8N_URL/healthz" > /dev/null 2>&1; then
        echo "n8n is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done

# Login and get auth token
echo ""
echo "=== Logging in to n8n ==="
TOKEN=$(curl -s -X POST "$N8N_URL/rest/login" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "emailOrLdapLoginId=admin@n8n.local&password=admin123" \
    -c - | grep n8n-auth | awk '{print $NF}')

if [ -z "$TOKEN" ]; then
    echo "Login failed. Trying to create owner account..."
    curl -s -X POST "$N8N_URL/rest/owner/setup" \
        -H "Content-Type: application/json" \
        -d '{
            "email": "admin@n8n.local",
            "firstName": "Admin",
            "lastName": "User",
            "password": "admin123"
        }'
    sleep 2
    
    TOKEN=$(curl -s -X POST "$N8N_URL/rest/login" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "emailOrLdapLoginId=admin@n8n.local&password=admin123" \
        -c - | grep n8n-auth | awk '{print $NF}')
fi

echo "Token obtained!"

# Import each template
echo ""
echo "=== Importing Templates ==="
count=0
total=$(ls -1 $TEMPLATES_DIR/*.json 2>/dev/null | wc -l)

for file in $TEMPLATES_DIR/*.json; do
    if [ -f "$file" ]; then
        count=$((count + 1))
        filename=$(basename "$file")
        echo "[$count/$total] Importing: $filename"
        
        result=$(curl -s -X POST "$N8N_URL/rest/workflows" \
            -H "Content-Type: application/json" \
            -b "n8n-auth=$TOKEN" \
            -d @"$file")
        
        if echo "$result" | grep -q '"id"'; then
            echo "  ✅ Success"
        else
            echo "  ❌ Failed: $result"
        fi
    fi
done

echo ""
echo "=== Import Complete ==="
echo "Total templates imported: $count"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:5678"
echo "2. Go to Workflows to see all imported templates"
echo "3. Export them as JSON for use on other n8n instances"

#!/bin/bash
# Test script - Exercise 01 Solution

echo "🚀 Testing Traefik Docker Compose Setup - Exercise 01"
echo "====================================================="

# Function to check status
check_status() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
    else
        echo "❌ $2"
        return 1
    fi
}

# Test 1: Docker Compose configuration
echo -e "\n📋 Test 1: Docker Compose Configuration"
docker compose config > /dev/null 2>&1
check_status $? "Docker Compose configuration is valid"

# Test 2: Launch services
echo -e "\n🐳 Test 2: Launching Services"
docker compose up -d
sleep 10  # Wait for Traefik to be ready
check_status $? "Services started successfully"

# Test 3: Traefik connectivity
echo -e "\n🌐 Test 3: Traefik Connectivity"
curl -s -I http://localhost:9000 > /dev/null 2>&1
check_status $? "Traefik dashboard accessible on port 9000"

# Test 4: Traefik API
echo -e "\n🔍 Test 4: Traefik API"
curl -s http://localhost:9000/api/rawdata | jq . > /dev/null 2>&1
check_status $? "Traefik API is functional"

# Test 5: Entrypoints
echo -e "\n🚪 Test 5: Entrypoints"
entrypoints=$(curl -s http://localhost:9000/api/entrypoints | jq -r 'keys[]' 2>/dev/null)
if echo "$entrypoints" | grep -q "web" && echo "$entrypoints" | grep -q "websecure"; then
    check_status 0 "Entrypoints 'web' and 'websecure' configured"
else
    check_status 1 "Missing entrypoints 'web' and 'websecure'"
fi

# Test 6: Docker provider
echo -e "\n🐋 Test 6: Docker Provider"
providers=$(curl -s http://localhost:9000/api/overview | jq -r '.providers.docker.status' 2>/dev/null)
if [ "$providers" = "enabled" ]; then
    check_status 0 "Docker provider is enabled"
else
    check_status 1 "Docker provider is not enabled"
fi

echo -e "\n🎉 Tests completed!"
echo "Dashboard accessible: http://localhost:9000"
echo ""
echo "To stop services: docker compose down"

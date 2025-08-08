#!/bin/bash
# Test script - Exercise 02 Solution

echo "🚀 Testing Traefik with Services - Exercise 02"
echo "============================================="

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
sleep 15  # Wait for all services to be ready
check_status $? "All services started successfully"

# Test 3: Check running containers
echo -e "\n📦 Test 3: Container Status"
containers=$(docker compose ps -q | wc -l)
if [ "$containers" -eq 3 ]; then
    check_status 0 "All 3 containers are running (traefik, whoami, filebrowser)"
else
    check_status 1 "Expected 3 containers, found $containers"
fi

# Test 4: Traefik dashboard
echo -e "\n🌐 Test 4: Traefik Dashboard"
curl -s -I http://localhost:9000 > /dev/null 2>&1
check_status $? "Traefik dashboard accessible"

# Test 5: Service discovery
echo -e "\n🔍 Test 5: Service Discovery"
services=$(curl -s http://localhost:9000/api/http/services | jq -r 'keys[]' 2>/dev/null | grep -v api@internal | wc -l)
if [ "$services" -ge 2 ]; then
    check_status 0 "Services discovered by Traefik ($services services)"
else
    check_status 1 "Services not properly discovered"
fi

# Test 6: Whoami service
echo -e "\n👤 Test 6: Whoami Service"
# Test with Host header
response=$(curl -s -H "Host: whoami.dev.dojo.localhost" http://localhost 2>/dev/null)
if echo "$response" | grep -q "Hostname:"; then
    check_status 0 "Whoami service responding correctly"
else
    check_status 1 "Whoami service not responding"
fi

# Test 7: Filebrowser service
echo -e "\n📁 Test 7: Filebrowser Service"
# Test with Host header
response=$(curl -s -H "Host: files.dev.dojo.localhost" http://localhost 2>/dev/null)
if echo "$response" | grep -q -i "filebrowser\|File Browser"; then
    check_status 0 "Filebrowser service responding correctly"
else
    check_status 1 "Filebrowser service not responding properly"
fi

# Test 8: Check routers
echo -e "\n🛣️  Test 8: Router Configuration"
routers=$(curl -s http://localhost:9000/api/http/routers | jq -r 'keys[]' 2>/dev/null)
if echo "$routers" | grep -q "whoami" && echo "$routers" | grep -q "filebrowser"; then
    check_status 0 "Both service routers are configured"
else
    check_status 1 "Service routers not properly configured"
fi

echo -e "\n🎉 Tests completed!"
echo ""
echo "Access points:"
echo "- Dashboard: http://localhost:9000"
echo "- Whoami: http://whoami.dev.dojo.localhost (add to /etc/hosts)"
echo "- Filebrowser: http://files.dev.dojo.localhost (add to /etc/hosts)"
echo ""
echo "Add to /etc/hosts:"
echo "127.0.0.1 whoami.dev.dojo.localhost"
echo "127.0.0.1 files.dev.dojo.localhost"
echo ""
echo "To stop services: docker compose down"

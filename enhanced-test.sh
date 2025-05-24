#!/bin/bash

# Enhanced testing script for bonus features
echo "🚀 Starting Enhanced CI/CD Testing..."

# Test 1: Basic application availability
echo "Test 1: Basic application availability"
if curl -f http://172.17.0.1:5050/ | grep "You are calling me from"; then
    echo "✅ Basic app test PASSED"
else
    echo "❌ Basic app test FAILED"
    exit 1
fi

# Test 2: Health check endpoint
echo "Test 2: Health check endpoint"
if curl -f http://172.17.0.1:5050/api/health | grep "healthy"; then
    echo "✅ Health check test PASSED"
else
    echo "❌ Health check test FAILED"
    exit 1
fi

# Test 3: System info endpoint
echo "Test 3: System info endpoint"
if curl -f http://172.17.0.1:5050/api/system | grep "container_id"; then
    echo "✅ System info test PASSED"
else
    echo "❌ System info test FAILED"
    exit 1
fi

# Test 4: Echo API endpoint (GET)
echo "Test 4: Echo API endpoint (GET)"
if curl -f "http://172.17.0.1:5050/api/echo?test=value" | grep "GET"; then
    echo "✅ Echo GET test PASSED"
else
    echo "❌ Echo GET test FAILED"
    exit 1
fi

# Test 5: Echo API endpoint (POST)
echo "Test 5: Echo API endpoint (POST)"
if curl -f -X POST -H "Content-Type: application/json" -d '{"test":"data"}' http://172.17.0.1:5050/api/echo | grep "POST"; then
    echo "✅ Echo POST test PASSED"
else
    echo "❌ Echo POST test FAILED"
    exit 1
fi

echo "🎉 All enhanced tests PASSED!"
exit 0
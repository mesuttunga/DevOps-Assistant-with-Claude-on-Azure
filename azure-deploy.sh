#!/bin/bash
# azure-deploy.sh - Deploy to Azure Container Apps

# TESTED & WORKING ✅
# This script has been successfully tested and deployed.
#
# Prerequisites:
# - Azure CLI installed and logged in (az login)
# - Docker installed and running
# - CLAUDE_API_KEY environment variable set
#
# Usage:
#   export CLAUDE_API_KEY="your-api-key-here"
#   ./azure-deploy.sh
#
# To cleanup: az group delete --name devops-assistant-rg --yes --no-wait

set -e

# Configuration - Updated with unique names
RESOURCE_GROUP="devops-assistant-rg"
LOCATION="westeurope"
CONTAINER_APP_NAME="devops-assistant"
CONTAINER_REGISTRY="devopsacr$RANDOM"  # Random suffix for uniqueness
IMAGE_NAME="devops-assistant"
ENVIRONMENT="devops-env"

echo "🚀 Starting Azure deployment..."
echo "📋 Using Resource Group: $RESOURCE_GROUP"
echo "📋 Container Registry: $CONTAINER_REGISTRY"

# Check if CLAUDE_API_KEY is set
if [ -z "$CLAUDE_API_KEY" ]; then
    echo "❌ Error: CLAUDE_API_KEY environment variable is not set"
    echo "   Run: export CLAUDE_API_KEY='your-key-here'"
    exit 1
fi

# 1. Login check
echo "📝 Checking Azure login..."
az account show > /dev/null 2>&1 || az login

# 2. Create resource group
echo "📦 Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 3. Create container registry
echo "🐳 Creating container registry..."
az acr create --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_REGISTRY \
  --sku Basic \
  --admin-enabled true

# 4. Build and push image
echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME:latest .

echo "📤 Pushing to Azure Container Registry..."
az acr login --name $CONTAINER_REGISTRY
docker tag $IMAGE_NAME:latest $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest
docker push $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest

# 5. Get registry credentials
ACR_USERNAME=$(az acr credential show --name $CONTAINER_REGISTRY --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name $CONTAINER_REGISTRY --query "passwords[0].value" -o tsv)

# 6. Create Container App environment
echo "🌍 Creating Container App environment..."
az containerapp env create \
  --name $ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# 7. Deploy Container App
echo "🎯 Deploying Container App..."
az containerapp create \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $ENVIRONMENT \
  --image $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest \
  --registry-server $CONTAINER_REGISTRY.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --target-port 80 \
  --ingress external \
  --env-vars CLAUDE_API_KEY=secretref:claude-api-key \
  --secrets claude-api-key=$CLAUDE_API_KEY \
  --cpu 0.5 \
  --memory 1.0Gi

# 8. Get the URL
APP_URL=$(az containerapp show \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "properties.configuration.ingress.fqdn" -o tsv)

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your app is live at: https://$APP_URL"
echo ""
echo "💡 To update the app:"
echo "   docker build -t $IMAGE_NAME:latest ."
echo "   docker tag $IMAGE_NAME:latest $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest"
echo "   docker push $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest"
echo "   az containerapp update --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP"
echo ""
echo "🗑️  To cleanup (delete all resources):"
echo "   az group delete --name $RESOURCE_GROUP --yes --no-wait"
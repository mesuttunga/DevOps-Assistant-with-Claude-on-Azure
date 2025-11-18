#!/bin/bash
# azure-deploy.sh - Deploy to Azure Container Apps

set -e

# Configuration
RESOURCE_GROUP="devops-assistant-rg"
LOCATION="westeurope"
CONTAINER_APP_NAME="devops-assistant"
CONTAINER_REGISTRY="devopsassistantacr"
IMAGE_NAME="devops-assistant"
ENVIRONMENT="devops-env"

echo "🚀 Starting Azure deployment..."

# 1. Login to Azure (if not already logged in)
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
echo "   1. Make your changes"
echo "   2. Run: docker build -t $IMAGE_NAME:latest ."
echo "   3. Run: docker push $CONTAINER_REGISTRY.azurecr.io/$IMAGE_NAME:latest"
echo "   4. Run: az containerapp update --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP"
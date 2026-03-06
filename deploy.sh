#!/bin/bash

# Deploy API Gateway to Google Cloud Run

# Set your project ID
PROJECT_ID="your-gcp-project-id"

echo "Building and deploying API Gateway..."

# Build the application
./mvnw clean package -DskipTests

# Build Docker image
docker build -t gcr.io/$PROJECT_ID/api-gateway:latest .

# Push to Google Container Registry
docker push gcr.io/$PROJECT_ID/api-gateway:latest

# Deploy to Cloud Run with production environment variables
gcloud run deploy api-gateway \
  --image gcr.io/$PROJECT_ID/api-gateway:latest \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated \
  --set-env-vars SPRING_PROFILES_ACTIVE=production \
  --set-env-vars USER_SERVICE_URL=https://user-service-268672367192.us-central1.run.app \
  --set-env-vars DOCTOR_SERVICE_URL=https://doctor-service-efc3c5f3xa-uc.a.run.app

echo "API Gateway deployed successfully!"
echo "Get the URL with: gcloud run services describe api-gateway --region us-central1 --format 'value(status.url)'"
# Create The Artifact Registry first! --> ini bisa di ganti masuk ke dockerhub
gcloud artifacts repositories create ollama \
    --repository-format=docker \
    --location=us-central1 \
    --description="Ollama Docker images"


# Build and push the Docker image to Artifact Registry, ini bisa di ganti untuk build di github actions....
gcloud builds submit \
  --tag us-central1-docker.pkg.dev/warhol-research-project/ollama/ollama-qwen3


# Deploy to Cloud Run with GPU this is how we run to gcloud cloud run, pull the images from artifact registry di docker hub....
   gcloud run deploy ollama-gpu-service \
     --image us-central1-docker.pkg.dev/warhol-research-project/ollama/ollama-qwen3 \
     --region us-central1 \
     --port 11434 \
     --gpu 1 --gpu-type nvidia-l4 \
     --cpu 4 --memory 16Gi \
     --no-cpu-throttling \
     --concurrency 1 --max-instances 1 \
     --no-allow-unauthenticated \
     --command "ollama" \
     --args "serve"



gcloud services disable artifactregistry.googleapis.com --project warhol-research-project
gcloud services disable cloudbuild.googleapis.com --project warhol-research-project
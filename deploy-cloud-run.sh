# Create The Artifact Registry first! --> ini bisa di ganti masuk ke dockerhub
gcloud artifacts repositories create ollama \
    --repository-format=docker \
    --location=us-central1 \
    --description="Ollama Docker images"


# Build and push the Docker image to Artifact Registry, ini bisa di ganti untuk build di github actions....
gcloud builds submit \
  --tag us-central1-docker.pkg.dev/warhol-research-project/ollama/ollama-qwen3


# Deploy to Cloud Run with GPU this is how we run to gcloud cloud run, pull the images from artifact registry di docker hub....
   # Use Docker Hub image instead of Artifact Registry
   # If the image is private, make sure Cloud Run can access it (see note below).
   gcloud run deploy ollama-gpu-service \
     --image docker.io/noveriojoee/ollama-qwen3:latest \
     --region us-central1 \
     --port 11434 \
     --gpu 1 --gpu-type nvidia-l4 \
     --cpu 4 --memory 16Gi \
     --no-cpu-throttling \
     --concurrency 1 --max-instances 1 \
     --allow-unauthenticated \
     --command "ollama" \
     --args "serve"

# Show the deployed service URL
gcloud run services describe ollama-gpu-service --region us-central1 --format="value(status.url)"



## Notes:
## - Cloud Run (managed) can pull public images from Docker Hub using the docker.io/<user>/<repo>:<tag> reference above.
## - If the image on Docker Hub is private, you must provide credentials so Cloud Run can pull it. One option is to mirror/push the image into Artifact Registry or GCR and grant Cloud Run access, or configure a secret with Docker credentials and configure the service's image pull secret.
## - Also remember Cloud Run (managed) has limited GPU support; the `--gpu` flag used above requires specific platform/preview features and may not be available in all projects/regions.

#gcloud services disable artifactregistry.googleapis.com --project warhol-research-project
#gcloud services disable cloudbuild.googleapis.com --project warhol-research-project
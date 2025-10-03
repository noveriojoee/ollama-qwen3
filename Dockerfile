# Start from the official Ollama image
FROM ollama/ollama:latest

# Pre-download Qwen3 model so it's baked into the image
RUN ollama serve & sleep 10 && ollama pull qwen3 && pkill ollama

# Ensure Ollama listens on all interfaces, port 11434
ENV OLLAMA_HOST=0.0.0.0:11434

# Start Ollama when the container runs
CMD ["ollama", "serve"]
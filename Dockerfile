# The LLM server: official Ollama image with the model baked in, ready for Cloud Run.
#   docker build -t mrfit-ollama ollama/                                         (≈ 5 GB)
#   docker build --build-arg OLLAMA_MODEL=llama3.2:3b -t mrfit-ollama ollama/   (smaller model)
FROM ollama/ollama:latest

ARG OLLAMA_MODEL=llama3.1:8b

# Cloud Run sends traffic to port 8080; models live in /models inside the image;
# KEEP_ALIVE=-1 keeps the model loaded in memory between requests.
ENV OLLAMA_HOST=0.0.0.0:8080 \
    OLLAMA_MODELS=/models \
    OLLAMA_KEEP_ALIVE=-1 \
    OLLAMA_DEBUG=false

# `ollama pull` needs a running server: start it, wait until it answers, pull, stop it.
RUN ollama serve & server=$!; \
    for i in $(seq 1 30); do ollama list >/dev/null 2>&1 && break; sleep 1; done; \
    ollama pull "$OLLAMA_MODEL"; \
    kill $server

EXPOSE 8080
# ENTRYPOINT ["/bin/ollama"] and CMD ["serve"] come from the base image

# Use the base image you're working with, e.g., Python with specific versions if needed
FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu22.04

# Set up working directory
WORKDIR /workspace

# Install any system dependencies
RUN apt-get update && apt-get install -y \
    python3.10-venv \
    python3-dev \
    g++ \
    libgl1-mesa-glx \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Cloudflare for tunneling
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
RUN dpkg -i cloudflared-linux-amd64.deb

# Set up virtual environment inside the container
RUN python3 -m venv venv-dev
#RUN . venv-dev/bin/activate

# Activate virtual environment and install Jupyter
RUN venv-dev/bin/pip install --upgrade pip \
    && venv-dev/bin/pip install jupyter pickleshare

# Set up InstantID
RUN git clone https://github.com/photoangell/InstantID.git
RUN venv-dev/bin/pip install -r InstantID/gradio_demo/requirements.txt
RUN venv-dev/bin/pip install --upgrade huggingface-hub diffusers

# Expose the Jupyter port
EXPOSE 8080

# Run Jupyter on container startup with the custom token
#CMD ["venv-dev/bin/jupyter", "notebook", "--ServerApp.token='YmbbtWillBlowYourTinyMind'", "--port=8080", "--no-browser", "--allow-root"]

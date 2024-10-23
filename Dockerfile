# Use the base image you're working with, e.g., Python with specific versions if needed
FROM nvidia/cuda:12.6.2-cudnn-runtime-ubuntu22.04

# Set up working directory
WORKDIR /workspace

# Install any system dependencies and clean up in a single RUN command
RUN apt-get update && apt-get install -y \
    python3.10-venv \
    python3-dev \
    g++ \
    libgl1-mesa-glx \
    wget \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up virtual environment inside the container
RUN python3 -m venv venv-dev

# Activate virtual environment and install Jupyter and other dependencies
RUN venv-dev/bin/pip install --upgrade pip \
    && venv-dev/bin/pip install jupyter pickleshare mediapipe \
    && venv-dev/bin/pip cache purge

# Set up InstantID and install its dependencies
RUN git clone https://github.com/photoangell/InstantID.git \
    && venv-dev/bin/pip install -r InstantID/gradio_demo/requirements.txt \
    && venv-dev/bin/pip install --upgrade huggingface-hub diffusers \
    && venv-dev/bin/pip cache purge

# Expose the Jupyter & gradio port
EXPOSE 8080 7860

# Run Jupyter on container startup with the custom token - this is not required when running in Vast.Ai
# This command is in the vast.ai template
#CMD ["venv-dev/bin/jupyter", "notebook", "--ServerApp.token='YmbbtWillBlowYourTinyMind'", "--port=8080", "--no-browser", "--allow-root"]

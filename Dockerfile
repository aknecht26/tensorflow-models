FROM --platform=linux/amd64 python:3.9-slim

# Set up installation dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    protobuf-compiler \
    python3-pil \
    python3-lxml \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/aknecht26/tensorflow-models /repo

# Set working directory
WORKDIR /repo

# Install dependencies from requirements.txt
RUN pip install -r official/requirements.txt

# Install the package in editable mode
RUN pip install -e .

# Set up environment variables
ENV PYTHONPATH=/repo
ENV TF_CPP_MIN_LOG_LEVEL=2

# Create the repo_info.json
RUN cat > /repo_info.json <<EOF
{
  "repo_dir": "/repo",
  "pytest_rootdir": "/repo/official",
  "abs_path_to_toplevel_init": "/repo/tensorflow_models/__init__.py",
  "basic_import_statement": "import tensorflow_models"
}
EOF

# Copy the health verification script
COPY repo_health_verification.py /repo_health_verification.py

# Default to bash shell to keep container running
CMD ["bash"]

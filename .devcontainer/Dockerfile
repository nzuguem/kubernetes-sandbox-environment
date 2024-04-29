# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu

## Install Tools
RUN <<EOF
set -e

# Install Taskfile
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d
EOF
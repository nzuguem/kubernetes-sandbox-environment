# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu

## Install Tools
RUN <<EOF
set -e

# Install Taskfile
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

# Install kubecolor
mkdir -p /tmp/kubecolor
wget https://github.com/kubecolor/kubecolor/releases/download/v0.5.0/kubecolor_0.5.0_linux_amd64.tar.gz -O /tmp/kubecolor/kubecolor.tar.gz
tar -xvzf /tmp/kubecolor/kubecolor.tar.gz -C /tmp/kubecolor
mv /tmp/kubecolor/kubecolor /usr/local/bin
rm -Rf /tmp/kubecolor
EOF

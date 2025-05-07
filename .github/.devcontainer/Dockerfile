# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/base:ubuntu

## Install Tools
RUN <<EOF
set -e

# Install Taskfile
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

# Install kubecolor
mkdir -p /tmp/kubecolor
wget https://github.com/kubecolor/kubecolor/releases/download/v0.5.1/kubecolor_0.5.1_linux_amd64.tar.gz -O /tmp/kubecolor/kubecolor.tar.gz
tar -xvzf /tmp/kubecolor/kubecolor.tar.gz -C /tmp/kubecolor
mv /tmp/kubecolor/kubecolor /usr/local/bin
rm -Rf /tmp/kubecolor

# Install pluto
mkdir -p /tmp/pluto
wget https://github.com/FairwindsOps/pluto/releases/download/v5.21.4/pluto_5.21.4_linux_amd64.tar.gz -O /tmp/pluto/pluto.tar.gz
tar -xvzf /tmp/pluto/pluto.tar.gz -C /tmp/pluto
mv /tmp/pluto/pluto /usr/local/bin
rm -Rf /tmp/pluto

EOF

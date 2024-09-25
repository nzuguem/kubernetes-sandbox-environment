#!/usr/bin/env bash

set -eux

GRPCURL_VERSION="${VERSION:-"latest"}"

echo "Installing grpcurl ${GRPCURL_VERSION}..."

go install github.com/fullstorydev/grpcurl/cmd/grpcurl@"$GRPCURL_VERSION"

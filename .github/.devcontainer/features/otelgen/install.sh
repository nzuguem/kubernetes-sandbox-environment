#!/usr/bin/env bash

set -e

go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@$VERSION

echo 'Done!'
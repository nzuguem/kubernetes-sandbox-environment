# Floci AWS Emulator

This directory contains the Helm chart for deploying **Floci**, a lightweight, free, open-source AWS emulator for local development.

## Overview

Floci is a modern replacement for LocalStack Community Edition, which reached end-of-support in March 2026. It provides a fast, low-resource footprint AWS service emulator with comprehensive SDK compatibility.

### Key Benefits

- **No Auth Required**: Free forever, no authentication tokens needed
- **Lightweight**: ~90 MB image, ~13 MiB idle memory, ~24 ms startup time
- **Full SDK Compatibility**: Works with AWS SDK for Java, Python, Node.js, Go, etc.
- **20+ Services**: S3, DynamoDB, Lambda, SQS, SNS, Cognito, RDS, and more
- **Native Binary**: ~40 MB native image available (experimental)
- **MIT Licensed**: Open source and community-driven

## Deployment

### Install Floci

```bash
task control-plane:floci-install
```

This will:
1. Deploy Floci to your Kubernetes cluster using Helm
2. Create an Ingress for access via `http://floci.127.0.0.1.nip.io`
3. Configure AWS CLI to use Floci by default (sets up `~/.aws/config` and credentials)

### Verify Installation

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=floci

# List S3 buckets
aws s3 ls

# Create a bucket
aws s3 mb s3://my-bucket

# Test DynamoDB
aws dynamodb list-tables

# Test SQS
aws sqs list-queues
```

### Uninstall Floci

```bash
task control-plane:floci-uninstall
```

## Configuration

### Helm Values

Default Floci Helm values are in `helm.values.yml`:
- Replicas: 1
- Image: `hectorvent/floci:latest`
- Service Type: ClusterIP
- Ingress: Enabled with nginx
- Persistence: 1Gi PVC for data storage
- **Docker-in-Docker Sidecar**: Enabled by default for Lambda, ElastiCache, RDS support

### Docker-in-Docker Sidecar

To support AWS Lambda, ElastiCache, and RDS services that require container execution, Floci includes an optional Docker-in-Docker (DinD) sidecar container.

The sidecar is configured via:
- **Environment Variable**: `FLOCI_SERVICES_LAMBDA_DOCKER_HOST=unix:///var/run/docker.sock`
- **Volume Mount**: Shared `/var/run/docker.sock` between Floci and DinD containers
- **Security Context**: Privileged mode for DinD container

You can disable the DinD sidecar by setting `dind.enabled: false` in your Helm values if you don't need Lambda/ElastiCache/RDS support:

```yaml
dind:
  enabled: false
```

### AWS Configuration

After installation, AWS CLI uses Floci as the default profile:

```bash
# Floci (default)
aws s3 ls

# Or use LocalStack profile if needed (requires localstack running)
aws --profile localstack s3 ls
```

## Chart Structure

```
chart/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
└── templates/
    ├── _helpers.tpl        # Template helpers
    ├── deployment.yaml     # Floci deployment
    ├── service.yaml        # Service definition
    ├── ingress.yaml        # Ingress configuration
    ├── pvc.yaml            # Persistent volume claim
    └── serviceaccount.yaml # Service account
```

## Service Compatibility

Floci supports 20+ AWS services with full SDK test compatibility (408/408 SDK tests passing):

- API Gateway v2 / HTTP API
- Cognito
- CloudFormation
- DynamoDB (including Streams)
- EC2
- ElastiCache (Redis + IAM auth)
- IAM
- KMS
- Kinesis
- Lambda
- RDS (PostgreSQL + MySQL + IAM auth)
- S3 (including Object Lock)
- SQS
- SNS
- STS
- And more...

## Native Image

Floci provides an experimental **native binary** build (~40 MB) for extremely fast startup and minimal memory footprint. This is useful for CI/CD pipelines and resource-constrained environments.

To use the native image:

```yaml
image:
  repository: hectorvent/floci-native
  tag: latest
```

## Development References

- **Official Repository**: https://github.com/hectorvent/floci
- **Documentation**: http://hectorvent.dev/floci/
- **Docker Hub**: https://hub.docker.com/r/hectorvent/floci

# Localstack

## Install

```bash
## Deploy LocalStack to simulate the AWS provider
task platform:localstack-install
```

The localstack access endpoint is http://localstack.127.0.0.1.nip.io (⚠️ Make sure the ingress controller is properly installed)

> ℹ️ The AWS CLI is configured to execute AWS commands on this LocalStack endpoint by default.

*Example of bucket creation in LocalStack :*

```bash
aws s3 mb s3://localstack

## List Buckets 🎉🎉🎉
aws s3 ls
```

## Uninstall

```bash
task platform:localstack-uninstall
```
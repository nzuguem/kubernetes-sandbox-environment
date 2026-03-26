# AWS Local Emulation

## 🚀 Migration to [Floci](https://hectorvent.dev/floci/)

This project has migrated from **LocalStack Community Edition** to **Floci** as the default AWS emulator. This decision reflects critical changes in LocalStack's support and licensing model.

### Why Floci?

[**LocalStack Community Edition Sunset (March 2026)**](https://blog.localstack.cloud/the-road-ahead-for-localstack/)

LocalStack's community edition is being sunset in March 2026 with the following impacts:
- ✗ Authentication tokens now required
- ✗ Security updates frozen (end of support)
- ✗ Future features locked behind paid tiers

**Floci is the Free, Open-Source Alternative**

| Feature | Floci | LocalStack Community |
|---------|-------|----------------------|
| Auth token required | ✅ No | ❌ Yes (since March 2026) |
| Security updates | ✅ Continuous | ❌ Frozen |
| Startup time | ✅ ~24 ms | ~3.3 s |
| Idle memory | ✅ ~13 MiB | ~143 MiB |
| Docker image size | ✅ ~90 MB | ~1.0 GB |
| License | ✅ MIT | ❌ Restricted |
| Native binary | ✅ ~40 MB | ❌ Not available |

**Supported Services (20+)**
- API Gateway v2 / HTTP API
- Cognito
- DynamoDB Streams
- ElastiCache (Redis + IAM auth)
- IAM (users, roles, policies, groups)
- KMS (sign, verify, re-encrypt)
- Kinesis (streams, shards, fan-out)
- RDS (PostgreSQL + MySQL + IAM auth)
- S3 Object Lock (COMPLIANCE / GOVERNANCE)
- STS (all 7 operations)
- And more...

**Compatibility**
- Full AWS SDK compatibility (Java, Python, Node.js, Go, etc.)
- 408/408 SDK tests passing
- Drop-in replacement for LocalStack

---

## Install

### Using Floci (Recommended)

```bash
## Deploy Floci to simulate the AWS provider
task control-plane:floci-install
```

The Floci access endpoint is http://floci.127.0.0.1.nip.io

> ℹ️ The AWS CLI is configured to execute AWS commands on Floci by default.

*Example of bucket creation in Floci:*

```bash
aws s3 mb s3://my-bucket

## List Buckets 🎉🎉🎉
aws s3 ls
```

### Using LocalStack (Legacy)

```bash
## Deploy LocalStack to simulate the AWS provider (deprecated)
task control-plane:localstack-install
```

To use the legacy LocalStack profile explicitly:

```bash
aws --profile localstack s3 ls
```

---

## Uninstall

### Floci
```bash
task control-plane:floci-uninstall
```

### LocalStack
```bash
task control-plane:localstack-uninstall
```

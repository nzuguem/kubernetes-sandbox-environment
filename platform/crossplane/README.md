# Platform - Crossplane
## Késako ?
Crossplane is an open-source multi-cloud control plane. As an add-on to Kubernetes, Crossplane leverages the Kubernetes API. It lets you extend a Kubernetes cluster to provision, manage and orchestrate cloud infrastructure, services and applications.

## Install
```bash
make platform-crossplane-install

## Deploy LocalStack to simulate the AWS provider
make platform-localstack-install
```

The localstack access endpoint is http://localstack.127.0.0.1.nip.io (⚠️ Make sure the ingress controller is properly installed)

> ⚠️ To use this endpoint via the AWS CLI, AWS credentials (***Dummy***) must still be configured. \
>`export AWS_ACCESS_KEY_ID=foo` \
>`export AWS_SECRET_ACCESS_KEY=bar` \
>`export AWS_DEFAULT_REGION=eu-west-3`

*Example of bucket creation in LocalStack :*
```bash
aws s3 mb s3://platform --endpoint http://localstack.127.0.0.1.nip.io

## List Buckets 🎉🎉🎉
aws s3 ls --endpoint http://localstack.127.0.0.1.nip.io
```

## Test

### Install and Configure AWS S3 Provider

> ℹ️ All providers can be found in the [Upbound marketplace][upbound-marketplace]

```bash
## Install Provider
kubectl apply -f platform/crossplane/s3.provider.yml

## Configure AWS Provider (LocalStack)
kubectl apply -f platform/crossplane/localstack.providerconfig.yml
```

### Create a managed resource

```bash
## Create S3 Bucket
kubectl create -f platform/crossplane/s3.bucket.yml

## Check that it has been properly created (SYNCHED = True, READY = True)
kubectl get buckets
#NAME                      SYNCED   READY   EXTERNAL-NAME             AGE
#crossplane-bucket-ltjlr   True     True    crossplane-bucket-ltjlr   77s

## Verify with AWS provider (LocalStack)
aws s3 ls --endpoint http://localstack.127.0.0.1.nip.io
# 2024-04-26 09:02:03 crossplane-bucket-ltjlr
```

The big difference with tools like **Terraform* is that Crossplane extends the Kubernetes reconciliation loop mechanism, providing a controller that will reconcile the current state with the desired state. And this state is stored in the ETCD.

If I delete the S3 bucket from AWS, Crossplane will recreate it :

```bash
## Delete S3 Bucket from AWS
aws s3api delete-bucket --bucket crossplane-bucket-ltjlr  --endpoint http://localstack.127.0.0.1.nip.io

## ⏳⏳⏳ - Wait at least 10 min (this value can be configured on the crossplane controller)


## Verify with AWS provider (LocalStack)
aws s3 ls --endpoint http://localstack.127.0.0.1.nip.io
# 2024-04-26 09:29:33 crossplane-bucket-p27z2
```

### Delete a managed resource

If you delete the resource from kubernetes, crossplane will delete it from the AWS provider. The deletion policy remains configurable (`deletionPolicy: <Delete | Orphan>`), however.

```bash
## Delete S3 Bucket
kubectl delete bucket/crossplane-bucket-ltjlr

## Verify with AWS provider (LocalStack) - The S3 bucket should no longer be present
aws s3 ls --endpoint http://localstack.127.0.0.1.nip.io
```

## Uninstall
```bash
make platform-localstack-uninstall
make platform-crossplane-uninstall
```

## Resources

- [Crossplane By Devoteam][crossplane-blog-devoteam]
- [Crossplane By WeScale][crossplane-blog-wescale]

<!-- Links -->
[crossplane-blog-devoteam]: https://france.devoteam.com/paroles-dexperts/crossplane/
[crossplane-blog-wescale]: https://blog.wescale.fr/infra-as-code-depuis-kubernetes-avec-crossplane
[upbound-marketplace]: https://marketplace.upbound.io/

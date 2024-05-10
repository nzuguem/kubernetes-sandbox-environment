# Platform - [Crossplane][crossplane-doc]
## Késako ?
Crossplane is an open-source multi-cloud control plane. As an add-on to Kubernetes, Crossplane leverages the Kubernetes API. It lets you extend a Kubernetes cluster to provision, manage and orchestrate cloud infrastructure (AWS, GCP, Azure, etc...), services and applications.

## Install
```bash
task platform:crossplane-install
```

> ℹ️ Our tests will use the AWS provider, and to simulate it, we'll use LocalStack. See this [guide to installing LocalStack in a Kubernetes cluster](../aws/INSTALL.md)

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
aws s3 ls
# 2024-04-26 09:02:03 crossplane-bucket-ltjlr
```

The big difference with tools like **Terraform* is that Crossplane extends the Kubernetes reconciliation loop mechanism, providing a controller that will reconcile the current state with the desired state. And this state is stored in the ETCD.

If I delete the S3 bucket from AWS, Crossplane will recreate it :

```bash
## Delete S3 Bucket from AWS
aws s3api delete-bucket --bucket crossplane-bucket-ltjlr

## ⏳⏳⏳ - Wait at least 10 min (this value can be configured on the crossplane controller)


## Verify with AWS provider (LocalStack)
aws s3 ls
# 2024-04-26 09:29:33 crossplane-bucket-p27z2
```

### Delete a managed resource

If you delete the resource from kubernetes, crossplane will delete it from the AWS provider. The deletion policy remains configurable (`deletionPolicy: <Delete | Orphan>`), however.

```bash
## Delete S3 Bucket
kubectl delete bucket/crossplane-bucket-ltjlr

## Verify with AWS provider (LocalStack) - The S3 bucket should no longer be present
aws s3 ls
```

## Uninstall

```bash
task platform:crossplane-uninstall
```

## Resources

- [Crossplane By Devoteam][crossplane-blog-devoteam]
- [Crossplane By WeScale][crossplane-blog-wescale]

<!-- Links -->
[crossplane-blog-devoteam]: https://france.devoteam.com/paroles-dexperts/crossplane/
[crossplane-blog-wescale]: https://blog.wescale.fr/infra-as-code-depuis-kubernetes-avec-crossplane
[upbound-marketplace]: https://marketplace.upbound.io/
[crossplane-doc]:https://www.crossplane.io/

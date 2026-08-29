# Security - [External Secrets Operator][eso-doc]

## Késako ?

External Secrets Operator is a Kubernetes operator that integrates external secret management systems like AWS Secrets Manager, HashiCorp Vault, Google Secrets Manager, Azure Key Vault, IBM Cloud Secrets Manager, CyberArk Conjur and many more. The operator reads information from external APIs and automatically injects the values into a Kubernetes Secret.

![External Secret Operator](../images/eso.jpeg)

## Install

```bash
## Install External Secret Operator
task security:eso-install
```

> ℹ️ Our tests will use the AWS Secret Manager, and to simulate it, we'll use LocalStack. See this [guide to installing LocalStack in a Kubernetes cluster](../../control-plane/aws/INSTALL.md)
>
> **Endpoint LocalStack (for [AWS Secret Manager][eso-aws-custom-endpoints]) is added during ESO installation**

## Test

```bash
## Create Secret Store
kubectl apply -f security/ESO/secretmanager.store.yml

## Storing a secret in AWS Secret Manager
aws secretsmanager create-secret \
    --name my-eso-secret \
    --description "My ESO Secret." \
    --secret-string "{\"password\":\"eso\"}"

## Link between an External Secret (on AWS Secret Manager) and a Secret in Kubernetes : ExternalSecret object
kubectl apply -f security/ESO/password.secret.yml

## Check that secrets (ExternalSecret and AWS Secret Manager) are synchronized
kubectl get es,secret
# NAME                                              STORE                REFRESH INTERVAL   STATUS         READY
# externalsecret.external-secrets.io/app-password   aws-secret-manager   1h                 SecretSynced   True
# NAME                                      TYPE                 DATA   AGE
# secret/app-password                       Opaque               1      2m27s

## Checking the contents of the Kubernes secret : "eso"
kubectl get secret/app-password -o jsonpath="{.data.app-password}" | base64 -d

## 🎉🎉 Simply reference Secret Kubernetes in our Workloads.
```

### [Generators](https://external-secrets.io/v2.9.0/guides/generator/)

External Secrets Operator (ESO) Generators are stateless custom resources that produce fresh values (passwords, SSH keys, cloud tokens, Vault dynamic secrets, etc.) on every invocation. Referenced via  generatorRef  in an  ExternalSecret , they pair with  refreshInterval  to automatically regenerate credentials on a set cadence — no human action required. This makes them a cornerstone of any key rotation strategy: secrets become short-lived and ephemeral, drastically reducing the blast radius of a compromise and aligning with compliance mandates (SOC 2, PCI-DSS) that require periodic credential renewal.

```bash
kubectl apply -f security/ESO/password.generator.yml
kubectl apply -f security/ESO/password-generator.secret.yml

kubectl get secret cluster-secret -o jsonpath="{.data.password}" | base64 -d
# CyjmV8XC5_W6bs@ntfdcYuZy9V_9x@zuomCu_ezHsZ

# Few seconds later
kubectl get secret cluster-secret -o jsonpath="{.data.password}" | base64 -d
# Uant1O@jA_XI9n-gsY_rSRslYPRrDac2HzwfyY@U65
```

Generators exist for certain components (GitLab, GitHub, SSHKey, Grafana, etc.). And it is possible to create generators for our specific components via the [WebHook generator](https://external-secrets.io/latest/api/generator/webhook/)

```bash
# Rotate Temporal API Keys

## Create Root API Key (Global Admin Service Account)
kubectl create secret generic temporal-api-key-root --from-literal=value=<SERVICE_ACCOUNT_GLOBAL_ADMIN_API_KEY>
kubectl label secret temporal-api-key-root external-secrets.io/type=webhook

## Create WebHook Generator
### ⚠️⚠️ put the rights value on webhook.spec.body (related of your Temporal Cloud Informations)
kubectl apply -f security/ESO/temporal-api-keys-gen.generator.yml

## Create ExternalSecret
kubectl apply -f security/ESO/temporal-api-keys-gen.secret.yml

# Few seconds later
kubectl get secret temporal-api-key -o jsonpath="{.data.token}" | base64 -d
```

> ⚠️ If the secret has been set as an environment variable, you should consider restarting the deployment to take the new secret into account.The [Reloader Controller](https://docs.stakater.com/reloader/latest/) might help

## Uninstall

```bash
kubectl delete -f security/ESO/secretmanager.store.yml
kubectl delete -f security/ESO/password.secret.yml

task security:eso-uninstall
```

## Resources

- [GESTION DES SECRETS SUR KUBERNETES][k8s-secret-management-blog]
- [Secrets store CSI driver vs external secrets in a nutshel][eso-vs-csi-secrets-store]
- [Clarity: secrets store CSI driver vs external secrets... what to use? #478][eso-vs-csi-secrets-store-clarity]

<!-- Links -->
[eso-doc]:https://external-secrets.io/latest/
[k8s-secret-management-blog]: https://toungafranck.com/2024/05/09/gestion-des-secret-sur-kubernetes/
[eso-aws-custom-endpoints]: https://external-secrets.io/latest/provider/aws-secrets-manager/#custom-endpoints
[eso-vs-csi-secrets-store]: https://www.yuribacciarini.com/secrets-store-csi-driver-vs-external-secrets-in-a-nutshel/
[eso-vs-csi-secrets-store-clarity]: https://github.com/external-secrets/external-secrets/issues/478

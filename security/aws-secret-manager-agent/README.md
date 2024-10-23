# [AWS Secrets Manager Agent][aws-secretsmanager-agent-gh]

## Késako

The Secrets Manager Agent is an open-source tool that enables your applications to retrieve secrets from a local HTTP service rather than connecting to Secrets Manager over the network. It offers customizable configuration options, such as time-to-live, cache size, maximum connections, and HTTP port, allowing developers to tailor the agent to their application's specific needs.

The agent retrieves and stores secrets in memory, allowing applications to access cached secrets directly without calling Secrets Manager. This means an application can obtain its secrets from the local host.

> ⚠️ **It's important to note that the agent can only make read requests to Secrets Manager and cannot modify the secrets.**

## Test

In our demo, we're going to use it as a [sidecar container](../../discovery/sidecar-container-support-1.29-beta/) in a workload.

> ℹ️ AWS credentials must have at least the following permissions:
>
> - `secretsmanager:DescribeSecret`
> - `secretsmanager:GetSecretValue`

```bash
## Create KLey on AWS Secret Manager
AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID> AWS_ACCESS_SECRET_KEY=<AWS_ACCESS_SECRET_KEY> task security:asma-create-secret

## Creata ConfigMap for ASMA Config
kubectl apply -f security/aws-secret-manager-agent/asma.cm.yml

## Deploy Workload
kubectl apply -f security/aws-secret-manager-agent/asma.deploy.yml

## Logs Workload Activities (Retrieve secrets every 5 seconds)
kubectl logs deploy/asma-deployment -c curl -f

# {"ARN":"arn:aws:secretsmanager:eu-west-3:005072761142:secret:asma-key-Msj1ze","Name":"asma-key","VersionId":"28245f30-e421-4dd1-b421-f5ad049f1267","SecretString":"{\"key\":\"value\"}","VersionStages":["AWSCURRENT"],"CreatedDate":"1729509676.851"}
# {"ARN":"arn:aws:secretsmanager:eu-west-3:005072761142:secret:asma-key-Msj1ze","Name":"asma-key","VersionId":"28245f30-e421-4dd1-b421-f5ad049f1267","SecretString":"{\"key\":\"value\"}","VersionStages":["AWSCURRENT"],"CreatedDate":"1729509676.851"}
# {"ARN":"arn:aws:secretsmanager:eu-west-3:005072761142:secret:asma-key-Msj1ze","Name":"asma-key","VersionId":"28245f30-e421-4dd1-b421-f5ad049f1267","SecretString":"{\"key\":\"value\"}","VersionStages":["AWSCURRENT"],"CreatedDate":"1729509676.851"}
# ...
```

🚧 **How to log ASMA cache activities ?**

## Clean

```bash
kubectl delete -f security/aws-secret-manager-agent/asma.deploy.yml
kubectl delete -f security/aws-secret-manager-agent/asma.cm.yml
kubectl delete secret/aws-secrets
```

## Resources

<!-- Links -->
[aws-secretsmanager-agent-gh]: https://github.com/aws/aws-secretsmanager-agent

# [Use an Image Volume With a Pod - v1.31 [alpha]][image-volume-pod-doc]

🏷️ **v1.35 [GA]**

## Késako ?

A few use cases :

- Users could share a configuration file among multiple containers in a pod without including the file in the main image, so that they can minimize security risks and the overall image size. They can also package and distribute binary artifacts using OCI images and mount them directly into Kubernetes pods

- Data scientists, MLOps engineers, or AI developers, can mount large language model weights or machine learning model weights in a pod alongside a model-server, so that they can efficiently serve them without including them in the model-server container image. They can package these in an OCI object to take advantage of OCI distribution and ensure efficient model deployment. This allows them to separate the model specifications/content from the executables that process them.

## Test

```bash
kubectl apply -f discovery/image-volume-with-pod-1.31-alpha/image-volumes.yml

## Check
kubectl exec po/image-volume -- ls /volume
```

We can see that the FileSystem of the `nzuguem/java-runtime:21.0.5_11-jre` image is mounted in the `/volume` directory of the Pod container.

> ⚠️ Image Volumes require proper OCI images with filesystem layers, not ORAS artifacts.

> [ORAS artifacts](https://oras.land/docs/concepts/artifact/) store files as opaque blob layers designed for generic artifact distribution (Helm charts, SBOMs, etc.), but they don’t have the filesystem layer structure that container runtimes can mount. Image Volumes specifically need OCI images built with tools like Docker, Podman, or Buildah that create proper tar.gz filesystem layers with the required **rootfs** metadata.

## Resources

- [Kubernetes 1.31 : volumes en lecture seule basés sur des artefacts OCI (alpha)][kubernetes-1-31-image-volume-source]
<!-- Links -->
[image-volume-pod-doc]: https://kubernetes.io/docs/tasks/configure-pod-container/image-volumes/
[kubernetes-1-31-image-volume-source]: <https://kubernetes.io/blog/2024/08/16/kubernetes-1-31-image-volume-source/>

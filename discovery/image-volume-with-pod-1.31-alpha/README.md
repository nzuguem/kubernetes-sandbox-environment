# [Use an Image Volume With a Pod][image-volume-pod-doc]

## Késako ?

A few use cases :

- Users could share a configuration file among multiple containers in a pod without including the file in the main image, so that they can minimize security risks and the overall image size. They can also package and distribute binary artifacts using OCI images and mount them directly into Kubernetes pods

- Data scientists, MLOps engineers, or AI developers, can mount large language model weights or machine learning model weights in a pod alongside a model-server, so that they can efficiently serve them without including them in the model-server container image. They can package these in an OCI object to take advantage of OCI distribution and ensure efficient model deployment. This allows them to separate the model specifications/content from the executables that process them.

## Test

```bash
kubectl apply -f discovery/image-volume-with-pod-1.31-alpha/image-volumes.yml
```

We got this error because `Kind` uses `containerd` as Container Runtime, and it does not yet support this feature (Read this [comment][issuecomment-gh-kind-image-volume]) :

```log
  Warning  Failed     2m54s (x58 over 16m)  kubelet            (combined from similar events): Error: failed to generate container "b2af7fef90779276e347682badccc61c70fa8131a42b7b8a6a832c54a351a236" spec: failed to apply OCI options: failed to mkdir "": mkdir : no such file or directory
```

## Resources

- [Kubernetes 1.31 : volumes en lecture seule basés sur des artefacts OCI (alpha)][kubernetes-1-31-image-volume-source]
<!-- Links -->
[image-volume-pod-doc]: https://kubernetes.io/docs/tasks/configure-pod-container/image-volumes/
[kubernetes-1-31-image-volume-source]: <https://kubernetes.io/blog/2024/08/16/kubernetes-1-31-image-volume-source/>
[issuecomment-gh-kind-image-volume]: https://github.com/kubernetes-sigs/kind/issues/3745#issuecomment-2368749584

# [Sidecar Container Support - v1.29 [beta]][sidecar-container-support-doc]

## Késako ?

Sidecar containers are the secondary containers that run along with the main application container within the same Pod. These containers are used to enhance or to extend the functionality of the primary app container by providing additional services, or functionality such as logging, monitoring, security, or data synchronization, without directly altering the primary application code.

Typically, you only have one app container in a Pod. For example, if you have a web application that requires a local webserver, the local webserver is a sidecar and the web application itself is the app container.

For testing, we will use these applications:

- **zwindler/slow-sidecar**, a basic helloworld in V lang (vhelloworld) that sleeps for 5 seconds before listening on port 8081.
- **zwindler/sidecar-user**, a bash script that performs a curl request and exits with status 1 if the curl fails.

## Classic approach (pre v.1.28)

For Kubernetes, these two types of containers fundamentally have no difference in terms of lifecycle and management (both declared in
 `.spec.containers`). This similarity causes some issues in the use of sidecar containers:

- In the case of a Job, if the main container finishes, but the sidecar container continues running, it prevents the Job from correctly determining whether the Pod has terminated successfully.
- The sidecar container starts too late, causing the main container to be unable to use it when it starts, leading to errors that require waiting for the container to restart.

Regarding the second issue, common examples include:

- In cases like Istio, where the Istio sidecar container starts later than the main container, causing momentary network unavailability when the main container starts.
- In Google Kubernetes Engine (GKE), when accessing Cloud SQL through the Cloud SQL proxy, if the Cloud SQL proxy starts later than the main container, the main container cannot connect to the database, resulting in errors.

### Test

```bash
kubectl apply -f experimental/sidecar-container-support-1.29-beta/sidecar-container-classic.cronjob.yml

## List the containers of a Pod with their Status
kubectl get po/<POD_NAME> -o jsonpath='{range .status.containerStatuses[*]}{.name}{"\t"}{.state}{"\n"}{end}'

# app    {"terminated":{...,"reason":"Error","startedAt":"2024-09-27T08:17:13Z"}}
# sidecar    {"running":{"startedAt":"2024-09-27T08:17:38Z"}}
```

**We can see that the main container is failing. This is normal, as the sidecar started very slowly (5 seconds late).**

> ⚠️ To force the sidecar to start before the app, we could consider moving the sidecar to the `.spec.initContainers` section, BUT our sidecar is a server and doesn't stop (*not ideal for an initContainers*), so the application will never be started.

## Sidecar container Support

To avoid this type of race condition, let's update the manifest by converting sidecar to initContainer BUT ALSO ADDING `restartPolicy: Always` to the declaration of the sidecar container.

This trick is the way to tell Kubernetes to launch this container as an initContainer but NOT to wait for it to finish (*which it never will, since it's a web server listening on 8081 until the end of time*) before starting the main application.

Sidecar containers can interact directly with the main application containers, because like init containers they always share the same network, and can optionally also share volumes (filesystems).

**By default, the kubelet considers that the sidecar container is up as soon as the process in the container is running.** Unfortunately, in some cases, the sidecar container is very slow to start, so the fact that the process is running is not an indication of the state of the sidecar. **We need to add a startupProbe so that Kubernetes knows WHEN to skip the init phase and start the main phase.**

### Test

```bash
kubectl apply -f experimental/sidecar-container-support-1.29-beta/sidecar-container-support.cronjob.yml

## List the containers of a Pod with their Status
kubectl get pod/<POD_NAME> -o jsonpath='{range .status.initContainerStatuses[*]}{.name}{"\t"}{.state}{"\n"}{end}{range .status.containerStatuses[*]}{.name}{"\t"}{.state}{"\n"}{end}'

# sidecar {"terminated":{...,"exitCode":137,"reason":"Error",...}}
# app     {"terminated":{...,"exitCode":0, "reason":"Completed",...}}
```

You can see that the application finishes normally (`reason: completed`). For the sidecar, it's normal to have an `exitCode: 137`, because the **Job finished state (app)**, the kubelet asked for the sidecar to be stopped.

## Resources

- [Kubernetes 1.29 - sidecar container - à quoi ça peut bien servir ?][sidecar-container-support-blog-zwindler]
- [Exploring Kubernetes 1.28 Sidecar Container Support][sidecar-container-support-blog-hungWei-chiu]

<!-- Links -->
[sidecar-container-support-doc]:https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/
[sidecar-container-support-blog-zwindler]: https://blog.zwindler.fr/2024/07/19/kubernetes-1-29-sidecar-containers/
[sidecar-container-support-blog-hungWei-chiu]: https://hwchiu.medium.com/exploring-kubernetes-1-28-sidecar-container-support-ed1a39ac7fe0

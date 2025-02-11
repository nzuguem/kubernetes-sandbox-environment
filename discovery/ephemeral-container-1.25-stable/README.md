# [Ephemeral Container - v1.25 [stable]][ephemeral-container-doc]

## Késako ?

Ephemeral Container is a special type of container that runs temporarily in an existing Pod to accomplish user-initiated actions such as **troubleshooting**.

Ephemeral containers provide a solution for interactive troubleshooting when `kubectl exec` is inadequate, such as when a container has crashed or lacks debugging utilities. This is especially useful for distroless images, which are minimalistic and designed to reduce the attack surface, bugs, and vulnerabilities by excluding a shell or debugging tools. Due to these limitations, traditional troubleshooting methods like `kubectl exec` are insufficient, making ephemeral containers crucial for diagnosing issues in distroless environments.

Ephemeral containers are created using a special `ephemeralcontainers` handler in the API rather than by adding them directly to `pod.spec`, so it's not possible to add an ephemeral container using kubectl edit. It is added using the `kubectl debug` command

## Test

```bash
## Deploy HTTP Server
kubectl apply -f discovery/ephemeral-container-1.25-stable/http-server-distroless.deploy.yml

## Let's try connecting to the Pod as we would for a debugging session
POD_NAME=$(kubectl get pods -l app=http-server -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -- bash # exec: "bash": executable file not found in $PATH: unknown
kubectl exec -it $POD_NAME -- sh -c "ls" # sh: 1: ls: not found
```

We have found that it is impossible to connect to our workload with a Shell for debugging purposes. `kubectl debug` to the rescue

```bash
## Creation of an ephemeral container called debugger. This must contain the tools needed for debugging -> busybox
## --attach=false: If true, wait for the container to start running, and then attach as if 'kubectl attach ...' were called.
##  Default false, unless '-i/--stdin' is set, in which case the default is true.
kubectl debug -it --attach=false -c debugger --image=busybox ${POD_NAME}

## Show ephemeral container
kubectl describe po/$POD_NAME
# ...
# Ephemeral Containers:
#  debugger:
#    Image:          busybox
# ...

## Attaching to the ephemeral container
kubectl attach -it -c debugger ${POD_NAME}

/# wget -O - localhost:8080
# Connecting to localhost:8080 (127.0.0.1:8080)
# writing to stdout
# <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
# <html>
# ...

/# ps auxf
# PID   USER     TIME  COMMAND
#   1 root      0:00 sh
#   11 root      0:00 ps auxf
```

With the `ps auxf` command, you can't see the main container process, BUT the `wget` works quite well. This means that the `net` namspace is shared with the ephemeral container, BUT not the `pid` namespace.

To solve this problem, you would need to enable sharing of the pid namespace with other Pod containers (*initContainers, epehemeralContainers, containers*) :

> ⚠️ **By doing this, we skew container isolation. In addition, you need to restart the deployment.**

```bash
## Patch Deployement
kubectl patch deploy/http-server --patch '
spec:
  template:
    spec:
      shareProcessNamespace: true'

POD_NAME=$(kubectl get pods -l app=http-server -o jsonpath='{.items[0].metadata.name}')

kubectl debug -it -c debugger --image=busybox ${POD_NAME}
/# ps auxf
# PID   USER     TIME  COMMAND
#     1 65535     0:00 /pause
#     7 root      0:00 python -m http.server 8080
#    16 root      0:00 sh
#    25 root      0:00 ps auxf

## Although the "mnt" namespace can never be shared, we can still access the file system of the main container
/# ls /proc/$(pgrep python)/root
```

With the `--target` option in `kubectl debug`, you can share the `pid` namespace (in addition to `net`) with a container in the Pod. This is done without having to modify the `pod.spec`

```bash
## Redeploy
kubectl delete -f discovery/ephemeral-container-1.25-stable/http-server-distroless.deploy.yml
kubectl apply -f discovery/ephemeral-container-1.25-stable/http-server-distroless.deploy.yml

POD_NAME=$(kubectl get pods -l app=http-server -o jsonpath='{.items[0].metadata.name}')

kubectl debug -it -c debugger --target=http-server --image=busybox ${POD_NAME}
/# ps -auxf
# PID   USER     TIME  COMMAND
#     1 root      0:00 python -m http.server 8080
#    10 root      0:00 sh
#   19 root      0:00 ps auxf
```

It can be useful to copy a Pod before debugging. The new Pod won’t be associated with the original workload or inherit its labels, meaning it won’t be affected by any Service objects linked to the workload. This creates a quiet environment for investigation.

> ℹ️ **The copy of the Pod will not contain an ephemeral container, BUT rather a second classic container with the "shareProcessNamespace" option activated.**

```bash
kubectl debug -it -c debugger --image=busybox --copy-to debug-pod --share-processes ${POD_NAME}
/# ps auxf
# PID   USER     TIME  COMMAND
#     1 65535     0:00 /pause
#     7 root      0:00 python -m http.server 8080
#    16 root      0:00 sh
#    25 root      0:00 ps auxf

## Chow copy of Main Pod
kubectl get po
# NAME                           READY   STATUS              RESTARTS      AGE
# debug-pod                      2/2     Running             1 (83s ago)   3m29s
# http-server-7d4dd5b544-czjm7   1/1     Running             0             15m
```

### Debug App Java ☕

```bash
## Deploy Spring Petclinic Application
kubectl apply -f discovery/ephemeral-container-1.25-stable/spring-petclinic.deploy.yml

## Begin Debug : JFR Recording / Jcmd
POD_NAME=$(kubectl get pods -l app=spring-petclinic -o jsonpath='{.items[0].metadata.name}')

## "general" Profile -> https://github.com/kubernetes/enhancements/tree/master/keps/sig-cli/1441-kubectl-debug#profile-general
kubectl debug -it -c debugger --target=spring-petclinic --image=eclipse-temurin:17-jdk ${POD_NAME} --profile=general -- bash

/# ps auxf
# USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root         463  0.0  0.0   7452  3944 pts/0    Ss   05:47   0:00 bash
# root         513  0.0  0.0  10588  4088 pts/0    R+   05:48   0:00  \_ ps auxf
# 999            1  3.0  4.4 9240128 590848 ?      Ssl  05:20   0:50 /media/rosetta/rosetta /opt/java/openjdk/bin/java java -jar /usr/local/jetty/start.jar

/# jcmd
# 1 /usr/local/jetty/start.jar
# 514 jdk.jcmd/sun.tools.jcmd.JCmd

/# jps
# 1 start.jar
# 534 Jps

/# jcmd 1 JFR.start duration=15s filename=/tmp/record.jfr

/# ls /proc/1/root/tmp

# Upload JFR Record
/# curl --upload-file /proc/1/root/tmp/record.jfr  https://transfer.whalebone.io/record.jfr
# https://transfer.whalebone.io/<UNIQUE-ID>/record.jfr

# Download JFR Record
/# curl https://transfer.whalebone.io/<UNIQUE-ID>/record.jfr -o record.jfr
# The JFR Record can be operated using the JMC (JDK Mission Control) tool.
```

## Resources

- [Kubernetes Ephemeral Containers and kubectl debug Command][kubernetes-ephemeral-containers-blog-iximiuz]
- [Kubernetes : déboguer avec les conteneurs éphémères][k8s-debug-ephemeral-containers-blog-adaltas]
- [Programmer’s Guide to the JDK Flight Recorder][jfr-jfokus-2023-pdf]

<!-- Links -->
[ephemeral-container-doc]: https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/
[kubernetes-ephemeral-containers-blog-iximiuz]: https://iximiuz.com/en/posts/kubernetes-ephemeral-containers/
[k8s-debug-ephemeral-containers-blog-adaltas]: https://www.adaltas.com/fr/2023/02/07/k8s-debug-ephemeral-containers/
[jfr-jfokus-2023-pdf]: https://www.jfokus.se/jfokus23-preso/Programmers-Guide-to-JDK-Flight-Recorder.pdf

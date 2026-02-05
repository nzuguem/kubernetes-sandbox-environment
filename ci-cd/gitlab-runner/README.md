# [Gitlab Runner - Kubernetes Executor][gitlab-runner-k8s-executor]

## Késako ?

## Install

Installation begins by [create a runner][gitlab-runner-create] via the Gitlab GUI.
After you create a runner and its configuration, you receive a runner authentication token that you use to register the runner.

```bash
task ci-cd:gitlab-runner-register/<AUTH_TOKEN>
```

## Test

## Uninstall

```bash
task ci-cd:gitlab-runner-register/<AUTH_TOKEN>
```

## Resources
- [How to Configure GitLab CI Runners on Kubernetes](https://oneuptime.com/blog/post/2026-01-27-gitlab-ci-runners-kubernetes)

<!-- Links -->
[gitlab-runner-k8s-executor]: https://docs.gitlab.com/runner/executors/kubernetes
[gitlab-runner-create]: https://docs.gitlab.com/ci/runners/runners_scope/#create-a-project-runner-with-a-runner-authentication-token

#!/usr/bin/env bash

# Kubectl

## Useful resources

- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- kubectl for Docker Users: https://kubernetes.io/docs/reference/kubectl/docker-cli-to-kubectl/
- kubectl plugins: https://github.com/ishantanu/awesome-kubectl-plugins
  - view existing plugins: `krew list` or `kubectl krew list`
- Debug Running Pods: https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/

## View pods

```bash
# View the definition of an existing pod (or other resource)
kubectl get pod ${name} -o yaml
kubectl neat get pod ${name} -o yaml

# Find a pod by selector label
kubectl get pods -l ${label}
kubectl get pods --selector ${label}

kubectl get pods --selector ${label1} --selector ${label2} # label1 OR label2
kubectl get pods --selector "${label1},${label2}" # label1 AND label2

# Pod output options
kubectl get pod ${filter} -o yaml
kubectl get pod ${filter} -o json
kubectl get pod ${filter} -o name
```

# Find a container within a pod
```bash
json=$(kubectl get pod ${filter} -o json)
containers=$(echo ${json} | jq '.spec.containers[].name')
echo $containers
initContainers=$(echo ${json} | jq '.spec.initContainers[].name')
echo $initContainers
# container=$(echo $json | jq "select(.items[].spec.containers[]${container_filter})" | jq '.items[].spec.containers[].name')
```

## Manage pods

```bash
# Delete evicted pods
# This general pattern would be useful for a lot of different kubectl commands
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod
kubectl delete pods --field-selector=status.phase=Evicted # --all-namespaces

# Run a new pod in a cluster
kubectl run myapp --image=${image}
# Specify resource limits
kubectl run myapp --image=${image} --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi'

# Scale a deployment
kubectl scale deployment ${deployment} --replicas=1

# Apply a resource directly from the command line
kubectl apply -f - <<EOF
apiVersion: v1
kind: ResourceQuota
metadata:
  name: app-quota
spec:
  hard:
    requests.cpu: "19200m"
    requests.memory: "137160Mi"
  scopes:
  - NotTerminating
EOF
```

## Manage secrets

```bash
kc get secret db-svc-acct -o json | jq '.data | map_values(@base64d)'
```

## RBAC

```bash
# Can a particular user do a particular thing?
kubectl auth can-i <verb> <resource> --as=<account>
kubectl auth can-i create customresourcedefinitions --as=system:serviceaccount:namespace:svc-account

# Who can do a particular thing
kubectl who-can <verb> <resource>
kubectl who-can create pods

# View an access matrix for a resource
kubectl access-matrix resource <resource>

# View an access matrix for a user
kubectl access-matrix --as <user>
```

## Debugging

```bash
# debug as root (technically an OpenShift command)
oc debug pod --as-user=0

# Start a pod with a specified image
kubectl run jro-debug --image=busybox --restart=Never
kubectl run -it jro-debug --image=busybox --restart=Never
kubectl run jro-debug --image=${DEBUG_IMAGE} --restart=Never -- cmd # -- cmd is optional
# Specify environment variable(s)
kubectl run jro-debug --image=${DEBUG_IMAGE} --restart=Never --env="key=value" -- cmd # -- cmd is optional
# Override nodeSelector
kubectl run jro-debug --image=${DEBUG_IMAGE} --restart=Never --overrides='{ "apiVersion": "v1", "spec": { "template": { "spec": { "nodeSelector": { "network": "<network>" } } } } }' -- cmd
# Start in the foreground, interactively
kubectl run -it jro-debug --image=${DEBUG_IMAGE} --restart=Never -- /bin/bash

## Attach mssql-cli
RELEASE=hilton && DB=${db} && kubectl run -it --rm db-cli --image="emergn/mssql-cli" -- -U SA -P ${password} -d ${DB} -S ${RELEASE}

# Execute a command against a running pod
kubectl exec my-app -- cmd

# Attach to a running pod interactively
kubectl exec -it podname -- /bin/bash

# Debugging with ephemeral containers
# NOTE: Requires k8s 1.18+
kubectl run ephemeral-demo --image=k8s.gcr.io/pause:3.1 --restart=Never
kubectl debug -it ephemeral-demo --image=busybox --target=ephemeral-demo
```

## Cronjobs

```bash
# Manually generate a new job from a cronjob
kubectl create job --from=cronjob/<name-of-cron-job> <name-of-new-job>
```
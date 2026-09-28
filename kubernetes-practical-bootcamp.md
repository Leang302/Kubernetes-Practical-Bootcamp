# Kubernetes Practical Bootcamp

A fast, production-minded Kubernetes learning path for engineers who already know Docker, Spring Boot, REST APIs, Git, and CI/CD.

This course is optimized for:

- 20% theory
- 80% hands-on practice
- Learn → Build → Break → Debug → Improve → Apply best practices

This file is intentionally written in a GitHub-friendly, browser-readable format so it renders well in HTML, Markdown preview, and GitHub. The structure is simple:

- one clear topic per section
- headings for scanning
- short blocks of explanation
- command examples in fenced code blocks
- quick-reference tables and checklists
- good for commit history, PR review, and personal study notes

## Start here

### What you will learn

By the end of this bootcamp, you should be able to deploy a containerized application, explain how Kubernetes routes and manages workloads, debug common failures from cluster evidence, and make informed production trade-offs.

### Suggested path

1. Set up a local cluster with `kind` or Docker Desktop.
2. Work through the fundamentals and resource sections.
3. Deploy the sample full-stack architecture in small steps.
4. Break one part at a time and use events, logs, probes, and endpoints to find the cause.
5. Add security, observability, Helm, and CI/CD after the basic app works.

### How to read this on GitHub

GitHub renders this Markdown as HTML. Use the table of contents below to jump to a topic; GitHub also adds a heading-link icon when you hover over section headings. Keep the `.md` file as the source so edits, diffs, and search remain convenient.

## Table of contents

- [Git workflow](#git-workflow-for-your-kubernetes-notes-repo)
- [Research basis and source quality](#research-basis-and-source-quality)
- [How to use this course](#how-to-use-this-course)
- [Phase 1: Fundamentals](#phase-1--fundamentals)
- [Core Kubernetes resources](#core-kubernetes-resources)
- [kubectl mastery](#kubectl-mastery)
- [YAML and manifest best practices](#yaml--manifest-best-practices)
- [Networking](#networking)
- [Configuration and secrets](#configuration--secrets)
- [Resource management](#resource-management)
- [Health checks](#health-checks)
- [Scaling and reliability](#scaling--reliability)
- [Security best practices](#security-best-practices)
- [Kubernetes production best practices](#kubernetes-production-best-practices)
- [Build one real project](#build-one-real-project)
- [Break things intentionally](#break-things-intentionally)
- [Local Kubernetes environment](#local-kubernetes-environment)
- [Helm](#helm)
- [CI/CD](#cicd)
- [Observability](#observability)
- [Best-practice review checklist](#best-practice-review-checklist)
- [Final capstone challenge](#final-capstone-challenge)
- [30-day learning roadmap](#30-day-learning-roadmap)
- [Final mindset](#final-mindset)
- [Recommended next steps](#recommended-next-steps)

---

## Git workflow for your Kubernetes notes repo

This is the practical flow I recommend while learning Kubernetes and keeping your notes in Git.

### 1. Create the repo

```bash
mkdir kubernetes-learning
cd kubernetes-learning
git init
git branch -M main
```

### 2. Add your notes

```bash
touch kubernetes-practical-bootcamp.md
git status
git add kubernetes-practical-bootcamp.md
git commit -m "Add Kubernetes practical bootcamp notes"
```

### 3. Push to GitHub

```bash
git remote add origin git@github.com:YOUR_USERNAME/kubernetes-learning.git
git push -u origin main
```

If you use HTTPS instead:

```bash
git remote add origin https://github.com/YOUR_USERNAME/kubernetes-learning.git
git push -u origin main
```

### 4. Pull updates later

```bash
git pull --ff-only origin main
```

### 5. Create a feature branch for a new topic

```bash
git checkout -b add-helm-section
# make edits
git add .
git commit -m "Add Helm section"
git push -u origin add-helm-section
```

### 6. Keep your notes clean

```bash
git status
git diff
git log --oneline --decorate --graph --all
```

### 7. Good repo practices

- keep each topic in its own commit
- use descriptive commit messages
- store notes in Markdown for GitHub readability
- add a `.gitignore` if you keep local cluster artifacts or generated files
- avoid committing secrets or cloud credentials

### 8. Recommended `.gitignore`

```gitignore
.DS_Store
.env
*.log
tmp/
local-cluster/
secrets/
```

### 9. GitHub-first learning workflow

Use a simple pattern:

1. learn a concept
2. write a short note or example
3. commit it
4. push it to GitHub
5. review it in browser
6. improve it based on what you learned

This keeps your knowledge searchable, versioned, and easy to revisit.

> Markdown is especially good for GitHub because GitHub automatically renders it to HTML, making it readable in the browser while staying easy to edit and track in Git.

---

## Research basis and source quality

This course is grounded in current Kubernetes documentation and widely used engineering references. The emphasis is on what is recommended today, not old blog advice.

Primary sources used:

- Kubernetes official docs: https://kubernetes.io/docs/
- Kubernetes concepts: https://kubernetes.io/docs/concepts/
- Kubernetes tasks and tutorials: https://kubernetes.io/docs/tasks/
- CNCF Kubernetes resources and ecosystem guidance: https://www.cncf.io/
- Kubernetes API reference and networking docs

Important distinctions:

### Kubernetes fundamentals

These are stable, core concepts that are foundational and should be understood deeply:

- containers vs Kubernetes
- cluster architecture
- control plane vs worker nodes
- Pods, Deployments, Services, Namespaces, ConfigMaps, Secrets
- labels, selectors, networking, health checks, resource requests/limits

### Recommended practices

These are the patterns most teams should adopt:

- Deployments for stateless workloads
- Services to abstract Pods
- readiness and liveness probes for reliability
- ConfigMaps for non-sensitive config
- Secrets for sensitive config
- resource requests and limits
- rolling updates with health checks
- labels and namespaces for organization and policy

### Production best practices

These are what matter in real environments:

- least privilege RBAC
- network policy isolation
- multi-replica workloads and pod disruption handling
- health-probe-driven rollouts
- graceful shutdown
- external secret management and secret rotation
- observability, metrics, logs, events
- GitOps or declarative manifests in version control

### Optional or advanced practices

These are useful but not required for beginners:

- Helm for packaging
- Gateway API for advanced networking
- autoscaling strategies (HPA, VPA)
- admission policies
- service meshes
- custom resource definitions and operators

### Outdated or no longer recommended

These are things learners should know to avoid:

- managing Pods directly in production instead of using workload controllers
- using NodePort for public internet exposure where Ingress or a cloud LB is cleaner
- hardcoding secrets into container images or manifests
- using `externalIPs` as a normal production pattern (deprecated in newer Kubernetes guidance)
- relying on `kubectl --record` for change cause history (deprecated)
- using a single replica for critical workloads when availability matters
- ignoring labels/selectors and creating overlapping controllers
- exposing everything publicly just because it is easy

---

## How to use this course

Read each section in order.

For every major concept, follow this pattern:

Concept
↓
Simple explanation
↓
How it works internally
↓
Real-world use case
↓
Hands-on practice
↓
Common mistakes
↓
Best practices

This is how you build engineering intuition instead of memorizing terms.

---

# Phase 1 — Fundamentals

## 1. What Kubernetes solves

### Simple explanation

Kubernetes is a container orchestration platform. It schedules containers onto nodes, keeps workloads available, scales them, handles rolling updates, and restarts failed containers.

### How it works internally

The control plane continuously compares the desired state in the cluster API with the actual state of running Pods and workloads. Controller loops reconcile differences and drive the cluster toward the desired state.

### Real-world use case

A Spring Boot API runs in a container. Kubernetes ensures:

- it starts on a healthy node
- it gets restarted if it fails
- it gets traffic through a Service
- multiple replicas are kept running
- rollouts can happen without downtime

### Hands-on practice

Start with a simple cluster and run a sample app:

```bash
kubectl version --client --output=yaml
kubectl get nodes
kubectl get pods -A
```

### Common mistakes

- thinking Kubernetes is a deployment tool only
- treating it like Docker Compose on steroids
- assuming Pods are durable and stable

### Best practices

- learn the control plane + node model first
- use declarative YAML and `kubectl apply`
- prefer workload controllers over manual Pods

---

## 2. Containers vs Kubernetes

### Simple explanation

Containers package an app and its runtime. Kubernetes manages many containers across many machines.

### How it works internally

Containers share the OS kernel of a node. Kubernetes schedules those containers into Pods, which are the smallest deployable unit.

### Real-world use case

You build one container image for your backend. Kubernetes runs multiple copies of that image behind a Service.

### Hands-on practice

Compare:

```bash
docker run -d -p 8080:8080 my-image
```

vs:

```bash
kubectl run demo --image=my-image --port=8080
kubectl get pods
```

### Common mistakes

- assuming a container directly equals a Kubernetes workload
- using Kubernetes without understanding the difference between a container and a Pod

### Best practices

- keep container images small and immutable
- separate build-time concerns from runtime config
- run one concern per container when appropriate

---

## 3. Kubernetes architecture

### Simple explanation

A Kubernetes cluster has a control plane and worker nodes.

### How it works internally

Control plane components include:

- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager
- cloud-controller-manager (when used)

Worker nodes run:

- kubelet
- kube-proxy
- container runtime

### Real-world use case

The API server receives desired state. The scheduler decides placement. The kubelet ensures containers run. The controller manager reconciles desired vs actual.

### Hands-on practice

```bash
kubectl get componentstatuses
kubectl get nodes -o wide
kubectl get pods -A
```

### Common mistakes

- trying to operate Kubernetes without understanding control plane responsibilities
- ignoring that scheduling and health are separate concerns

### Best practices

- understand node capacity, taints, tolerations, and scheduling behavior
- know which layer owns what before debugging a failure

---

## 4. Cluster

### Simple explanation

A cluster is a set of machines that run containerized workloads under Kubernetes control.

### How it works internally

Nodes join the cluster and report capacity. The scheduler places Pods according to resources, taints, affinity, and other policy.

### Real-world use case

Development cluster, staging cluster, production cluster.

### Hands-on practice

```bash
kubectl get nodes
kubectl describe node <node-name>
```

### Common mistakes

- assuming a single node is enough for production
- ignoring resource fragmentation and node-level constraints

### Best practices

- keep cluster topology clear
- understand failure domains and node pools
- track capacity and autoscaling

---

## 5. Control plane

### Simple explanation

The control plane is the brain of the cluster.

### How it works internally

It stores desired state in etcd and acts through controllers and the API server.

### Real-world use case

When you run `kubectl apply -f deployment.yaml`, the API server receives the desired state and controllers reconcile it.

### Hands-on practice

```bash
kubectl get all -A
kubectl get deployment -A
kubectl get endpointslices -A
```

### Common mistakes

- exposing the control plane publicly without protection
- using cluster-admin credentials for routine work

### Best practices

- lock down API access
- limit admin permissions
- separate cluster responsibilities from workload access

---

## 6. Worker nodes

### Simple explanation

Nodes run your Pods.

### How it works internally

The kubelet supervises Pod lifecycle on each node. kube-proxy configures networking and routing for Services.

### Real-world use case

A node fails, Pods are rescheduled, and the cluster self-heals.

### Hands-on practice

```bash
kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[3].status,VERSION:.status.nodeInfo.kubeletVersion
```

### Common mistakes

- overloading nodes with too many workloads
- ignoring node pressure and eviction behavior

### Best practices

- define resource requests and limits
- use multi-node capacity for resilience
- watch node pressure and OOM behavior

---

## 7. Pods

### Simple explanation

A Pod is the smallest deployable unit. One Pod can contain one or more containers sharing network and storage.

### How it works internally

Containers in the same Pod share a network namespace and can talk via `localhost`. Kubernetes treats the Pod as a unit.

### Real-world use case

A backend service deployed as a single container in one Pod, or a sidecar pattern for logs or proxies.

### Hands-on practice

Create a simple Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
spec:
  containers:
    - name: hello
      image: nginx:stable
      ports:
        - containerPort: 80
```

```bash
kubectl apply -f hello-pod.yaml
kubectl get pod hello-pod -o wide
kubectl logs hello-pod
kubectl describe pod hello-pod
```

### Common mistakes

- creating Pods directly in production
- using one Pod to represent a whole app when it should be a Deployment

### Best practices

- most workloads should use Deployments, not direct Pods
- keep one concern per Pod when possible
- set resource requests and limits

---

## 8. Deployments

### Simple explanation

A Deployment manages a set of identical Pods and keeps them aligned with a desired state.

### How it works internally

The Deployment controller creates a ReplicaSet. The ReplicaSet creates Pods. The Deployment rolls out updates by creating a new ReplicaSet and scaling old ones down.

### Real-world use case

Deploy your Spring Boot API with 3 replicas behind a Service.

### Hands-on practice

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: ghcr.io/example/backend:1.0.0
          ports:
            - containerPort: 8080
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 10
```

```bash
kubectl apply -f backend-deployment.yaml
kubectl rollout status deployment/backend
kubectl get rs
kubectl get pods -l app=backend
```

### Common mistakes

- not setting selector labels correctly
- overlapping selectors between controllers
- creating a Deployment without readiness checks

### Best practices

- use Deployments for stateless workloads
- keep pod template labels consistent and meaningful
- use rolling updates and probe-based health

---

## 9. ReplicaSets

### Simple explanation

ReplicaSets ensure a desired number of Pods are running.

### How it works internally

They continuously watch their selector and create or delete Pods to reach the target count.

### Real-world use case

A Deployment creates and owns the ReplicaSet; you usually do not manage ReplicaSets directly.

### Hands-on practice

```bash
kubectl get rs -A
kubectl describe rs <replicaset-name>
```

### Common mistakes

- editing ReplicaSets directly instead of changing the Deployment
- overlapping selectors across multiple controllers

### Best practices

- let Deployments own ReplicaSets automatically
- avoid manual management of child controllers

---

## 10. Services

### Simple explanation

A Service gives stable network identity to a set of Pods.

### How it works internally

A Service selects Pods by labels and creates internal routing rules. The cluster updates endpoints as Pods change.

### Real-world use case

Frontend calls `http://backend.default.svc.cluster.local` even though actual backend Pod IPs change over time.

### Hands-on practice

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - name: http
      port: 8080
      targetPort: 8080
      protocol: TCP
```

```bash
kubectl apply -f backend-service.yaml
kubectl get svc
kubectl get endpoints backend
```

### Common mistakes

- targeting wrong label selector
- using Pod IPs directly instead of a Service
- forgetting that Services are stable names, not fixed Pods

### Best practices

- prefer Services over hardcoded Pod IPs
- use ClusterIP by default
- use Ingress or cloud LB only for external entry points

---

## 11. Namespaces

### Simple explanation

Namespaces divide cluster resources into logical groups.

### How it works internally

Each resource exists in a namespace unless cluster-scoped. It helps isolate workloads and RBAC.

### Real-world use case

`dev`, `staging`, `prod`, `platform-system`.

### Hands-on practice

```bash
kubectl create namespace dev
kubectl get ns
kubectl get pods -n dev
```

### Common mistakes

- putting all workloads in `default`
- mixing production and non-production resources
- unclear ownership boundaries

### Best practices

- separate environments by namespace
- use RBAC per namespace
- keep consistent naming and ownership conventions

---

## 12. Labels and selectors

### Simple explanation

Labels are metadata; selectors choose matching Pods or resources.

### How it works internally

Controllers and Services read labels and select matching resources.

### Real-world use case

All backend Pods have `app: backend` and a Service selector chooses them.

### Hands-on practice

```yaml
metadata:
  labels:
    app: backend
    tier: api
    env: prod
```

```bash
kubectl get pods -l app=backend
kubectl get pods -l 'app=backend,env=prod'
```

### Common mistakes

- inconsistent labels across templates
- duplicated or overlapping selectors
- labels chosen without meaning

### Best practices

- keep label keys consistent and predictable
- use labels for versions, app, environment, tier, managed-by
- avoid labels that rapidly change in production

---

# Core Kubernetes resources

## Resource guide

| Resource              | What it is                    | Why it exists              | Use it when                           | Not for                      | Key fields                    | Best practices                             |
| --------------------- | ----------------------------- | -------------------------- | ------------------------------------- | ---------------------------- | ----------------------------- | ------------------------------------------ |
| Pod                   | smallest deployable unit      | runs container(s)          | single process or tightly coupled set | long-lived manual management | metadata, spec, containers    | rarely manage directly in prod             |
| Deployment            | desired state controller      | scales and updates Pods    | stateless apps                        | stateful workloads           | replicas, selector, template  | use rolling updates with probes            |
| ReplicaSet            | ensures desired replica count | maintains Pod count        | child of Deployment                   | direct admin                 | selector, replicas            | do not manage directly                     |
| Service               | stable network abstraction    | stable endpoint for Pods   | exposing Pods internally              | direct Pod IP usage          | selector, ports, type         | prefer internal ClusterIP default          |
| Namespace             | cluster partition             | isolation and policies     | multi-env or team boundaries          | all in one namespace         | metadata.name                 | keep conventions consistent                |
| ConfigMap             | non-secret config             | externalizes config        | env vars, mounted files               | secret data                  | data                          | keep config separate from image            |
| Secret                | sensitive data                | stores confidential values | passwords, tokens                     | plain text config            | stringData/data               | use KMS, rotation, external secret systems |
| ServiceAccount        | identity for workloads        | workload auth              | pod-to-kube API auth                  | shared admin identity        | automountServiceAccountToken  | least privilege                            |
| Ingress               | HTTP/HTTPS entry point        | external routing rules     | public web traffic                    | arbitrary protocols          | rules, ingressClassName       | use proper ingress controller              |
| PersistentVolume      | cluster storage resource      | physical backing storage   | long-lived data                       | ephemeral workloads          | capacity, access modes        | size and reclaim policies matter           |
| PersistentVolumeClaim | user request for storage      | binds Pod to storage       | stateful apps                         | stateless apps               | storageClassName, accessModes | match workload needs                       |
| Job                   | short-lived batch task        | run pods to completion     | one-off jobs                          | long-running services        | parallelism, completions      | set backoff limits                         |
| CronJob               | scheduled job                 | time-based tasks           | periodic jobs                         | continuous services          | schedule, jobTemplate         | include timezone and retries               |

### Notes

- Use a Deployment for most stateless apps.
- Use a StatefulSet for workloads that require stable identity and ordered behavior.
- Use a Job/CronJob for batch tasks.
- Prefer Ingress or Gateway for external HTTP/HTTPS traffic over raw NodePort or LoadBalancer when possible.

---

# kubectl mastery

Kubectl is the primary command-line tool for interacting with a cluster.

## Essential commands

### Getting resources

```bash
kubectl get pods
kubectl get pods -A
kubectl get deploy
kubectl get svc
kubectl get ns
kubectl get all
kubectl get ingress
kubectl get pvc,pv
```

### Describing resources

```bash
kubectl describe pod backend-abc123
kubectl describe deploy backend
kubectl describe svc backend
kubectl describe ingress frontend
kubectl describe node minikube
```

### Logs

```bash
kubectl logs backend-abc123
kubectl logs -f backend-abc123
kubectl logs deployment/backend
kubectl logs -n prod deployment/backend --tail=200
kubectl logs pod/backend-abc123 -c app
```

### Exec

```bash
kubectl exec -it backend-abc123 -- sh
kubectl exec -it deployment/backend -- /bin/sh
kubectl exec -it backend-abc123 -- printenv
```

### Port forwarding

```bash
kubectl port-forward svc/backend 8080:8080
kubectl port-forward pod/backend-abc123 8080:8080
```

### Applying manifests

```bash
kubectl apply -f backend.yaml
kubectl apply -f ./manifests/
```

### Updating resources

```bash
kubectl set image deployment/backend backend=ghcr.io/example/backend:2.0.0
kubectl edit deployment/backend
kubectl patch deployment/backend -p '{"spec":{"replicas":5}}'
```

### Deleting resources

```bash
kubectl delete pod backend-abc123
kubectl delete -f backend.yaml
kubectl delete ns dev
```

### Rollouts and scaling

```bash
kubectl rollout status deployment/backend
kubectl rollout history deployment/backend
kubectl rollout undo deployment/backend
kubectl scale deployment/backend --replicas=5
kubectl autoscale deployment/backend --min=2 --max=10 --cpu-percent=70
```

### Debugging

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events -A --field-selector involvedObject.name=backend
kubectl get pod -o yaml backend-abc123
kubectl get pod backend-abc123 -o jsonpath='{.status.phase}'
```

### Contexts and namespaces

```bash
kubectl config get-contexts
kubectl config use-context kind-kind
kubectl config set-context --current --namespace=prod
kubectl get ns
kubectl get pods -n prod
```

### Labels and selectors

```bash
kubectl get pods -l app=backend
kubectl label pod backend-abc123 tier=api
kubectl label pod backend-abc123 tier-
kubectl get pod -L app,tier,env
```

### JSONPath

```bash
kubectl get pods -o jsonpath='{.items[*].metadata.name}'
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
```

### Useful command combinations

```bash
kubectl get pods -A --watch
kubectl logs -l app=backend --all-containers=true --tail=100
kubectl get pods -A | grep CrashLoopBackOff
kubectl describe pod $(kubectl get pod -l app=backend -o name | head -n 1)
```

## kubectl cheat sheet

```bash
# cluster basics
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get deploy -A

# inspect a resource
kubectl describe pod <name>
kubectl describe deploy <name>

# logs and shell
kubectl logs <pod>
kubectl logs -f <pod>
kubectl exec -it <pod> -- sh

# networking
kubectl port-forward svc/<svc> 8080:8080
kubectl get endpoints <svc>

# apply and roll out
kubectl apply -f deployment.yaml
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>

# scaling
kubectl scale deploy/<name> --replicas=3

# debug
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get pod <name> -o yaml
kubectl top pod
kubectl top node
```

### kubectl best practices

- prefer explicit resource names
- use `--namespace` or context switching
- use `-o wide` and `-o yaml` when debugging
- avoid overusing `kubectl exec` in production for routine troubleshooting; prefer logs, metrics, and events
- learn resource selectors deeply; they are foundational to most K8s workflows

---

# YAML & manifest best practices

## Kubernetes YAML structure

Most manifests follow:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example
  labels:
    app: demo
spec:
  containers:
    - name: app
      image: nginx:stable
      ports:
        - containerPort: 80
```

Key fields:

- `apiVersion`: API group/version
- `kind`: resource type
- `metadata`: name, namespace, labels, annotations
- `spec`: desired state

### Labels

Use labels consistently:

- `app`
- `component`
- `env`
- `tier`
- `managed-by`

### Selectors

Selectors are how Services and controllers find matching resources. Make them stable and intentional.

### Good manifest design

- keep manifests version-controlled
- prefer declarative config
- avoid duplicate config values across files
- keep environment-specific values separate from base manifests
- avoid injecting secrets into image layers or plain text manifests

### Bad example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: myapp:latest
          env:
            - name: DB_PASSWORD
              value: password123
```

### Improved example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: prod
  labels:
    app: backend
    env: prod
    tier: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
        env: prod
        tier: api
    spec:
      containers:
        - name: backend
          image: ghcr.io/example/backend:1.2.3
          env:
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: backend-secrets
                  key: db-password
```

### Why the improved version is better

- explicit namespace
- stable image tag instead of `latest`
- multiple replicas for availability
- secrets are not hardcoded
- labels are meaningful and consistent
- config is easier to reason about and audit

---

# Networking

## Pod networking

Each Pod gets an IP. Containers in the same Pod share networking. Different Pods cannot communicate via localhost; they use network addresses.

## Services

A Service provides a stable endpoint for Pods. The cluster updates Service endpoints as Pods change.

### Service types

- ClusterIP: internal service IP; default
- NodePort: exposes port on each node, usually not recommended for public internet exposure
- LoadBalancer: cloud or external load balancer integration
- ExternalName: maps DNS name

### Ingress

Ingress is for HTTP/HTTPS routing and host/path rules. It sits in front of Services.

### Ingress controllers

Ingress is just a resource. An Ingress controller implements the actual routing logic. Examples include NGINX Ingress, Traefik, HAProxy, and cloud-integrated controllers.

### DNS and service discovery

Kubernetes DNS resolves service names like:

```bash
backend.default.svc.cluster.local
```

### Network policies

Network policies restrict Pod-to-Pod traffic.

### Practical networking labs

#### Lab 1: Service selection

Create a Deployment with two Pods and a Service selecting only one label set. Observe which Pods receive traffic.

#### Lab 2: wrong selector debug

Create a Service selector that does not match the Pods. Then check:

```bash
kubectl get endpoints
kubectl describe svc backend
kubectl get pods -l app=backend
```

#### Lab 3: NodePort vs Ingress

Deploy a simple app using ClusterIP and then compare NodePort to Ingress flow. Decide which is appropriate for production.

### Best practices

- prefer Services over direct Pod IPs
- avoid unnecessary NodePorts
- use Ingress for HTTP traffic
- use NetworkPolicies where isolation matters
- understand internal vs external traffic boundaries
- expose only what needs to be exposed

---

# Configuration & Secrets

## ConfigMaps

Use ConfigMaps for non-sensitive configuration.

### Example

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
data:
  APP_ENV: prod
  LOG_LEVEL: INFO
```

```yaml
env:
  - name: APP_ENV
    valueFrom:
      configMapKeyRef:
        name: backend-config
        key: APP_ENV
```

## Secrets

Use Secrets for secrets and sensitive runtime values.

### Example

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secrets
type: Opaque
stringData:
  db-password: "supersecret"
```

Note: Kubernetes Secret is not a full secret-management system. It stores data in etcd and should be complemented with robust external secret practices.

## Environment variables vs mounted configuration

- env vars are convenient for small configuration
- mounted config files are better for larger configs and updates

## External secret management concepts

Common patterns:

- External Secrets Operator
- Sealed Secrets
- Vault integration
- cloud-native KMS-backed secret management

### Best practices

- never hard-code secrets into images
- never commit plaintext production secrets to Git
- keep config separate from application images
- prefer secret management tooling over ad hoc manual secret creation
- understand Secret limitations and rotate credentials regularly

### Intentional mistake lab

Create a Deployment with a bad env var example and then fix it.

Exercise:

1. put `DB_PASSWORD` directly in YAML
2. validate with `kubectl get deployment` and `kubectl describe pod`
3. move it to a Secret and fix the app

---

# Resource Management

## Why resource management matters

Without requests and limits, scheduling and performance become unpredictable. This is one of the most common production issues in Kubernetes.

## CPU and memory concepts

- `requests`: scheduler uses these to place Pods
- `limits`: kubelet enforces a maximum
- QoS: Guaranteed, Burstable, BestEffort

### Example

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

### OOM and scheduling issues

#### Exercise 1: container consumes too much memory

Set a memory limit lower than the app needs and observe the Pod restart behavior.

#### Exercise 2: Pod gets OOMKilled

Run a Java app or memory-intensive workload with a too-low limit.

#### Exercise 3: CPU limits throttle performance

Run a workload with a strict CPU limit and observe slower response times.

#### Exercise 4: scheduling problems

Set requests too high for the node capacity and see `Pending` with `FailedScheduling`.

### Best practices

- start with real metrics, not guesses
- requests should reflect sustainable baseline usage
- limits should protect the node from noisy neighbors
- test memory under load before production
- tune application behavior with observability, not blind assumptions

---

# Health checks

## Probes

Kubernetes supports:

- liveness probe
- readiness probe
- startup probe

### Spring Boot example

A Spring Boot app often exposes `/actuator/health`.

#### Example

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 20
  periodSeconds: 10

startupProbe:
  httpGet:
    path: /actuator/health
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

### What each probe does

- readiness: whether traffic should reach the Pod
- liveness: whether the container should be restarted
- startup: gives slow-starting apps time before liveness begins

### Common mistakes

- making liveness too aggressive
- using readiness incorrectly so traffic never reaches the service
- putting a probe on a path that never becomes healthy
- not understanding that a failing liveness probe can restart the container automatically

### Failure/debugging exercises

- broken readiness path
- container never becomes ready
- liveness kills app due to too-short threshold
- startup probe not configured for slow boot

### Best practices

- readiness should be based on application health
- liveness should not be too strict for short startup spikes
- test probe behavior under real load and startup delay
- use `/actuator/health` carefully and keep endpoints deterministic

---

# Scaling & reliability

## Replicas

Pods should be replicated when availability and throughput matter.

### Rolling updates and rollbacks

A Deployment can update Pods gradually without downtime.

```bash
kubectl rollout status deployment/backend
kubectl rollout undo deployment/backend
```

### Deployment strategies

- RollingUpdate (default)
- Recreate (full replacement; can cause downtime)

### Horizontal Pod Autoscaler

```bash
kubectl autoscale deployment backend --cpu-percent=70 --min=2 --max=10
```

### Pod disruptions

Use disruption budgets where availability matters.

### Best practices

- avoid single-replica production workloads when availability matters
- use readiness probes
- configure graceful shutdown
- prefer rolling updates with health checks
- understand bottlenecks before scaling blindly

---

# Security best practices

## RBAC, Roles, RoleBindings, ClusterRoles

These control authorization and least privilege.

### Beginner approach

- cluster-admin everywhere
- one service account used by all workloads
- broad role permissions

### Why this is risky

- any compromised workload has unlimited cluster access
- lateral movement becomes much easier

### Better approach

- create narrowly scoped Roles
- separate workload identities by namespace and function
- scope access to only needed resources

## ServiceAccounts

Use distinct ServiceAccounts per workload or team.

## Security contexts

Run containers with non-root users and least-privilege settings where possible.

```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
```

## NetworkPolicies

Restrict traffic between Pods.

## Container security

- scan images
- use trusted registries
- pin image tags to specific versions
- keep images minimal and patched

### Practical security labs

- deny all ingress except API server traffic
- run a workload as root and fix it
- test service account overreach
- set a NetworkPolicy and verify traffic drops

---

# Kubernetes production best practices

## Workloads

- use Deployments instead of manually managed Pods
- configure a meaningful replica count
- define resource requests and limits
- add readiness/liveness probes
- ensure graceful shutdown and termination handling
- use rolling updates carefully and test them

### Why it matters

It reduces outage risk, improves predictability, and makes upgrades safe.

## Configuration

- use ConfigMaps for non-secret config
- use Secrets for sensitive data
- isolate environment-specific config
- use external secret management in real production

### Why it matters

Good config management prevents accidental drift and makes deployments safer.

## Security

- least privilege RBAC
- non-root containers
- read-only filesystem where appropriate
- NetworkPolicies
- image scanning and provenance

### Why it matters

Security is not just a tool; it is a control over blast radius, privilege, and trust.

## Networking

- prefer Services for internal routing
- use Ingress or Gateway for HTTP/HTTPS external traffic
- manage TLS at the edge
- restrict exposure and avoid unnecessary NodePorts

### Why it matters

Network exposure drives the largest operational risk in app deployments.

## Observability

- logs
- metrics
- events
- alerts
- dashboarding

### Why it matters

A healthy cluster is not just running; it is observable.

## Reliability

- multiple replicas
- availability-aware scheduling
- disruption planning
- autoscaling based on real load drivers
- backup/recovery and failure testing

### Why it matters

Production is the steady-state of recovering from failure, not the absence of failure.

## Maintainability

- naming conventions
- labels and annotations
- namespaces
- GitOps or consistent declarative configuration
- Helm when appropriate

### Why it matters

The cluster should be understandable without tribal knowledge.

---

# Build one real project

We will build a single realistic application progressively.

## Architecture

```text
                    Internet
                       │
                    Ingress
                       │
                ┌──────┴──────┐
                │             │
             Frontend      Backend
             Next.js      Spring Boot
                              │
                    ┌─────────┴─────────┐
                    │                   │
                PostgreSQL            Redis
```

## Progressive build plan

### 1. Cluster

- local cluster with kind or Minikube
- verify nodes and namespaces

### 2. Frontend

- deploy Next.js frontend behind a Service
- expose via Ingress

### 3. Backend

- deploy Spring Boot API
- add resource requests/limits
- add probes

### 4. PostgreSQL

- deploy StatefulSet or a managed database approach
- use PVC
- add secret-backed credentials

### 5. Redis

- deploy a simple Redis Deployment
- expose via a Service

### 6. Services

- internal backend Service
- frontend Service
- Redis Service
- Postgres internal networking

### 7. ConfigMaps

- app config
- log level
- feature toggles

### 8. Secrets

- DB password
- JWT secret
- Redis password if needed

### 9. Persistent storage

- use PVCs for DB
- set storage class and access mode

### 10. Ingress

- route `/` to frontend
- route `/api/*` to backend

### 11. TLS

- use cert-manager or a self-signed local secret for learning

### 12. Health probes

- readiness and liveness for frontend and backend

### 13. Resource limits

- set CPU and memory requests/limits

### 14. Multiple replicas

- scale backend and frontend to 2 or 3 replicas

### 15. Autoscaling

- HPA on backend based on CPU or custom metrics

### 16. RBAC

- separate ServiceAccounts

### 17. NetworkPolicies

- isolate DB from internet-facing pods
- only allow frontend/backend access paths

### 18. Monitoring

- metrics and logs
- Prometheus/Grafana or basic cluster metrics

### 19. Logging

- centralize app logs
- inspect events and crashes

### 20. Helm

- move manifests into chart templates

### 21. CI/CD

- Git push → test → build → push image → deploy

### 22. Production-style deployment

- secure, observable, repeatable, tested rollout

---

# Break things intentionally

This is the fastest way to learn Kubernetes.

## Failure lab framework

For each issue, use this pattern:

Broken Setup
↓
Symptoms
↓
How to Investigate
↓
Useful kubectl Commands
↓
Root Cause
↓
Fix
↓
How to Prevent It

## Common failure labs

### 1. Pod stuck in Pending

Symptoms:

- Pod never gets scheduled

How to investigate:

```bash
kubectl get pod <name>
kubectl describe pod <name>
kubectl get events -A --sort-by=.metadata.creationTimestamp
```

Root cause:

- insufficient resources, taints, selector mismatch, image pull issues, node unschedulable

Fix:

- correct requests, taints/tolerations, node capacity, image name

Prevent:

- resource planning and label/selector hygiene

### 2. CrashLoopBackOff

Symptoms:

- container restarts repeatedly

Commands:

```bash
kubectl get pods
kubectl logs <pod>
kubectl describe pod <pod>
```

Root cause:

- app crashes, bad startup command, config problem, failing health checks

Fix:

- inspect logs and restart logic

Prevent:

- readiness/liveness testing, startup probes, good config

### 3. ImagePullBackOff

Symptoms:

- image cannot be pulled

Commands:

```bash
kubectl describe pod <pod>
kubectl get events -A
```

Root cause:

- bad image tag, private registry access problem, missing auth

Fix:

- correct image path and registry credentials

Prevent:

- automated image validation and CI verification

### 4. OOMKilled

Symptoms:

- restarted container after memory limit exceeded

Commands:

```bash
kubectl get pod <pod> -o yaml
kubectl describe pod <pod>
```

Root cause:

- container memory usage beyond the limit

Fix:

- raise memory limit and reduce footprint

Prevent:

- realistic requests/limits and load testing

### 5. Service cannot reach Pod

Symptoms:

- Service has endpoints but cannot connect

Commands:

```bash
kubectl get svc
kubectl get endpoints
kubectl describe svc <svc>
kubectl logs deployment/<controller>
```

Root cause:

- selector mismatch, port mismatch, readiness failure

Fix:

- align selector labels and port numbers

Prevent:

- test the service path after every deployment

### 6. Wrong selector

Symptoms:

- no endpoints or unexpected endpoints

Fix:

- ensure labels and selectors match exactly

### 7. Incorrect port

Symptoms:

- targetPort mismatch, app listens on different port

Fix:

- match `containerPort` and `targetPort`

### 8. Broken readiness probe

Symptoms:

- Pod never gets ready, traffic not routed

Fix:

- check path, initial delay, and application health endpoint

### 9. Broken liveness probe

Symptoms:

- app is restarted even while healthy

Fix:

- tune probe timing and expose a stable health endpoint

### 10. DNS failure

Symptoms:

- app cannot resolve internal service names

Commands:

```bash
kubectl exec -it <pod> -- nslookup backend
kubectl get svc
kubectl get endpoints
```

Root cause:

- CoreDNS or service configuration issue

### 11. Configuration missing

Symptoms:

- app fails at startup because env var missing or config file absent

Fix:

- ConfigMap or Secret wiring

### 12. Secret missing

Symptoms:

- app fails to authenticate to DB or external systems

Fix:

- create or mount Secret correctly

### 13. PersistentVolume problem

Symptoms:

- Pod pending or volume attachment failure

Commands:

```bash
kubectl get pvc
kubectl get pv
kubectl describe pvc <pvc>
```

Fix:

- correct storage class, access mode, capacity

### 14. Ingress not routing

Symptoms:

- no route or 404/503

Fix:

- check IngressClass, host, path, and controller config

### 15. Deployment rollout failure

Symptoms:

- rollout stalls or hangs

Commands:

```bash
kubectl rollout status deployment/<name>
kubectl describe deployment <name>
```

Fix:

- inspect image issue, readiness failure, or resource constraints

---

# Local Kubernetes environment

## Free and local options

### Docker Desktop Kubernetes

Best for:

- macOS/Windows users
- local dev convenience
- quick evaluation of a single-node cluster

Pros:

- easiest setup
- good for local dev workflows

Cons:

- not as lightweight or portable as some alternatives
- less representative of multi-node clusters

### Minikube

Best for:

- learning Kubernetes on one machine
- local cluster simulation with VM-based setup

Pros:

- classic local learning option
- fairly simple to use

Cons:

- virtual machine overhead
- less ideal for rapid iteration with many clusters

### kind (Kubernetes in Docker)

Best for:

- learning, testing, and local cluster experiments
- repeated cluster creation and teardown

Pros:

- very fast
- easy to create fresh clusters
- strong for CI and local engineering work

Cons:

- cluster startup and management can require extra practice

### Recommendation

For fast learning, use `kind` if you want repeatability and quick rebuilds; use Docker Desktop if you want the easiest developer experience. Both are suitable for this course. Minikube is still useful but not usually the first choice for a modern hands-on learning workflow.

### Avoiding paid cloud infrastructure early

For fundamentals, local clusters are enough. You do not need an EKS/AKS/GKE setup to learn Kubernetes deeply.

### Optional advanced path later

After mastering the basics:

- EKS, AKS, or GKE are excellent for production patterns and networking
- learn cluster security, IAM, ingress controllers, cluster autoscaling, and observability there

---

# Helm

## Why Helm exists

Helm packages Kubernetes manifests into reusable charts.

## Core concepts

- chart: packaged application definition
- templates: Go templates for Kubernetes YAML
- values.yaml: configuration values
- release: an installed chart instance

### Example structure

```text
mychart/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml
    service.yaml
```

### Practical Helm commands

```bash
helm create mychart
helm install myapp ./mychart
helm upgrade myapp ./mychart
helm uninstall myapp
helm list
helm template ./mychart
```

### Environment-specific values

```yaml
# values-prod.yaml
replicaCount: 3
image:
  tag: "1.2.3"
```

```bash
helm install myapp ./mychart -f values-prod.yaml
```

## Hands-on: package the backend as a chart

This small chart packages the Spring Boot backend from the project architecture. It keeps the image, replica count, Service port, and resource sizing configurable while keeping the Kubernetes templates readable.

Create this layout:

```text
backend-chart/
  Chart.yaml
  values.yaml
  values-dev.yaml
  values-prod.yaml
  templates/
    deployment.yaml
    service.yaml
```

### `Chart.yaml`

```yaml
apiVersion: v2
name: backend
description: Spring Boot backend for the Kubernetes learning project
type: application
version: 0.1.0
appVersion: "1.2.3"
```

`version` is the chart's package version. `appVersion` describes the application version; the image tag below remains explicitly configurable.

### `values.yaml`

```yaml
replicaCount: 2

image:
  repository: ghcr.io/example/backend
  tag: "1.2.3"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8080
  targetPort: 8080

resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### `templates/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: { { .Release.Name } }
  labels:
    app.kubernetes.io/name: backend
    app.kubernetes.io/instance: { { .Release.Name } }
spec:
  replicas: { { .Values.replicaCount } }
  selector:
    matchLabels:
      app.kubernetes.io/name: backend
      app.kubernetes.io/instance: { { .Release.Name } }
  template:
    metadata:
      labels:
        app.kubernetes.io/name: backend
        app.kubernetes.io/instance: { { .Release.Name } }
    spec:
      containers:
        - name: backend
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: { { .Values.image.pullPolicy } }
          ports:
            - name: http
              containerPort: { { .Values.service.targetPort } }
              protocol: TCP
          startupProbe:
            httpGet:
              path: /actuator/health
              port: http
            periodSeconds: 10
            failureThreshold: 30
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: http
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: http
            periodSeconds: 20
          resources: { { - toYaml .Values.resources | nindent 12 } }
```

The probe paths assume Spring Boot Actuator's liveness and readiness health groups are enabled. Use paths your application actually exposes; a wrong probe path can prevent rollout or repeatedly restart a healthy process.

### `templates/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: { { .Release.Name } }
  labels:
    app.kubernetes.io/name: backend
    app.kubernetes.io/instance: { { .Release.Name } }
spec:
  type: { { .Values.service.type } }
  selector:
    app.kubernetes.io/name: backend
    app.kubernetes.io/instance: { { .Release.Name } }
  ports:
    - name: http
      port: { { .Values.service.port } }
      targetPort: http
      protocol: TCP
```

The selector labels in the Service must match the Pod-template labels exactly. If they do not, the Service has no endpoints.

### Environment values

Keep shared defaults in `values.yaml`, then override only what differs by environment.

`values-dev.yaml`:

```yaml
replicaCount: 1
image:
  tag: "1.2.3-dev"
```

`values-prod.yaml`:

```yaml
replicaCount: 3
image:
  tag: "1.2.3"
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: "1"
    memory: 1Gi
```

Do not put database passwords, tokens, or private keys in `values.yaml`, override files, or `--set` arguments. Use an external secret manager or a separately managed Kubernetes Secret, and have the application chart reference the existing Secret when you wire in application configuration.

### Render, validate, and deploy

```bash
# Check chart metadata and templates
helm lint ./backend-chart

# Render locally without changing the cluster
helm template backend ./backend-chart -f ./backend-chart/values-dev.yaml

# Preview the API changes before applying
helm upgrade --install backend ./backend-chart \
  --namespace learning --create-namespace \
  --values ./backend-chart/values-dev.yaml \
  --dry-run --debug

# Install or update the release
helm upgrade --install backend ./backend-chart \
  --namespace learning --create-namespace \
  --values ./backend-chart/values-dev.yaml \
  --wait --timeout 3m

# Check the release and Kubernetes resources
helm status backend --namespace learning
kubectl get deployment,service,pods -n learning
kubectl rollout status deployment/backend -n learning
```

For production values, use `-f ./backend-chart/values-prod.yaml` after checking that the cluster has enough capacity and the image is available in its registry.

### Upgrade and rollback

Change the image tag in the environment values file, then run:

```bash
helm upgrade backend ./backend-chart \
  --namespace learning \
  --values ./backend-chart/values-dev.yaml \
  --wait --timeout 3m

helm history backend --namespace learning
helm rollback backend 1 --namespace learning --wait
```

Helm revisions track chart releases. A rollback restores a prior release configuration; it does not undo database migrations or other external side effects, so those need their own recovery plan.

### Troubleshoot a chart release

```bash
helm status backend --namespace learning
helm get values backend --namespace learning
helm get manifest backend --namespace learning
kubectl describe deployment backend -n learning
kubectl get events -n learning --sort-by=.metadata.creationTimestamp
kubectl logs deployment/backend -n learning --tail=100
```

Compare rendered manifests (`helm template` or `helm get manifest`) with the live resource, then use Pod events and logs to identify whether the issue is in the chart, image, configuration, or application startup.

### HPA and chart ownership

When you add a HorizontalPodAutoscaler, make it configurable and do not let the chart continuously reset `spec.replicas` to a fixed value. In practice, omit the Deployment `replicas` field when autoscaling is enabled, and ensure the cluster has the metrics API required by the chosen HPA metrics.

### Best practices

- use Helm only when it adds value
- version charts and values
- keep templates readable and deterministic
- avoid overengineering small charts
- use values for environment config and avoid duplication

### When not to use Helm

- a small app with only a handful of manifests and no packaging need
- a team is not ready for chart maintenance and release discipline
- a platform already provides a better app delivery layer

---

# CI/CD

## Delivery flow

```text
Git Push
   ↓
Build
   ↓
Test
   ↓
Docker Image
   ↓
Image Registry
   ↓
Kubernetes Deployment
   ↓
Health Check
   ↓
Rollout
```

## Practical example

When a PR merges:

1. run tests
2. build container image
3. push image with a version tag
4. deploy to cluster via manifest update or Helm release
5. verify health and rollout status
6. rollback if needed

## Image tagging

- use versioned tags such as `1.2.3`
- use immutable tags for reproducibility
- avoid `latest` for production deployment

## Versioning and rollout safety

- ensure deployment uses pinned image tags
- verify app health before scaling or broad rollout
- keep rollout history accessible

## Secrets in CI/CD

- use GitHub Actions, Azure DevOps, GitLab CI, or another pipeline system
- store secrets in the pipeline secret store, not source-controlled files
- avoid embedding registry and cluster credentials in code

## Best practices

- separate dev/stage/prod pipelines
- protect production deployments with approvals and checks
- use automated rollback on failed health checks
- keep deployment manifests in Git and avoid ad hoc shell-based deploys

---

# Observability

## Practical investigation flow

When the app is slow, investigate systematically:

1. check pod health and restarts
2. inspect logs
3. review events and describe output
4. check resource usage
5. inspect Service endpoints and ingress routing
6. verify database, cache, and external dependencies

## kubectl logs

```bash
kubectl logs deployment/backend --tail=200
kubectl logs -f deployment/backend
kubectl logs --previous <pod>
```

## Events

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe pod <name>
```

## Metrics

Kubernetes metrics and monitoring are critical for understanding resource contention and bottlenecks.

### Recommended patterns

- Prometheus for metrics
- Grafana for dashboards
- alerts for SLO/SLI breaches
- application metrics for latency, errors, saturation

## How to investigate a slow app

- check CPU or memory pressure
- examine Pod QOS and limits
- inspect application logs for bottlenecks
- validate DB latency
- inspect service routing and ingress metrics
- ensure readiness and liveness are not causing churn

---

# Best-practice review checklist

Use this after your project is running.

## Security

- ❌ Everyone uses cluster-admin → ✅ Use least-privilege Roles and ServiceAccounts
- ❌ Secrets are in manifests → ✅ Use Secrets and external secret management
- ❌ Containers run as root → ✅ Use non-root security contexts where possible
- ❌ No NetworkPolicies → ✅ Restrict traffic by namespace and workload

## Networking

- ❌ Pod IPs are hardcoded → ✅ Use Services and Ingress
- ❌ NodePort is used for everything → ✅ Use internal Services and proper external entry points
- ❌ All traffic is public → ✅ Separate internal and external traffic paths

## Resources

- ❌ No requests or limits → ✅ Set realistic requests and limits
- ❌ Single replica everywhere → ✅ Multi-replica production workloads with healthy scaling
- ❌ Ignore node pressure → ✅ Watch resource usage and scheduling constraints

## Reliability

- ❌ Deploy without probes → ✅ Add readiness/liveness/startup probes
- ❌ No rolling update strategy → ✅ Use safe deployment patterns and rollback plans
- ❌ No health validation → ✅ Verify rollout and health before promotion

## Observability

- ❌ Blind deploys → ✅ Check logs, metrics, events, and traces
- ❌ No alerts → ✅ Monitor key business and system signals
- ❌ No investigation process → ✅ Follow a systematic debugging workflow

## Configuration

- ❌ Config baked into images → ✅ Use ConfigMaps and Secrets
- ❌ Different envs share same config → ✅ Keep env-specific config explicit and testable

## Storage

- ❌ No PVC planning → ✅ Match storage class, access mode, and workload needs
- ❌ Stateful workloads treated like stateless ones → ✅ Use right storage and workload type

## Deployment

- ❌ `latest` everywhere → ✅ Versioned, immutable images
- ❌ manual changes in cluster → ✅ Git-managed declarative configuration
- ❌ no rollback plan → ✅ maintain deployment history and rollback path

## CI/CD

- ❌ Deploy directly from local machines → ✅ Automated pipeline with validations
- ❌ secrets in Git → ✅ use CI secret stores and role isolation

## Maintainability

- ❌ labels are random → ✅ standard naming and labels
- ❌ no namespace strategy → ✅ environment and team separation
- ❌ no GitOps or versioned manifests → ✅ declarative, reviewable infrastructure

---

# Final capstone challenge

Do not immediately look at the reference solution below.

## Capstone requirements

Design and deploy a simple production-like Kubernetes application that includes:

- a Frontend (Next.js)
- a Backend (Spring Boot REST API)
- PostgreSQL database
- Redis cache
- ConfigMap for app config
- Secret for DB credentials and app secrets
- Service for backend and frontend
- Ingress routing for frontend and backend paths
- PVC and storage for PostgreSQL
- health checks on frontend and backend
- resource requests and limits
- multiple replicas for the backend
- autoscaling for at least the backend
- RBAC and separate ServiceAccounts
- NetworkPolicy restricting non-essential traffic
- Helm chart packaging
- CI/CD pipeline with image build and deploy
- ability to intentionally break the app and debug it

Your challenge:

1. design the architecture
2. write the manifests or chart
3. deploy the application locally
4. configure networking and storage
5. add config and secrets
6. add health checks, scaling, and security
7. intentionally break one thing and debug it
8. deploy via CI/CD pipeline

## Reference solution (only after you attempt the challenge)

### Architecture

Use:

- `Deployment` for frontend and backend
- `Service` for each app
- `Ingress` for external routing
- `StatefulSet` or a Kubernetes-managed Postgres deployment with PVC
- `Deployment` for Redis
- `ConfigMap` for environment config
- `Secret` for credentials
- `HPA` for backend
- `NetworkPolicy` to restrict traffic

### Example high-level flow

```yaml
# ingress routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
    - host: app.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend
                port:
                  number: 3000
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 8080
```

### Deployment guidance

- run 2–3 replicas of backend behind a Service
- use readiness probe before adding it to traffic
- set `terminationGracePeriodSeconds` for graceful shutdown
- keep labels consistent and explicit
- use container images with versioned tags

### Production-grade checklist

- add `readinessProbe` and `livenessProbe`
- set `requests` and `limits`
- use `Secret` for sensitive values
- use `NetworkPolicy` to restrict DB access
- use `HPA` for backend autoscaling
- ensure logs and events are easy to inspect
- keep manifests in Git and apply via CI/CD pipeline

---

# 30-day learning roadmap

## Day 1

Learn:

- what Kubernetes is and what it solves
- container vs cluster concepts
- architecture overview

Build:

- local cluster with kind or Docker Desktop

Practice:

- `kubectl get nodes`, `kubectl get pods -A`

Challenge:

- explain the difference between a container, Pod, Deployment, and Service

Best Practice:

- use `kubectl` to inspect, not guess

Expected outcome:

- you can explain the cluster model and start a local cluster

## Day 2

Learn:

- Pods, Deployments, ReplicaSets, Services

Build:

- deploy a simple NGINX app

Practice:

- labels, selectors, endpoints

Challenge:

- create a Service that routes to multiple Pods

Best Practice:

- never use Pod IPs in production

Expected outcome:

- you can deploy and route a simple stateless app

## Day 3

Learn:

- Namespaces, labels, selectors, manifests

Build:

- split workloads by namespace

Practice:

- `kubectl get -A`, `kubectl describe`, `kubectl logs`

Challenge:

- create dev and prod namespaces and compare

Best Practice:

- keep environment boundaries clear

Expected outcome:

- you understand namespace and labeling discipline

## Day 4

Learn:

- YAML structure and best practices

Build:

- write a Deployment and Service YAML

Practice:

- `kubectl apply`, `kubectl edit`, `kubectl delete`

Challenge:

- fix a broken manifest and redeploy

Best Practice:

- keep manifests in Git and review them like code

Expected outcome:

- you can author and apply basic manifests

## Day 5

Learn:

- ConfigMaps and Secrets

Build:

- externalize config in a real app

Practice:

- env vars and mounted config files

Challenge:

- accidentally hardcode a secret, then fix it

Best Practice:

- never commit production secrets to Git

Expected outcome:

- you can manage config and secrets cleanly

## Day 6

Learn:

- networking, Services, ClusterIP, NodePort, LoadBalancer, Ingress

Build:

- expose a frontend app through a Service and Ingress

Practice:

- inspect endpoints and routing behavior

Challenge:

- debug a misconfigured selector or port mismatch

Best Practice:

- prefer the smallest correct exposure pattern

Expected outcome:

- you understand K8s networking and service routing

## Day 7

Learn:

- resource requests and limits, QoS

Build:

- set CPU and memory requests on app manifests

Practice:

- observe scheduling and Pod status

Challenge:

- intentionally create an OOMKilled Pod and fix it

Best Practice:

- size requests based on real usage, not guesses

Expected outcome:

- you can reason about resource pressure and scheduling

## Day 8

Learn:

- readiness, liveness, startup probes

Build:

- deploy a Spring Boot app with health-check endpoints

Practice:

- trigger probe failures and observe container restarts

Challenge:

- debug a misconfigured health probe that causes outages

Best Practice:

- probes should reflect real service health

Expected outcome:

- you can configure and troubleshoot health checks

## Day 9

Learn:

- rolling updates, rollbacks, Deployment strategy

Build:

- update a deployment to a new image version

Practice:

- `kubectl rollout status` and `kubectl rollout undo`

Challenge:

- force a failing rollout and roll back safely

Best Practice:

- always test a rollout path before production

Expected outcome:

- you can handle safe downstream updates

## Day 10

Learn:

- scaling and HPA

Build:

- run a backend with 2–3 replicas and autoscale

Practice:

- stress the app and watch scale-up behavior

Challenge:

- explain why scaling a database is different from scaling web pods

Best Practice:

- scale only after understanding the bottleneck

Expected outcome:

- you can scale stateless workloads responsibly

## Day 11

Learn:

- storage, PVCs, PVs, StatefulSet concepts

Build:

- deploy Postgres with persistent storage

Practice:

- inspect PVC and PV behavior

Challenge:

- debug volume attach or access mode issues

Best Practice:

- treat stateful workloads differently from stateless ones

Expected outcome:

- you understand storage lifecycle and persistent state

## Day 12

Learn:

- RBAC, ServiceAccounts, least privilege

Build:

- create separate ServiceAccounts for different workloads

Practice:

- use `kubectl auth can-i`

Challenge:

- grant the wrong role and observe the effect

Best Practice:

- never use cluster-admin for routine app access

Expected outcome:

- you can reason about access boundaries

## Day 13

Learn:

- NetworkPolicies and workload isolation

Build:

- restrict app-to-app access

Practice:

- test allowed vs denied traffic

Challenge:

- debug a network policy that blocks the app

Best Practice:

- isolate internal communication paths when it matters

Expected outcome:

- you can secure pod-to-pod traffic

## Day 14

Learn:

- logging, events, observability, metrics, alerting

Build:

- inspect logs, events, and pod health for a failing app

Practice:

- trace a slow application to a root cause

Challenge:

- explain the difference between logs, metrics, and events

Best Practice:

- use observable facts, not assumptions, for debugging

Expected outcome:

- you can systematically investigate application issues

## Day 15

Learn:

- Helm basics and packaging patterns

Build:

- turn a small app into a Helm chart

Practice:

- install and upgrade a release

Challenge:

- compare Helm values for dev vs prod

Best Practice:

- keep templates readable and values explicit

Expected outcome:

- you can package a Kubernetes app with Helm

## Day 16

Learn:

- CI/CD integration for Kubernetes

Build:

- a simple pipeline that builds an image and deploys it

Practice:

- check the rollout status after deployment

Challenge:

- deploy a tag mismatch and debug it

Best Practice:

- use immutable image tags and approval gates

Expected outcome:

- you can connect code delivery to Kubernetes deployments

## Day 17

Learn:

- security hardening, image scanning, and RBAC review

Build:

- harden the app manifests in a small cluster

Practice:

- review security posture and find issues

Challenge:

- identify critical problems in a sample deployment

Best Practice:

- secure the cluster and workloads at the same time

Expected outcome:

- you can do a basic production security review

## Day 18

Learn:

- advanced networking and ingress patterns

Build:

- public traffic to a Next.js app under an Ingress

Practice:

- route different paths to different services

Challenge:

- debug a missing backend host or incorrect path rule

Best Practice:

- avoid exposing unnecessary workloads externally

Expected outcome:

- you can route HTTP traffic correctly and safely

## Day 19

Learn:

- debugging broken systems using kubectl and cluster signals

Build:

- intentionally break and repair a ClusterIP, readiness, or DNS issue

Practice:

- use events, describe, logs, endpoints, and exec

Challenge:

- troubleshoot a real incident in under 20 minutes

Best Practice:

- be systematic and evidence-driven

Expected outcome:

- you can debug a live Kubernetes incident confidently

## Day 20

Learn:

- production readiness review

Build:

- review your app for security, reliability, and observability gaps

Practice:

- write a checklist for production readiness

Challenge:

- identify the top 5 issues in a sample deployment

Best Practice:

- treat production readiness as a living quality gate

Expected outcome:

- you can judge whether a deployment is close to production

## Day 21

Learn:

- GitOps and declarative deployment patterns

Build:

- version control all resources and review diffs

Practice:

- design a deployment workflow for dev/stage/prod

Challenge:

- explain why declarative state is safer than imperative actions

Best Practice:

- keep deployment state visible in Git

Expected outcome:

- you can reason about GitOps-friendly Kubernetes workflows

## Day 22

Learn:

- autoscaling, load testing, and saturation patterns

Build:

- apply HPA and test under load

Practice:

- see bottlenecks in app, database, or memory usage

Challenge:

- explain why scaling once is not always enough

Best Practice:

- validate before and after scaling with evidence

Expected outcome:

- you can scale based on real system behavior

## Day 23

Learn:

- reliability, graceful shutdown, and disruption planning

Build:

- simulate pod deletion and verify app resilience

Practice:

- watch startup and shutdown sequence

Challenge:

- explain why graceful shutdown matters

Best Practice:

- design for disruption, not just uptime

Expected outcome:

- you can reason about deploy-time and runtime disruption

## Day 24

Learn:

- database and cache integration on Kubernetes

Build:

- connect backend to PostgreSQL and Redis

Practice:

- check app startup, health, and connectivity

Challenge:

- debug failed DB or cache connection logic

Best Practice:

- keep stateful dependencies explicit and observable

Expected outcome:

- you can integrate data services on Kubernetes

## Day 25

Learn:

- TLS, ingress, and system boundary design

Build:

- add TLS termination and secure routing

Practice:

- verify host rules and certificate wiring

Challenge:

- explain internal vs external traffic exposure

Best Practice:

- expose only the interfaces your app truly needs

Expected outcome:

- you can design a secure external edge pattern

## Day 26

Learn:

- production-grade architecture review

Build:

- review your app with a production checklist

Practice:

- identify missing security, network, or stability controls

Challenge:

- decide which protections are must-haves vs nice-to-haves

Best Practice:

- prioritize risk reduction over complexity

Expected outcome:

- you can make sensible production trade-offs

## Day 27

Learn:

- full-stack app deployment on Kubernetes

Build:

- deploy the full frontend + backend + data stack together

Practice:

- ensure routes, health, and dependencies all work

Challenge:

- debug a cross-service failure in a realistic stack

Best Practice:

- build services with clean boundaries and explicit dependencies

Expected outcome:

- you can deploy a realistic multi-service app

## Day 28

Learn:

- production operations, incident response, and rollback strategy

Build:

- prepare a rollback procedure for a release candidate

Practice:

- test rollback and outage recovery workflow

Challenge:

- decide when to rollback vs fix in place

Best Practice:

- always have a safe rollback path

Expected outcome:

- you can operate Kubernetes under pressure

## Day 29

Learn:

- capstone challenge service design and release packaging

Build:

- architecture and manifests for your final app

Practice:

- review config, security, and operations

Challenge:

- build a complete production-style Kubernetes deployment plan

Best Practice:

- design for clarity, resilience, and maintainability

Expected outcome:

- you can assemble a deployable Kubernetes system from requirements

## Day 30

Learn:

- final production polish and practical review

Build:

- finalize the full project and compare with the reference design

Practice:

- run a full production-readiness review

Challenge:

- identify what remains to improve in your deployment

Best Practice:

- keep learning through real incidents and real workloads

Expected outcome:

- you have usable Kubernetes engineering judgment for real work

---

# Final mindset

Kubernetes is not about memorizing concepts. It is about understanding how systems converge toward desired state, how workloads are scheduled, how network identity works, how failures surface, and how teams create resilient operations.

The goal is not to know every API object by heart. The goal is to be able to:

- understand Kubernetes architecture
- deploy real applications
- write Kubernetes manifests
- debug broken workloads
- manage configuration and secrets
- scale applications
- secure workloads
- use Helm
- build Kubernetes CI/CD
- understand production architecture
- recognize bad Kubernetes practices
- make strong production decisions

This is the difference between knowing Kubernetes as a concept and being able to ship and operate workloads on it.

---

## Recommended next steps

1. Start local: create a kind or Docker Desktop cluster.
2. Deploy a tiny app: NGINX or a Spring Boot REST API.
3. Add Service + Ingress.
4. Add ConfigMap + Secret + probes.
5. Add resources + autoscaling.
6. Build a real multi-service app using the project architecture above.
7. Break and debug intentionally.
8. Package with Helm.
9. Add CI/CD.
10. Review production readiness.

If you do just one thing every day, do the following:

- inspect a resource
- apply a manifest
- debug a failure
- fix it and understand why

That is how you become effective with Kubernetes.

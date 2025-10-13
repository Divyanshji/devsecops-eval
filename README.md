# DevSecOps Candidate Evaluation — Demo

## What is included
- Node.js Express API + MongoDB (demo)
- Multi-stage Dockerfile (non-root)
- GitHub Actions pipeline with Semgrep + Trivy + tfsec/checkov
- Terraform skeleton for EKS provisioning (fill AWS details)
- Kubernetes manifests with PodSecurity, NetworkPolicy, OPA/Gatekeeper templates
- Datadog agent manifest + example monitor
- Falco daemonset example (runtime security)

## Quick local setup (minikube / kind)
1. Build and load image:
   docker build -t devsecops-eval-api:local ./app
   kind load docker-image devsecops-eval-api:local

2. Apply manifests:
   kubectl apply -f infra/k8s/namespaces.yaml
   kubectl apply -f infra/k8s/mongo-deployment.yaml
   kubectl apply -f infra/k8s/api-deployment.yaml
   kubectl apply -f infra/k8s/api-service.yaml
   kubectl apply -f infra/k8s/networkpolicy.yaml
   kubectl apply -f infra/k8s/ingress-nginx.yaml

3. Validate:
   kubectl get pods -n app
   kubectl logs deploy/node-api -n app

DevSecOps Evaluation Report
---------------------------
Candidate: <Your Name>
Date: <date>

Summary of work
- Deployed a Node.js + Mongo sample app with secure build, CI/CD, IaC, EKS manifests, and monitoring.
- Implemented Docker hardening (multi-stage, non-root).
- CI pipeline with static analysis (SonarCloud), image scanning (Trivy), IaC scans (tfsec/checkov), and gated image pushes.
- Secrets: AWS Secrets Manager + External Secrets (IRSA).
- Kubernetes hardening: non-root, resource limits, NetworkPolicies, admission checks recommended (PSA / Gatekeeper).
- Observability: Datadog agent manifest + sample alert provided.
- Compliance: audit logging guidance + SOC2/GDPR/HIPAA awareness.

Security risks identified & mitigations
- Vulnerable base image packages -> mitigated by scanning with Trivy; update base images and pin versions.
- Secrets leakage -> moved secrets to AWS Secrets Manager + External Secrets; removed secrets from repo.
- Over-permissive IAM -> created dedicated limited IAM policies for secrets retrieval and ECR push.
- Lateral movement in cluster -> NetworkPolicies added.
- Unauthorized image push -> pipeline gated by Trivy; only approved images pushed to ECR.

Production hardening suggestions
- Use Distroless images when possible.
- Enforce Pod Security Admission with `enforce: restricted` in production namespaces.
- Use managed database (MongoDB Atlas or Amazon DocumentDB) rather than in-cluster Mongo.
- Enable EKS control plane logging + cluster audit to S3 with lifecycle policies.
- Enforce periodic vulnerability scanning and automatic image rebuilds for base image CVEs.
- Use OPA/Gatekeeper to codify policies.
- Use secrets rotation and short-lived credentials (OIDC).
- Use image signing (cosign) and admission controller to allow only signed images.

Validation evidence (add screenshots):
- pods running
- successful CI run with Trivy passing
- Datadog dashboard showing metrics


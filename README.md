# DevSecOps Evaluation - Quickstart

## Assumptions
- AWS account and IAM permissions to create EKS / ECR / SecretsManager.
- `kubectl` and `aws` CLI installed and authenticated.
- `terraform` installed (v1.2+).
- GitHub repo with secrets configured: AWS_REGION, IMAGE_NAME, SONAR_TOKEN, EKS_CLUSTER_NAME
- Datadog API key (if using Datadog)

## Steps (high level)
1. Create Secrets in AWS Secrets Manager (e.g., key `dev/mongo` with JSON containing MONGO_URL).
2. Provision EKS with terraform:
   - `cd terraform`
   - `terraform init`
   - `terraform plan -var 'vpc_id=...' -var 'subnets=[...]'`
   - `terraform apply -var 'vpc_id=...' -var 'subnets=[...]'`
3. Configure GitHub secrets (IMAGE_NAME, AWS_REGION, SONAR_TOKEN, EKS_CLUSTER_NAME).
4. Setup External Secrets Controller in cluster and create ExternalSecret CR to sync AWS secrets.
5. Deploy k8s manifests:
   - `kubectl apply -f k8s/`
6. Validate pods:
   - `kubectl get pods -n dev`
7. View Datadog metrics (if enabled).
8. Push commits to `main` to trigger CI.

## Local image test
cd app
docker build -t devsecops-eval:local .
docker run --rm -p 3000:3000 -e MONGO_URL='mongodb://localhost:27017' devsecops-eval:local

call http://localhost:3000/health


## How to convert REPORT.md to PDF
- Use `pandoc`:
  `pandoc REPORT.md -o REPORT.pdf`
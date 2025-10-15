# Create IAM role for external-secrets service account
resource "aws_iam_role" "external_secrets_role" {
  name = "external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume.json
}

data "aws_iam_policy_document" "external_secrets_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:external-secrets:external-secrets-sa"]
      variable = "${replace(aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
    }
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  name = "external-secrets-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],
        Effect = "Allow",
        Resource = ["arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:dev/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}

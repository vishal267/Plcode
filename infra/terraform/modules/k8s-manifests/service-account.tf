data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = var.serviceaccount_namespace_match_operator
      variable = "${replace(var.openid_connect_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.serviceaccount_namespace}:${var.serviceaccount_name}"]
    }

    principals {
      identifiers = ["${var.openid_connect_provider_arn}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.iam_role_tags
}

resource "aws_iam_role_policy" "role_policy" {
  name = var.role_policy_name
  role = aws_iam_role.iam_role.id
  policy = file("ebs-csi-policy.json") 

}

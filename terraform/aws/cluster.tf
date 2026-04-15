resource "aws_eks_cluster" "eks_ue_vervea_cluster" {
  name = "eks-ue-vervea-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.role_eks_vervea.arn
  version  = "1.35"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_ue_vervea_a.id,
      aws_subnet.subnet_ue_vervea_b.id,
      aws_subnet.subnet_ue_vervea_c.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.attachment_eks_vervea_role
  ]
}
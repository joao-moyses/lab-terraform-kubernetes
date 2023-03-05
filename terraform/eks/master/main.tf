resource "aws_eks_cluster" "eks_cluster" {

  name     = var.name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {

    security_group_ids = [
      aws_security_group.cluster_master_sg.id
    ]

    subnet_ids = [
      var.subnet_id_1a,
      var.subnet_id_1b
    ]

  }

  tags = {
    "kubernetes.io/cluster/${var.name}" = "shared"
  }

}
resource "aws_eks_node_group" "cluster" {

  cluster_name    = var.eks_cluster
  version         = var.k8s_version
  node_group_name = "${var.name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodes_roles.arn

  subnet_ids = [
    var.subnet_id_1a,
    var.subnet_id_1b
  ]

  instance_types = var.nodes_instances_sizes

  scaling_config {
    desired_size = lookup(var.auto_scale_options, "desired")
    max_size     = lookup(var.auto_scale_options, "max")
    min_size     = lookup(var.auto_scale_options, "min")
  }

  tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"

  }

}
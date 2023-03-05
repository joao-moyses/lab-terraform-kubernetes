output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster.name
}

output "security_group" {
  value = aws_security_group.cluster_master_sg
}
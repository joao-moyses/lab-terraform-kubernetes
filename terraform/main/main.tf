module "vpc" {
  name         = var.name 
  source = "/home/jalves1/Documents/minhas-coisas/modules1/modules/vpc"
}

module "route" {
  source           = "/home/jalves1/Documents/minhas-coisas/modules1/modules/route"
  vpc_id           = (module.vpc.vpc_id)
  name         = var.name 
  gateway_id       = (module.vpc.internet_gateway)
  subnet_id_pub1a  = (module.vpc.subnet_public_1a)
  subnet_id_pub1b  = (module.vpc.subnet_public_1b)
  subnet_id_1a     = (module.vpc.subnet_private_1a)
  subnet_id_1b     = (module.vpc.subnet_private_1b)
  subnet_id_rds_1a = (module.vpc.subnet_rds_1a)
  subnet_id_rds_1b = (module.vpc.subnet_rds_1b)
}


module "ecr" {
  source = "/home/jalves1/Documents/minhas-coisas/modules1/modules/ecr"
  name         = var.name 
}

module "master" {
  source       = "/home/jalves1/Documents/minhas-coisas/modules1/modules/eks/master"
  k8s_version  = "1.24"
  name         = var.name 
  subnet_id_1a = (module.vpc.subnet_private_1a)
  subnet_id_1b = (module.vpc.subnet_private_1b)
  vpc_id       = (module.vpc.vpc_id)
}


module "nodes" {
  source       = "/home/jalves1/Documents/minhas-coisas/modules1/modules/eks/nodes"
  k8s_version  = "1.24"
  name         = var.name 
  subnet_id_1a = (module.vpc.subnet_private_1a)
  subnet_id_1b = (module.vpc.subnet_private_1b)
  vpc_id       = (module.vpc.vpc_id)
  eks_cluster  = (module.master.eks_cluster)
}





/*module "rds" {
  source           = "/home/jalves1/Documents/minhas-coisas/modules1/modules/rds"
  vpc_id           = (module.vpc.vpc_id)
  subnet_id_rds_1a = (module.vpc.subnet_rds_1a)
  subnet_id_rds_1b = (module.vpc.subnet_rds_1b)
}


/*module "ranxher" {
  source           = "/home/jalves1/Documents/minhas-coisas/modules1/modules/rancher"
  vpc_id           = (module.vpc.vpc_id)
  subnet_id_pub1a  = (module.vpc.subnet_public_1a)
}*/
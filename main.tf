provider "aws" {
  region     = var.region
}

terraform {
 backend "s3" {
 bucket = var.bucket
 dynamodb_table = var.dynamodb_table
 region = var.region
 key = var.dynamodb_key
 }
}

module "eks-cluster" {
    source = "./eks-resources/"
    cidr_block = var.cidr_block
    cluster_name = var.cluster_name
    sg_cluster_name = var.sg_cluster_name
    sg_worker_name = var.sg_worker_name
    subnet1_cidr = var.subnet1_cidr
    subnet2_cidr = var.subnet2_cidr
    subnet3_cidr = var.subnet3_cidr
    az1 = var.az1
    az2 = var.az2
    az3 = var.az3
    subnet_name1 = var.subnet_name1
    subnet_name2 = var.subnet_name2
    subnet_name3 = var.subnet_name3
    rt_name = var.rt_name
    cluster_role_name = var.cluster_role_name
    worker_role_name = var.worker_role_name
    launch_template_name = var.launch_template_name
    instance_type = var.instance_type
    base_on_demand = var.base_on_demand
    percentage_on_demand = var.percentage_on_demand
    key_name = var.key_name
    worker_desired_capacity = var.worker_desired_capacity
    worker_min_size = var.worker_min_size
    worker_max_size = var.worker_max_size
    instance_type_asg1 = var.instance_type_asg1
    instance_type_asg2 = var.instance_type_asg2
    instance_type_asg3 = var.instance_type_asg3
    volume_size = var.volume_size
}


output "config-map-aws-auth" {
  value = module.eks-cluster.config-map-aws-auth
}

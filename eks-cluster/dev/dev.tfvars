region = "us-east-1"
bucket = "remote-tfstate-eks"
dynamodb_table = "eks-state-lock"
dynamodb_key = "eks/"
cidr_block = "10.11.0.0/16"
cluster_name = "exchange-dev"
sg_cluster_name = "eks-cluster-group"
sg_worker_name = "eks-node-wrkgrp"
subnet1_cidr = "10.11.1.0/24"
subnet2_cidr = "10.11.2.0/24"
subnet3_cidr = "10.11.3.0/24"
az1 = "us-east-1a"
az2 = "us-east-1b"
az3 = "us-east-1c"
subnet_name1 = "eks-public-1"
subnet_name2 = "eks-public-2"
subnet_name3 = "eks-public-3"
rt_name = "eks-public-rt"
cluster_role_name = "eks-cluster-role"
worker_role_name = "eks-node-role"
launch_template_name = "eks-launch_template"
instance_type = "t2.medium"
base_on_demand = 0
percentage_on_demand = 0
key_name = "eks-key" 
worker_desired_capacity = 3
worker_min_size = 3
worker_max_size = 6
instance_type_asg1 = "t3.medium"
instance_type_asg2 = "t3a.medium"
instance_type_asg3 = "t2.medium"
volume_size = 10

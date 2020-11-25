
######################## MASTER NODE

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-cluster-role.arn
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]

  vpc_config {
    subnet_ids = [aws_subnet.eks-public-1.id, aws_subnet.eks-public-2.id, aws_subnet.eks-public-3.id]
    security_group_ids = [aws_security_group.eks-cluster-group.id]
  }
}

######################## WORKER NODES

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks-cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] #AWS
}

locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority[0].data}' '${var.cluster_name}'
USERDATA

}

resource "aws_launch_template" "eks-launch_template" {
  iam_instance_profile {
     name = aws_iam_instance_profile.instance_profile.name
   }
  image_id = data.aws_ami.eks-worker.id
  instance_type = var.instance_type
  name = var.launch_template_name
  vpc_security_group_ids = [aws_security_group.eks-node-wrkgrp.id]
  user_data = base64encode(local.node-userdata)
  key_name = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
    }
  }
  
}

resource "aws_autoscaling_group" "eks-asg" {
  desired_capacity = var.worker_desired_capacity
  min_size = var.worker_min_size
  max_size = var.worker_max_size
  name = var.cluster_name
  vpc_zone_identifier = [aws_subnet.eks-public-1.id, aws_subnet.eks-public-2.id, aws_subnet.eks-public-3.id]


  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = var.base_on_demand
      on_demand_percentage_above_base_capacity = var.percentage_on_demand
    }
    
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks-launch_template.id
      }
      override {
        instance_type = var.instance_type_asg1
      }
      override {
        instance_type = var.instance_type_asg2
      }
      override {
        instance_type = var.instance_type_asg3
      }

    }
  }

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/cluster-autoscaler/enabled"
    value = "true"
    propagate_at_launch = true
  }
}


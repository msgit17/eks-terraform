resource "aws_security_group" "eks-cluster-group" {
  name        = var.sg_cluster_name
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = var.sg_cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "eks-cluster-ingress-node" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-cluster-group.id
  source_security_group_id = aws_security_group.eks-node-wrkgrp.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group" "eks-node-wrkgrp" {
  name        = var.sg_worker_name
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = var.sg_worker_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "eks-node-wrkgrp-ingress" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-node-wrkgrp.id
  source_security_group_id = aws_security_group.eks-node-wrkgrp.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-node-wrkgrp.id
  source_security_group_id = aws_security_group.eks-cluster-group.id
  to_port                  = 0
  type                     = "ingress"
}
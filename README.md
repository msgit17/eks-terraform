# Create EKS cluster with Terraform

This repository contains necessary files to create EKS cluster with Terraform. By running below commands terraform creates all the required infrastructure to spin up EKS cluster (VPC, IAM roles, Autoscaling Group, Launch Template, etc.) Before executing the below scripts the user must be authenticated in account in which he wants EKS Cluster to be created.

 ### Prerequisite: 
  -   configured AWS CLI
  -   AWS IAM Authenticator
  -   `kubectl`

### Provisioning:
```
terraform init   //to initialize terraform 
terraform plan -var-file=PATH_TO_TFVARS.FILE  //to review the tf scripts and to make the plan by terraform
terraform apply -var-file=PATH_TO_TFVARS.FILE //final command to execute the provision of infrastructure

```

Once the cluster is up and running, we need to run the following commands to get configurations of EKS and to connect with AWS cloud

Run these commands to create yaml file for the aws-auth config map and deploy it
```
terraform output config-map-aws-auth > config-map-aws-auth.yaml  
kubectl apply -f config-map-aws-auth.yaml  
```

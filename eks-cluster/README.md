# Create EKS cluster with Terraform

"Eks-cluster" folder contains necessary files to create EKS cluster with Terraform. By running below commands terraform creates all the required infrastructure to spin up EKS cluster (VPC, IAM roles, Autoscaling Group, Launch Template, etc.) Before executing the below scripts the user must be authenticated in account in which he wants EKS Cluster to be created.

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

## Issues:

### Joining Workers to the cluster: 
**Problem**: 
Worker nodes could not join to the EKS cluster. Checked Security Groups if Cluster SG and Worker SG allow connection to each other. Checked IAM roles if they have necessary permission. Checked "bootstrap.sh" script by ssh to the worker node and checking the logs, manually run the script. All of the previous examinations were passed. Finally, the issue was that worker nodes must have been created with Public IPV4 if they are deployed in Public Subnet or NAT Gateway if they were created in Private Subnet.

**Solution**:
Changed Terraform code to include Auto-Assignment of public IPV4 upon creation.
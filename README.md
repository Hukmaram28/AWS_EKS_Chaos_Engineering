# AWS_EKS_Chaos_Engineering

Used tools: EKS, Helm, Vault, ECR, GitHub, CodeBuild, CodePipeline, docker, 

## CICD Pipeline setup

1. Setup Vault HA cluster and enable auto unseal for kuberentes cluster to access secrets without manually unsealling it. I have setup HA vault cluster separately, the instructions can be found `here`(url).

2. Make sure to store your DB credentials in the vault server. We will store db_name, db_username, db_password and db_root_password.

3. Bring up EKS cluster and create a namespace called dev to deploy the microservices. IaC for the cluster can be found in `IaC/terraform` folder. This willl do following:

   - Using main.tf we are creating an EKS cluster with 2 t2.micro nodes.
   - Using kubernetes.tf we are connecting to the EKS cluster and creating a namespace called dev.
   - Using helm.tf, we are deploying our mysql database helm charts.

4. Mysql db server is deployed as part of infrastructure as this is a one time time activity, This can be done manually too. A new database will be created, The db credentials can be provided in the variables.tf file before applying the Iac Scripts.

5. To make the web and api microservice deployments automated, we will make changes to the buildspec.yaml file to Install helm, template out the helm values.yaml file and package helm charts and push to ECR then deploy them to the EKS cluster. In case of deployment failure we will rollback the deployment to the previous helm release using helm rollback command.

6. 

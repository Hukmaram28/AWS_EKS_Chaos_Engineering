# Infrastructure using CloudFormation YAML templates!

**Note: Infrastructure written using cloudformation templates.**

# EKS Cluster creation using cloudformation

The `vpc.yml` templates creates a VPC with 2 public and 2 private subnets in two different AZs in aws.
The `cluster.yaml` template creates a EKS cluster with a NodeGroup of 2 t2 small ec2 instances and a fargate profile with farget pod execution role.

```
aws cloudformation deploy \
    --s3-bucket <bucket_name> \
    --template-file vpc.yml \
    --stack-name vpc \
    --no-fail-on-empty-changeset
```

```
aws cloudformation deploy \
        --s3-bucket <bucket_name> \
        --template-file cluster.yaml \
        --stack-name pub-eks-cluster \
        --capabilities CAPABILITY_NAMED_IAM \
        --no-fail-on-empty-changeset \
        --tags \
            Name='Kubernetes Cluster'
```


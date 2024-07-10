
# EKS Cluster creation using cloudformation

The `vpc.yml` templates creates a VPC with 2 public subnets to two different AZs
The `cluster.yaml` template creates a EKS cluster with a NodeGroup of 2 t2 small ec2 instances and a fargate profile with farget pod execution roles.

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


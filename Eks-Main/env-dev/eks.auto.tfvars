eks = {
  main = {
    eks_version = "1.29"
    node_groups = {
      node_group1 = {
        subnets        = ["subnet-0e68e31d30781107f","subnet-0524d7573982a1ed0"]
        desired_size   = 2
        max_size       = 2
        min_size       = 1
        instance_types = ["t3.small"]
      }
    }

    node_polices   = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
    ]
    
    addons = {
      aws-ebs-csi-driver = {
        addon_version = "v1.40.0-eksbuild.1"
      }
      eks-pod-identity-agent = {
        addon_version = "v1.3.2-eksbuild.2"
      }
    }
    aws_eks_pod_identity_associations ={
      s3 = {
        namespace       = "test-ns"
        service_account = "test-sa"
        policy_name     = "s3_readonly_policy"
        policy          =<<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOT
      }
    }


  }
}
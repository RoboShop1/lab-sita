aws_eks_pod_identity_associations = {
  s3 = {
    namespace  = "test-ns"
    service_account = "test-sa"
    policy_name = "s3_readonly_policy"
    policy     =<<EOT
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
set -e
case $1 in
  "dev")
      	rm -rf *auto.tfvars credentials
      	AWS_ROLE_ARN=$(cat .aws/accounts.json | jq -r ".dev.arn" )
      	aws sts assume-role --role-arn $AWS_ROLE_ARN --role-session-name dev | tee credentials
      	echo "Assumed role: $AWS_ROLE_ARN "
      	export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' < credentials)
      	export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' < credentials)
      	export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' < credentials)
      	cp env-dev/*.auto.tfvars .
      	terraform init -backend-config=env-dev/state.tfvars
      	export TF_VAR_env=dev
      	export TF_VAR_region=ap-south-1
      	terraform plan
      	terraform apply
      	rm -f .terraform/terraform.tfstate
    ;;
  "prod")
        	rm -rf *auto.tfvars credentials
        	AWS_ROLE_ARN=$(cat .aws/accounts.json | jq -r ".prod.arn" )
        	aws sts assume-role --role-arn $AWS_ROLE_ARN --role-session-name prod | tee credentials
        	echo "Assumed role: $AWS_ROLE_ARN "
        	export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' < credentials)
        	export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' < credentials)
        	export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' < credentials)
        	cp env-dev/*.auto.tfvars .
        	terraform init -backend-config=env-dev/state.tfvars
        	export TF_VAR_env=prod
        	export TF_VAR_region=us-east-1
        	terraform plan
        	terraform apply
        	rm -f .terraform/terraform.tfstate
    ;;
  *)
    echo "Invalid option"
    ;;
esac
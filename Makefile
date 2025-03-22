dev:
	rm -rf *auto.tfvars
	rm -rf  credentials
	unset AWS_DEFAULT_PROFILE
	AWS_ROLE_ARN=$$(cat .aws/accounts.json | jq -r ".dev.arn"); \
	aws sts assume-role --role-arn $$AWS_ROLE_ARN --role-session-name dev > credentials; \
	echo "Assumed role: $$AWS_ROLE_ARN"; \
	AWS_ACCESS_KEY_ID=$$(jq -r '.Credentials.AccessKeyId' < credentials); \
	AWS_SECRET_ACCESS_KEY=$$(jq -r '.Credentials.SecretAccessKey' < credentials); \
    AWS_SESSION_TOKEN=$$(jq -r '.Credentials.SessionToken' < credentials); \
	cp env-dev/*.auto.tfvars . ; \
	terraform init -backend-config=env-dev/state.tfvars ; \
	terraform plan TF_VAR_region=ap-south-1 TF_VAR_env=dev ; \
	terraform apply TF_VAR_region=ap-south-1 TF_VAR_env=dev


dev1:
	rm -rf *auto.tfvars credentials
	AWS_ROLE_ARN=$$(cat .aws/accounts.json | jq -r ".dev.arn"); \
	aws sts assume-role --role-arn $$AWS_ROLE_ARN --role-session-name dev > credentials; \
	echo "Assumed role: $$AWS_ROLE_ARN"; \
	AWS_ACCESS_KEY_ID=$$(jq -r '.Credentials.AccessKeyId' < credentials); \
	AWS_SECRET_ACCESS_KEY=$$(jq -r '.Credentials.SecretAccessKey' < credentials); \
	AWS_SESSION_TOKEN=$$(jq -r '.Credentials.SessionToken' < credentials); \
	cp env-dev/*.auto.tfvars .; \
	terraform init -backend-config=env-dev/state.tfvars; \
	TF_VAR_region=ap-south-1 TF_VAR_env=dev terraform apply -auto-approve; \
	TF_VAR_region=ap-south-1 TF_VAR_env=dev terraform plan

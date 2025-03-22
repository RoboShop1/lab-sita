dev:
	rm -rf *.tfvars
	rm -rf credentials
	AWS_ROLE_ARN=$(cat .aws/accounts.json| jq ".${AWS_ACCOUNT_NAME}.arn" |sed -e 's/"//g')
	aws sts assume-role --role-arn ${AWS_ROLE_ARN} --role-session-name ${AWS_ACCOUNT_NAME} > credentials
	export AWS_ACCESS_KEY_ID=$(cat credentials | jq '.Credentials.AccessKeyId' |sed -e 's/"//g')
    export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq '.Credentials.SecretAccessKey' |sed -e 's/"//g')
	export AWS_SESSION_TOKEN=$(cat credentials | jq '.Credentials.SessionToken' | sed -e 's/"//g')
	cp env-dev/*.auto.tfvars .
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -e TF_VAR_region=ap-souht-1 -e TF_VAR_env=dev
	terraform plan

prod:
	rm -rf *.tfvars
	cp env-prod/*.tfvars .
	terraform init
	terraform apply -auto-approve
	rm -rf *.tfvars

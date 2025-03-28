

case "$1" in
    "dev")
        rm -rf *.auto.tfvars
        git pull
        cp env-dev/*.auto.tfvars .
        terraform init -backend-config=env-dev/state.tfvars
        export TF_VAR_env=dev
        if [[ "$2" == "plan" ]]; then
          terraform plan
          rm -rf *.auto.tfvars
          exit 1
          fi
        if [[ "$2" == "apply" ]] ; then
          terraform apply -auto-approve
          rm -rf *.auto.tfvars
          exit 1
          fi
        if [[ "$2" == "apply" ]] ; then
          terraform destroy
          rm -rf *.auto.tfvars
          exit 1
          fi
       ;;
   *)
     echo   "Invalid Option" ;;






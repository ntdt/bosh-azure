#!/bin/bash
set -e

echo "=============================================================================================="
echo "Executing Terraform ...."
echo "=============================================================================================="

# Install Terraform cli until we can update the Docker image
wget $(wget -q -O- https://www.terraform.io/downloads.html | grep linux_amd64 | awk -F '"' '{print$2}') -O /tmp/terraform.zip
if [ -d /opt/terraform ]; then
  rm -rf /opt/terraform
fi

unzip /tmp/terraform.zip
sudo cp terraform /usr/local/bin
export PATH=/opt/terraform/terraform:$PATH

function fn_terraform {

terraform ${1} \
  -var "subscription_id=${azure_subscription_id}" \
  -var "client_id=${azure_service_principal_id}" \
  -var "client_secret=${azure_service_principal_password}" \
  -var "tenant_id=${azure_tenant_id}" \
  -var "location=${azure_region}" \
  -var "env_name=${azure_terraform_prefix}" \
  -var "azure_terraform_vnet_cidr=${azure_terraform_vnet_cidr}" \
  -var "azure_terraform_subnet_bosh_cidr=${azure_terraform_subnet_bosh_cidr}" \
  -var "jumpbox_private_ip=${jumpbox_private_ip}" \
  -var "jumpbox_hostname=${jumpbox_hostname}" \
  -var "vm_admin_username=${azure_vm_admin}" \
  -var "vm_admin_password=${azure_vm_password}" \
  bosh-azure/terraform/${azure_bosh_terraform_template}

}

fn_terraform "plan"
fn_terraform "apply"


azure login --service-principal -u ${azure_service_principal_id} -p ${azure_service_principal_password} --tenant ${azure_tenant_id}

resgroup_lookup_net=${azure_terraform_prefix}

function fn_get_ip {
      # Adding retry logic to this because Azure doesn't always return the IPs on the first attempt
      for (( z=1; z<6; z++ )); do
           sleep 1
           azure_cmd="azure network public-ip list -g ${resgroup_lookup_net} --json | jq '.[] | select( .name | contains(\"${1}\")) | .ipAddress' | tr -d '\"'"
           pub_ip=$(eval $azure_cmd)

           if [[ -z ${pub_ip} ]]; then
             echo "Attempt $z of 5 failed to get an IP Address value returned from Azure cli" 1>&2
           else
             echo ${pub_ip}
             return 0
           fi
      done

     if [[ -z ${pub_ip} ]]; then
       echo "I couldnt get any ip from Azure CLI for ${1}"
       exit 1
     fi
}

pub_ip_bosh=$(fn_get_ip "bosh-public-ip")

echo "You have now deployed Public IP to azure that must be resolvable to:"
echo "----------------------------------------------------------------------------------------------"
echo "bosh.${bosh_domain} == ${pub_ip_bosh}"
echo "----------------------------------------------------------------------------------------------"

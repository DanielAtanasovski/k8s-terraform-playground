# Provision cluster
plan_cluster:
	cd cluster-provision && terraform init && terraform plan -out .cluster_plan

apply_cluster:
	cd cluster-provision && terraform apply -auto-approve

destroy_cluster:
	cd cluster-provision && terraform destroy

# Provision helm charts / applications
plan_helm:
	cd helm-provision && terraform init && terraform plan -out .helm_plan

apply_helm:
	cd helm-provision && terraform apply -auto-approve

destroy_helm:
	cd helm-provision && terraform destroy
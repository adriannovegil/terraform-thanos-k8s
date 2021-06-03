.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

stateinit: ## Initializes the bucket and dynamodb for state
	@terraform init

stateplan: stateinit ## Shows the plan
	@terraform plan -input=false -refresh=true

stateapply: stateinit
	@terraform apply -input=true -refresh=true

init: ## Initializes the terraform remote state backend and pulls the correct projects state.
	@rm -rf .terraform/*.tf*
	@terraform init

update: ## Gets any module updates
	@terraform get -update=true &>/dev/null

plan: init update ## Runs a plan. Note that in Terraform < 0.7.0 this can create state entries.
	@terraform plan -input=false -refresh=true -var-file=inputs.tfvars

plan-destroy: init update ## Shows what a destroy would do.
	@terraform plan -input=false -refresh=true -module-depth=-1 -destroy -var-file=inputs.tfvars

show: init ## Shows a module
	@terraform show -module-depth=-1

graph: ## Runs the terraform grapher
	@rm -f graph.png
	@terraform graph -draw-cycles -module-depth=-1 | dot -Tpng > graph.png
	@open graph.png

apply: init update ## Applies a new state.
	@terraform apply -input=true -refresh=true -var-file=inputs.tfvars

output: update ## Show outputs of a module or the entire state.
	@terraform output

destroy: init update ## Destroys targets
	@terraform destroy -var-file=inputs.tfvars

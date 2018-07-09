.PHONY: help minikube debug deploy deploy_development deploy_staging deploy_production

.DEFAULT_GOAL := help

DEPLOY_ENV?=development

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

start_minikube:  ## Setup minikube locally
	minikube status || minikube start
	minikube addons enable ingress

deploy:
	ansible-playbook ansible/deploy-services.yaml -e '@ansible/envs/$(DEPLOY_ENV).yaml' --tags $(TAGS)

deploy_development:  ## Deploy the provided application(s) to the development environment
	DEPLOY_ENV=development make deploy

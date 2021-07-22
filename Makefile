.PHONY: setup-with-nats
setup-with-nats: setup-kubernetes install-nats

.PHONY: setup-kubernetes
setup-kubernetes:
	./setup-kubernetes.sh kind-1
	./setup-kubernetes.sh kind-2
	./setup-kubernetes.sh kind-3

.PHONY: destroy-kubernetes
destroy-kubernetes:
	kind delete clusters kind-1 kind-2 kind-3

.PHONY: install-nats
install-nats:
	./install-cluster.sh kind-1
	./install-cluster.sh kind-2
	./install-cluster.sh kind-3

.PHONY: uninstall-nats
uninstall-nats:
	./uninstall-cluster.sh kind-1
	./uninstall-cluster.sh kind-2
	./uninstall-cluster.sh kind-3

.PHONY: helm-dependencies
helm-dependencies:
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	helm repo update

.PHONY: server-list-cluster-1
server-list-cluster-1:
	kubectl exec -n default -it deployment/nats-box -- nats server list --user=admin --password=changeit
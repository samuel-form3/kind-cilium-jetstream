.PHONY: setup
setup:
	./setup-kubernetes.sh kind-1
	./setup-kubernetes.sh kind-2
	./setup-kubernetes.sh kind-3

.PHONY: install
install:
	./install-cluster.sh kind-1
	./install-cluster.sh kind-2
	./install-cluster.sh kind-3

.PHONY: uninstall
uninstall:
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
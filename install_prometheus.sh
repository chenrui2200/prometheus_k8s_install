kubectl delete -f ./operator/operator-crd.yml
sleep 5
kubectl apply -f ./operator/operator-crd.yml
kubectl apply -f ./operator/operator-rbac.yml
kubectl wait crd/podmonitors.monitoring.coreos.com --for condition=established --timeout=60s
kubectl apply -f ./operator/operator-dp.yml
kubectl apply -f ./node-exporter/node-exporter-sa.yml
kubectl apply -f ./node-exporter/node-exporter-rbac.yml
kubectl apply -f ./node-exporter/node-exporter-svc.yml
kubectl apply -f ./node-exporter/node-exporter-ds.yml

kubectl apply -f ./grafana/pv-pvc-hostpath.yml
kubectl apply -f ./grafana/grafana-sa.yml
kubectl apply -f ./grafana/grafana-source.yml
kubectl apply -f ./grafana/grafana-datasources.yml
kubectl apply -f ./grafana/grafana-admin-secret.yml
kubectl apply -f ./grafana/grafana-svc.yml
kubectl delete configmap grafana-config all-grafana-dashboards --namespace=monitoring
kubectl create configmap grafana-config --from-file=./grafana/grafana.ini --namespace=monitoring
kubectl create configmap all-grafana-dashboards --from-file=./grafana/dashboard --namespace=monitoring
kubectl delete -f ./grafana/grafana-dp.yml
sleep 5
kubectl apply -f ./grafana/grafana-dp.yml
kubectl apply -f ./service-discovery/kube-controller-manager-svc.yml
kubectl apply -f ./service-discovery/kube-scheduler-svc.yml
kubectl apply -f ./prometheus/prometheus-secret.yml
kubectl apply -f ./prometheus/prometheus-rules.yml
kubectl apply -f ./prometheus/prometheus-rbac.yml
kubectl apply -f ./prometheus/prometheus-svc.yml
kubectl wait crd/prometheuses.monitoring.coreos.com --for condition=established --timeout=60s
kubectl delete -f ./prometheus/prometheus-main.yml
sleep 5
kubectl apply -f ./prometheus/pv-pvc-hostpath.yaml
kubectl apply -f ./prometheus/prometheus-main.yml
sleep 5
# 部署sm
kubectl apply -f ./servicemonitor/alertmanager-sm.yml
kubectl apply -f ./servicemonitor/coredns-sm.yml
kubectl apply -f ./servicemonitor/kube-apiserver-sm.yml
kubectl apply -f ./servicemonitor/kube-controller-manager-sm.yml
kubectl apply -f ./servicemonitor/kube-scheduler-sm.yml
kubectl apply -f ./servicemonitor/kubelet-sm.yml
kubectl apply -f ./servicemonitor/kubestate-metrics-sm.yml
kubectl apply -f ./servicemonitor/node-exporter-sm.yml
kubectl apply -f ./servicemonitor/prometheus-operator-sm.yml
kubectl apply -f ./servicemonitor/prometheus-sm.yml
kubectl apply -f ./servicemonitor/pushgateway-sm.yml

# 部署prometheus_adapter
kubectl apply -f ./prometheus_adapter/metric_rule.yaml
kubectl apply -f ./prometheus_adapter/prometheus_adapter.yaml

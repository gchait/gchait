SERVING_VERSION="1.13.1"
NET_CONTOUR_VERSION="1.13.0"

SERVING_RELEASES="https://github.com/knative/serving/releases"
NET_CONTOUR_RELEASES="https://github.com/knative/net-contour/releases"

curl -sfL https://get.k3s.io | sh -s - --disable traefik

kubectl apply -f "${SERVING_RELEASES}/download/knative-v${SERVING_VERSION}/serving-crds.yaml"
kubectl apply -f "${SERVING_RELEASES}/download/knative-v${SERVING_VERSION}/serving-core.yaml"

kubectl apply -f "${NET_CONTOUR_RELEASES}/download/knative-v${NET_CONTOUR_VERSION}/contour.yaml"
kubectl apply -f "${NET_CONTOUR_RELEASES}/download/knative-v${NET_CONTOUR_VERSION}/net-contour.yaml"

kubectl patch cm -n knative-serving config-network --type merge \
  --patch '{"data":{"ingress-class":"contour.ingress.networking.knative.dev"}}'

echo "The kubeconfig is available at '/etc/rancher/k3s/k3s.yaml'."

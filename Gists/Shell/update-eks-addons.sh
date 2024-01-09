eks_version=$(xxxxx)

for addon in vpc-cni coredns kube-proxy aws-ebs-csi-driver; do
	addon_version=$(aws eks describe-addon-versions --region ${region} --addon-name ${addon} \
		--kubernetes-version ${eks_version} --query 'addons[].addonVersions[0].addonVersion' --output text)
		
	aws eks update-addon --region ${region} --cluster-name ${cluster_name} \
		--addon-name ${addon} --addon-version ${addon_version} --resolve-conflicts OVERWRITE
		
	aws eks wait addon-active --region ${region} --cluster-name ${cluster_name} --addon-name ${addon}
done

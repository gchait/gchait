node_group_name=$(xxxxx)

aws eks update-nodegroup-version --cluster-name ${cluster_name} --region ${region} \
	--nodegroup-name ${node_group_name}

aws eks wait nodegroup-active --cluster-name ${cluster_name} --region ${region} \
	--nodegroup-name ${node_group_name}

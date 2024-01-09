git pull

git status --porcelain | grep . || \
	{ echo "Updating Git failed since no changes were made." >&2; exit 0; }

git add -A

git commit ${options} -m "${commit_msg}"

git push origin

touch .push_successful


dir=$(dirname $0)

bash $dir/run.sh 26 fedora/26/x86_64/updates/atomic-host
bash $dir/run.sh 26 fedora/26/x86_64/testing/atomic-host
bash $dir/run.sh 27 fedora/27/x86_64/atomic-host
#bash $dir/run.sh 27 fedora/27/x86_64/updates/atomic-host
#bash $dir/run.sh 27 fedora/27/x86_64/testing/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/x86_64/atomic-host

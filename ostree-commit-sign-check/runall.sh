
dir=$(dirname $0)

# f27
bash $dir/run.sh 27 fedora/27/x86_64/atomic-host
bash $dir/run.sh 27 fedora/27/x86_64/updates/atomic-host
bash $dir/run.sh 27 fedora/27/x86_64/testing/atomic-host

bash $dir/run.sh 27 fedora/27/ppc64le/atomic-host
bash $dir/run.sh 27 fedora/27/ppc64le/updates/atomic-host
bash $dir/run.sh 27 fedora/27/ppc64le/testing/atomic-host

bash $dir/run.sh 27 fedora/27/aarch64/atomic-host
bash $dir/run.sh 27 fedora/27/aarch64/updates/atomic-host
bash $dir/run.sh 27 fedora/27/aarch64/testing/atomic-host

bash $dir/run.sh 27 fedora/27/x86_64/workstation  https://kojipkgs.fedoraproject.org/compose/ostree/27/

# rawhide
bash $dir/run.sh rawhide fedora/rawhide/x86_64/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/ppc64le/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/aarch64/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/x86_64/workstation  https://kojipkgs.fedoraproject.org/compose/ostree/rawhide/

# f26
bash $dir/run.sh 26 fedora/26/x86_64/atomic-host
bash $dir/run.sh 26 fedora/26/x86_64/updates/atomic-host
bash $dir/run.sh 26 fedora/26/x86_64/testing/atomic-host
bash $dir/run.sh 26 fedora/26/x86_64/workstation  https://kojipkgs.fedoraproject.org/compose/ostree/26/

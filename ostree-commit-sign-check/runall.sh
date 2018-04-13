
dir=$(dirname $0)

# f28
bash $dir/run.sh 28 fedora/28/x86_64/atomic-host
#bash $dir/run.sh 28 fedora/28/x86_64/updates/atomic-host
bash $dir/run.sh 28 fedora/28/x86_64/testing/atomic-host

bash $dir/run.sh 28 fedora/28/ppc64le/atomic-host
#bash $dir/run.sh 28 fedora/28/ppc64le/updates/atomic-host
bash $dir/run.sh 28 fedora/28/ppc64le/testing/atomic-host

bash $dir/run.sh 28 fedora/28/aarch64/atomic-host
#bash $dir/run.sh 28 fedora/28/aarch64/updates/atomic-host
bash $dir/run.sh 28 fedora/28/aarch64/testing/atomic-host

bash $dir/run.sh 28 fedora/28/x86_64/workstation         
#bash $dir/run.sh 28 fedora/28/x86_64/updates/workstation
bash $dir/run.sh 28 fedora/28/x86_64/testing/workstation

# f27
bash $dir/run.sh 27 fedora/27/x86_64/atomic-host          https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/x86_64/updates/atomic-host  https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/x86_64/testing/atomic-host  https://kojipkgs.fedoraproject.org/atomic/27/

bash $dir/run.sh 27 fedora/27/ppc64le/atomic-host         https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/ppc64le/updates/atomic-host https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/ppc64le/testing/atomic-host https://kojipkgs.fedoraproject.org/atomic/27/

bash $dir/run.sh 27 fedora/27/aarch64/atomic-host         https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/aarch64/updates/atomic-host https://kojipkgs.fedoraproject.org/atomic/27/
bash $dir/run.sh 27 fedora/27/aarch64/testing/atomic-host https://kojipkgs.fedoraproject.org/atomic/27/

bash $dir/run.sh 27 fedora/27/x86_64/workstation
bash $dir/run.sh 27 fedora/27/x86_64/updates/workstation
bash $dir/run.sh 27 fedora/27/x86_64/testing/workstation

# rawhide
bash $dir/run.sh rawhide fedora/rawhide/x86_64/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/ppc64le/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/aarch64/atomic-host
bash $dir/run.sh rawhide fedora/rawhide/x86_64/workstation

# f26
bash $dir/run.sh 26 fedora/26/x86_64/atomic-host         https://kojipkgs.fedoraproject.org/atomic/26/
bash $dir/run.sh 26 fedora/26/x86_64/updates/atomic-host https://kojipkgs.fedoraproject.org/atomic/26/
bash $dir/run.sh 26 fedora/26/x86_64/testing/atomic-host https://kojipkgs.fedoraproject.org/atomic/26/

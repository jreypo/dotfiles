alias bdf='df -H'
alias ovftool='"/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool"'
alias vmrun='"/Applications/VMware Fusion.app/Contents/Library/vmrun"'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias lports='netstat -anf inet -p tcp | grep LISTEN'
alias htop='sudo htop'
alias ls='ls -aFG'
alias ll='ls -ls'
alias l='ls -lsh'
alias j='jobs -l'
alias fusion='open -a "VMware Fusion"'
alias open='reattach-to-user-namespace open'
alias vboxmanage='VBoxManage'
alias ktx=kubectx
alias python=/usr/local/bin/python3

# kubectl aliases
alias deployments='kubectl get deployment'
alias k='kubectl'
alias kd='kubectl get nodes -o wide'
alias kdd='kubectl describe deployment'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias klogs='kubectl logs'
alias ksvc='kubectl get svc -o wide'
alias pods='kubectl get pods -o wide'
alias nodes='kubectl get node -o wide'
alias contexts='kubectl config get-contexts'
alias context='kubectl config use-context'
alias kclusters='kubectl config get-clusters'

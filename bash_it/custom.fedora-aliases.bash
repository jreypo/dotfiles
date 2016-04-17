alias ls='ls -aF --color=auto'
alias ll='ls -ls'
alias l='ls -lsh'
alias bdf='df -h'
alias grep='grep --color'
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias pcpu='ps auxf | sort -nr -k 3 | head -10'
alias pmem='ps auxf | sort -nr -k 4 | head -10'
alias ports='netstat -tulanp'
alias path='echo -e ${PATH//:/\\n}'
alias h='history'
alias j='jobs -l'
alias cls=clear
alias docker='sudo docker'
alias virsh='sudo virsh'
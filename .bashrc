#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# >>> headroom docker-native >>>
export PATH="/home/alex/.local/bin:$PATH"
# <<< headroom docker-native <<<
export DXVK_ENABLE_NVAPI=1
export PROTON_ENABLE_NVAPI=1
export DXVK_ENABLE_NVAPI=1
export PROTON_ENABLE_NVAPI=1

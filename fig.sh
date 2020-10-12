# this is what will be added to everyone's .profile, .bash_profile, and .zprofile


# 1. Source custom/figpath.sh (or should this just be saved in fig defaults??? probably...)
# 2. Source aliases (source custom/aliases/*.sh)
# 	Wildcard means you can download other people's aliases


export FIGPATH="~/.fig/bin:~/run:"
FIGPATH=$FIGPATH""

##Run aliases shell script
[ -s ~/.fig/custom/aliases/_myaliases.sh ] && source ~/.fig/custom/aliases/*.sh



# Get current working directory of Terminal
function cd() { builtin cd "$1"; fig bg:cd || true }
fig bg:cd



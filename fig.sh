##Run aliases shell script
[ -s ~/.fig/user/aliases/_myaliases.sh ] && source ~/.fig/user/aliases/*.sh


# Gives fig context for cwd in each window
fig bg:init $(tty)



# Backup for getting Fig's context
function cd() { builtin cd "$1"; fig bg:cd || true }
fig bg:cd




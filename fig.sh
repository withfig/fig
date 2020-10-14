if command -v fig &> /dev/null && [ -z "$FIG" ]
then
	# Gives fig context for cwd in each window
	fig bg:init $(tty) 
	fig bg:cd

	# Backup for getting Fig's context
	function cd() { builtin cd "$1"; fig bg:cd || true; }

	##Run aliases shell script
	[ -s ~/.fig/user/aliases/_myaliases.sh ] && source ~/.fig/user/aliases/*.sh

	FIG=1
fi




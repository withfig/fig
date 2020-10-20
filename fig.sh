if command -v fig &> /dev/null && [ -z "$FIG" ]
then
	# Gives fig context for cwd in each window
	fig bg:init $(tty) 
	fig bg:cd

	# Backup for getting Fig's context
	function cd() { if [ -n "$1" ]; then builtin cd "$1"; else builtin cd; fi; fig bg:cd || true; }

	# Run aliases shell script
	[ -s ~/.fig/user/aliases/_myaliases.sh ] && source ~/.fig/user/aliases/*.sh

	# Check for prompts or onboarding
	[ -s ~/.fig/tools/prompts.sh ] && source ~/.fig/tools/prompts.sh

	FIG=1
fi




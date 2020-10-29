if command -v fig &> /dev/null && [ -z "$FIG_ENV_VAR" ]
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

	
	export FIG_ENV_VAR=1

fi


# Try to make sure this doesn't load twice!!! 
# Need to add fig.sh to bashrx and .zshrc
if [ -z "$FIG_SHELL_VAR" ]
then
	if [[ $BASH ]]
	then
		# Set environment VAR
		export PROMPT_COMMAND='(fig bg:prompt & ); '$PROMPT_COMMAND

	elif [[ $ZSH_NAME ]]
	then
		autoload -Uz add-zsh-hook
		function go_fig() { (fig bg:prompt &); }
		add-zsh-hook precmd go_fig

	fi
	FIG_SHELL_VAR=1
fi




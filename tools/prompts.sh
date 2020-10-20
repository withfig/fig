# probably not going to use this. Everything has been bucketed into install_and_upgrade.sh instead

# Check if the user has done onboarding
# THIS IS VERY SLOW>... Transition to a file soon
FIG_ONBOARDING=$(defaults read com.mschrage.fig onboarding 2> /dev/null)

# Check if onboarding variable is empty or not
if [[ -z "$FIG_ONBOARDING" ]]
then
	# Is empty. Set it to false
	defaults write com.mschrage.fig onboarding -bool false
	FIG_ONBOARDING='0'
fi

# echo $FIG_ONBOARDING


if  [[ $FIG_ONBOARDING = '0' ]]
then
	# echo running onboarding
	# Check for prompts or onboarding
	[ -s ~/.fig/tools/fig_onboarding.sh ] && source ~/.fig/tools/fig_onboarding.sh
fi



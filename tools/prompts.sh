#!/usr/bin/env bash


# This should read all the user defaults

if [[ -s ~/.fig/user/config ]] 
then
	source ~/.fig/user/config 
else
	return
fi


# How to update a specific variable
# sed -i '' "s/FIG_ONBOARDING=.*/FIG_ONBOARDING=1/g" ~/.fig/user/config 2> /dev/null




# Check if onboarding variable is empty or not

# if [[ -z "$FIG_ONBOARDING" ]]
# then
# 	# Is empty. Set it to false
#     grep -q 'FIG_ONBOARDING' ~/.fig/user/config || echo "FIG_ONBOARDING=0" >> ~/.fig/user/config
# else 
# fi



if  [[ $FIG_ONBOARDING = '0' ]]
then
	# echo running onboarding
	# Check for prompts or onboarding
	[ -s ~/.fig/tools/drip/fig_onboarding.sh ] && ~/.fig/tools/drip/fig_onboarding.sh 

fi



# In the future we will calculate when a user signed up and if there are any drip campaigns remaining for the user
# We will hardcode time since sign up versus drip campaign date here






# Removes this variable from 
# unset -f FIG_ONBOARDING

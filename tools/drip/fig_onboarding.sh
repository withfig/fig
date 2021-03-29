#!/usr/bin/env bash

# Fig onboarding shell script
# Based somewhat on oh my zshell https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh

# needed so that ^c works when run as `fig onboarding`
set -e

# Colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

CODE=$(tput setaf 153)

# Other colors
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)

# Weights and decoration
BOLD=$(tput bold)
UNDERLINE=$(tput smul)
UNDERLINE_END=$(tput rmul)
HIGHLIGHT=$(tput smso)
HIGHLIGHT_END=$(tput rmso)
NORMAL=$(tput sgr0)

# Structure
TAB='   '
SEPARATOR="  \n\n  --\n\n\n"


print_special() {
	echo "${TAB}$@${NORMAL}"$'\n'
}


press_any_key_to_continue() {
    
    echo # new line
    read -n 1 -s -r -p "${TAB}${HIGHLIGHT} Press any key to continue ${HIGHLIGHT_END}"
    echo # new line
    echo # new line
}

press_enter_to_continue() {
    
   echo # new line

   if [ "$1" != "" ]
   then
      read -n 1 -s -r -p "${TAB}${HIGHLIGHT} $1 ${HIGHLIGHT_END}" pressed_key 
   else
      read -n 1 -s -r -p "${TAB}${HIGHLIGHT} Press enter to continue ${HIGHLIGHT_END}" pressed_key 
   fi


   while true; do

   if [ "$pressed_key" == "" ] # ie if pressed_key = enter
   then
      echo # new line
      echo # new line
      break
   else 
      read -n 1 -s -r pressed_key
   fi

   done
    
}




# In case user quits script
exit_script_annoying() {
   echo
   echo
   print_special "Sorry to see you go."
   print_special "If you have feedback, we'd appreciate you emailing hello@withfig.com"
   echo

   read -n 1 -r -p "${TAB}Do you want to finish Fig's onboarding in your next Terminal session? [y/N] "  response

   if [[ "$response" =~ ^(yes|y|YES|Y)$ ]]
   then
      sed -i '' "s/FIG_ONBOARDING=.*/FIG_ONBOARDING=0/g" ~/.fig/user/config 2> /dev/null
   else
      sed -i '' "s/FIG_ONBOARDING=.*/FIG_ONBOARDING=1/g" ~/.fig/user/config 2> /dev/null
   fi

   echo

   trap - SIGINT SIGTERM SIGQUIT # clear the trap
   kill -- -$$ # Kill the fig onboarding process
}


# In case user quits script
exit_script_nice() {
   
   sed -i '' "s/FIG_ONBOARDING=.*/FIG_ONBOARDING=1/g" ~/.fig/user/config 2> /dev/null

   clear 
   echo
   echo
   print_special "${BOLD}${UNDERLINE}Fig's onboarding was quit${UNDERLINE_END}${NORMAL}"
   echo
   print_special "You can redo this onboarding any time. Just run ${BOLD}${MAGENTA}fig onboarding${NORMAL}"
   echo
   print_special "Have feedback? Email ${UNDERLINE}hello@withfig.com${UNDERLINE_END}"
   echo
   echo

   trap - SIGINT SIGTERM SIGQUIT # clear the trap
   exit 1
   # kill -- -$$# Kill the fig onboarding process. 
}


# If the user does ctrl + c, run the exit_script function
trap exit_script_nice SIGINT SIGTERM SIGQUIT



# Help text


show_help() {
   # make sure the final EOF is aligned with the end 
less -R <<EOF


   ${BOLD}${MAGENTA}${UNDERLINE}Fig Onboarding Help${UNDERLINE_END}${NORMAL}
   (press q to quit)



   ${BOLD}The Fig autocomplete box disappeared${NORMAL}
      This can happen if you hit 
         * ${BOLD}esc${NORMAL}
         * the ${BOLD}↑${NORMAL} up arrow too many times (after the up arrow shows your history, Fig hides until the next line)

      ${UNDERLINE}To bring it back${UNDERLINE_END}: hit the enter key on an empty line once or twice. It should reappear. 


   ${BOLD}Where is the Fig Menu${NORMAL}
      Click the Fig Icon (◧) in your Mac status bar (top right of your screen)


   ${BOLD}I don't see Fig popup next to my cursor${NORMAL}
      Hmm. Try some of the following to debug.

      1. Hit enter a few times then start typing. Maybe you hid it by hitting the up arrow key too many times.

      2. Make sure the Fig CLI tool is installed:
         * Go to Fig Menu (◧) > Settings > Developer > Install CLI Tool 

      3. Make sure Accessibility is enabled
         * Go to Fig Menu (◧) > Settings > Developer > Request Accessibility Permission
           (This should take you to System Preferences > Security & Privacy > Accessibility)
         * Click the lock icon to unlock (it may prompt for your password)
         * If Fig is unchecked, check it. If Fig is checked, uncheck it then check it again.

      4. Toggle Autocomplete off and on again
         * Go to Fig Menu (◧) > Autocomplete 


      If the problem persists: please let us know! Contact the Fig team at hello@withfig.com


   ${BOLD}What does the ↪ symbol / suggestion mean?${NORMAL}
      This lets you run the command that's currently in your Terminal. 
      Sometimes Fig's autocomplete appears when you actually want to run a command. Rather than clicking escape or the up arrow, this lets you run the command by clicking enter.
   


   ${BOLD}I want to quit this onboarding / walkthrough${NORMAL}
      Hit ctrl + c



   ${BOLD}I want to quit Fig${NORMAL}
      * Go to Fig Menu (◧) > Quit Fig

   

   ${BOLD}I want to uninstall Fig${NORMAL}
      * Go to Fig Menu (◧) > Settings > Uninstall Fig
      3. If you're feeling generous, we would love to hear why you uninstalled Fig. hello@withfig.com
   


   ${BOLD}What is cd?${NORMAL}
      cd is a shell command that lets you change directories. e.g. cd ~/Desktop will change the current directory in your shell to the Desktop.



EOF
}



### Core Script ###



#### How to print multiple lines easily

#cat <<EOF
	## This is known as a here document (or heredoc)
	## Using a hyphen between << and EOF will remove any indenting beforehand e.g. <<-EOF
		# https://stackoverflow.com/questions/4937792/using-variables-inside-a-bash-heredoc
	## Using quotes around EOF will remove expansions
		# https://superuser.com/questions/1436906/need-to-expand-a-variable-in-a-heredoc-that-is-in-quotes
#EOF

clear

# Done using http://patorjk.com/software/taag/#p=testall&f=Graffiti&t=fig
# Font name = ANSI Shadow
cat <<'EOF'


   ███████╗██╗ ██████╗ 
   ██╔════╝██║██╔════╝ 
   █████╗  ██║██║  ███╗
   ██╔══╝  ██║██║   ██║
   ██║     ██║╚██████╔╝
   ╚═╝     ╚═╝ ╚═════╝  ....is now installed!


EOF


## you can also use <<-'EOF' to strip tab character from start of each line
cat <<EOF 
   Hey! Welcome to ${MAGENTA}${BOLD}Fig${NORMAL}.

   This quick walkthrough will show you how Fig works.


   Stuck? Type ${BOLD}help${NORMAL}. 
   Want to quit? Hit ${BOLD}ctrl + c${NORMAL}

EOF

fig bg:event "Started Shell Onboarding"
press_enter_to_continue

clear

cd ~
cat <<EOF
   
   ${BOLD}${MAGENTA}Fig${NORMAL} suggests commands, options, and arguments as you type.

   ${BOLD}Autocomplete Basics${NORMAL}

   * To filter: just start typing
   * To navigate: use the ${BOLD}↓${NORMAL} & ${BOLD}↑${NORMAL} arrow keys
   * To select: hit ${BOLD}enter${NORMAL} or ${BOLD}tab${NORMAL}

EOF

press_enter_to_continue
clear

cat <<EOF

   ${BOLD}Example${NORMAL}
   Try typing ${BOLD}cd${NORMAL} then space. Autocomplete will suggest the folders in your home directory.
   
   ${BOLD}To Continue...${NORMAL}
   cd into the "${BOLD}.fig${NORMAL}" folder
  
   ${UNDERLINE}Tip${UNDERLINE_END}: Selecting a suggestion with a ${BOLD}🟥 red icon${NORMAL} and ${BOLD}↪${NORMAL} symbol will immediately execute a command

EOF


# printf "${TAB}$ " 


# osascript -e 'tell application "System Events" 
# 	keystroke "cd ~/" 
	# end tell'


while true; do
   input=""
   read -e -p "${TAB}$ " input
   echo # New line after output
   if [[ $input == 'cd .fig/' ]]
   then
      cd ~/.fig
      print_special "${BOLD}Awesome!${NORMAL}"
      press_enter_to_continue
      break
   

   elif [[ $input == 'cd .fig' ]]
   then
      cd ~/.fig
      print_special ${BOLD}Awesome!${NORMAL}
      print_special "You may have seen ${BOLD}.fig ↪${NORMAL} and ${BOLD}.fig/${NORMAL}. The first runs the command for you. The second shows you the folders underneath .fig/"
      press_enter_to_continue
      break

   elif [[ $input == cd* ]]
   then
   print_special "Whoops. Looks like you just typed ${BOLD}cd${NORMAL}. Type ${BOLD}cd .fig/${NORMAL} to continue"
   print_special "You can hit enter if you see the ${BOLD}↪${NORMAL} symbol"

   elif [[ $input == cd* ]]
   then
      cd ~/.fig
      print_special "${BOLD}Awesome!${NORMAL}"
      print_special "Looks like you cd'd into another directory. Glad you are playing around! We are going to put you in ~/.fig for the next step"
      press_enter_to_continue
      break

   elif [[ $input == '' ]]
   then
      print_special "Type ${BOLD}cd .fig/${NORMAL} to continue"
      print_special "You can hit enter if you see the ${BOLD}↪${NORMAL} symbol"
   
   elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
   then 
      show_help
      print_special "Type ${BOLD}cd .fig/${NORMAL} to continue"
   else
      print_special "${YELLOW}Whoops. Looks like you tried something other than cd."
      print_special "Type ${BOLD}cd .fig/${NORMAL} to continue"
   fi
done



clear 


# Hiding Autocomplete

cat <<EOF

   ${BOLD}Hiding Autocomplete${NORMAL}

   Make the autocomplete window disappear by:

   * Hitting ${BOLD}esc${NORMAL}
   * Hitting the ${BOLD}↑${NORMAL} up arrow until you start seeing your shell history
      Note: You can use the ${BOLD}↓${NORMAL} down arrow to show Fig again

EOF
press_enter_to_continue
clear 

cat <<EOF

   ${BOLD}Another Example${NORMAL}
   Fig can insert text and move your cursor around.

   ${BOLD}To Continue...${NORMAL}

   Run ${BOLD}git commit -m 'hello'${NORMAL}

   
   (Don't worry, this will ${BOLD}not${NORMAL} actually run the git command)

EOF



while true; do
   input=""
   read -e -p "${TAB}$ " input
   echo # New line after output
   if [[ $input == "git commit"* ]]
   then
      print_special "${BOLD}Nice work!${NORMAL}"
      press_enter_to_continue
      break
   
   elif [[ $input == 'continue' ]]
   then
      break
   elif [[ $input == '' ]]
   then
      print_special "Try running ${BOLD}git commit -m 'hello'${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
   elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
   then 
      show_help
      print_special "Try running ${BOLD}git commit -m 'hello'${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
   else
      print_special "${YELLOW}Whoops. Looks like you tried something other than ${BOLD}git commit${NORMAL}."
      print_special "Try running ${BOLD}git commit -m 'hello'${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
   fi
done


clear 




# cat <<EOF
   
#    ${BOLD}More Cool Stuff${NORMAL}
   
#    You may see the ${BOLD}↪${NORMAL} suggestion when navigating files and folders.

#    This runs whatever is already inserted in your Terminal and closes the autocomplete window.   

# EOF


# press_enter_to_continue

# clear



cat <<EOF
   
   ${BOLD}Last Step: The ${MAGENTA}Fig${NORMAL} ${BOLD}CLI${NORMAL}

   fig               open the fig ◧ menu in the status bar
   fig invite        invite up to 5 friends or teammates to Fig
   fig feedback      send feedback directly to the Fig founders
   fig update        update Fig's autocomplete scripts
   fig --help        a summary of Fig commands with examples


   ${BOLD}To Continue...${NORMAL} 

   Run the ${MAGENTA}${BOLD}fig${NORMAL} command. 
   (You can also type ${UNDERLINE}continue${NORMAL})

EOF

#, like ${MAGENTA}${BOLD}fig invite${NORMAL} or ${MAGENTA}${BOLD}fig feedback${NORMAL}

# Eventually prompt the user: do you want to invite friends to fig? type y if yes or otherwise it's a no
# Only run the below if yes


while true; do

   input=""
   read -e -p "${TAB}$ " input
   echo # New line after output
   # if [[ $input == "fig feedback"* ]]
   # then
   #    eval $input
   #    print_special "${BOLD}Thanks${NORMAL} so much for your feedback :)"
   #    press_enter_to_continue
   #    break

   # elif [[ $input == "fig invite"* ]]
   # then
   #    eval $input
   #    press_enter_to_continue
   #    break
   
   # elif [[ $input == fig* ]]
   # then
   #    eval $input
   #    print_special "${BOLD}Glad you like Fig!${NORMAL}"
   #    press_enter_to_continue
   #    break
   if [[ $input == "fig" ]]
   then
      eval $input
      print_special "${BOLD}Awesome!${NORMAL}"
      echo
      print_special "If Fig ever stops working, you can use the debug tool at the top of this menu to see what's wrong."
      press_enter_to_continue
      break
   elif [[ $input == "fig feedback"* ]]
   then
      eval $input
      print_special "${BOLD}Thanks${NORMAL} so much for your feedback :)"
      
      echo
      print_special "${BOLD}To Continue...${NORMAL}"
      print_special "Run the ${MAGENTA}${BOLD}fig${NORMAL} command."
      print_special "(You can also type ${UNDERLINE}continue${NORMAL})"

   elif [[ $input == "fig invite"* ]]
   then
      eval $input
      print_special "${BOLD}Thanks${NORMAL} so much for inviting friends to Fig:)"
      echo
      print_special "${BOLD}To Continue...${NORMAL}"
      print_special "Run the ${MAGENTA}${BOLD}fig${NORMAL} command."
      print_special "(You can also type ${UNDERLINE}continue${NORMAL})"

   elif [[ $input == 'continue' ]]
   then
      break
   elif [[ $input == '' ]]
   then
      echo
      print_special "${BOLD}To Continue...${NORMAL}"
      print_special "Run the ${MAGENTA}${BOLD}fig${NORMAL} command."
      print_special "(You can also type ${UNDERLINE}continue${NORMAL})"
   elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
   then 
      show_help
      echo
      print_special "${BOLD}To Continue...${NORMAL}"
      print_special "Run the ${MAGENTA}${BOLD}fig${NORMAL} command."
      print_special "(You can also type ${UNDERLINE}continue${NORMAL})"
   else
      print_special "${YELLOW}Whoops. Looks like you tried something other than the ${MAGENTA}${BOLD}fig${NORMAL} command."
      echo
      print_special "${BOLD}To Continue...${NORMAL}"
      print_special "Run the ${MAGENTA}${BOLD}fig${NORMAL} command."
      print_special "(You can also type ${UNDERLINE}continue${NORMAL})"
   fi
done


clear 



cat <<EOF

   ${BOLD}Want to contribute${NORMAL}?

   * Check out our docs: ${UNDERLINE}https://docs.withfig.com${UNDERLINE_END}
   * Submit a pull request ${UNDERLINE}https://github.com/withfig/autocomplete${UNDERLINE_END}

   ${BOLD}Get in touch:${NORMAL}

   * ${UNDERLINE}mailto:hello@withfig.com${UNDERLINE_END}
   * Or ${MAGENTA}${BOLD}fig feedback${NORMAL}

EOF

# Tell use how to open urls based on terminal type
# https://superuser.com/questions/683962/how-to-identify-the-terminal-from-a-script
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]
then
   echo "   ${UNDERLINE}Hint${UNDERLINE_END}: Hold cmd + click to open URLs"
else
   echo "   ${UNDERLINE}Hint${UNDERLINE_END}: Hold cmd + double-click to open URLs"
fi
echo



sed -i '' "s/FIG_ONBOARDING=.*/FIG_ONBOARDING=1/g" ~/.fig/user/config 2> /dev/null
fig bg:event "Completed Shell Onboarding"

    
echo # new line
press_enter_to_continue 'Press enter to finish'
echo # new line
echo # new line



clear

# Done using http://patorjk.com/software/taag/#p=testall&f=Graffiti&t=fig
# Font name = Ivrit
# cat <<'EOF'

#                         We hope you enjoy
      
#    .----------------.  .----------------.  .----------------. 
#    | .--------------. || .--------------. || .--------------. |
#    | |  _________   | || |     _____    | || |    ______    | |
#    | | |_   ___  |  | || |    |_   _|   | || |  .' ___  |   | |
#    | |   | |_  \_|  | || |      | |     | || | / .'   \_|   | |
#    | |   |  _|      | || |      | |     | || | | |    ____  | |
#    | |  _| |_       | || |     _| |_    | || | \ `.___]  _| | |
#    | | |_____|      | || |    |_____|   | || |  `._____.'   | |
#    | |              | || |              | || |              | |
#    | '--------------' || '--------------' || '--------------' |
#    '----------------'  '----------------'  '----------------' 


# EOF


## NOTE: DON'T FORMAT THIS, IT IS ACTUALLY FORMATTED CORRECTLY...
cat <<EOF

   ${BOLD}                        ######## ####  ######   
                           ##        ##  ##    ##  
                           ##        ##  ##        
                           ######    ##  ##   #### 
                           ##        ##  ##    ##  
                           ##        ##  ##    ##  
   ${NORMAL}We hope you enjoy...${BOLD}    ##       ####  ######${NORMAL}

EOF

cat <<EOF

   ${BOLD}Note from Fig Team (11 Dec. 2020)${NORMAL} 
   For the moment, we (${BOLD}${MAGENTA}Fig${NORMAL}) have decided to focus on autocomplete / 
   intellisense for the Terminal. 

   When we launched, we were doing a lot: runbooks, apps, sidebar, shortcuts, 
   an app store for the Terminal… We tried to do too much too quickly.

   Limiting our focus to autocomplete in the short-term helps us make sure Fig 
   is a great experience. We plan to revisit everything mentioned above 
   (and more) very soon.

   Brendan & Matt

EOF

#!/usr/bin/env bash

# Fig onboarding shell script
# Based somewhat on oh my zshell https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh



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




# In case user quits script
exit_script() {
   echo
   echo
   print_special "Sorry to see you go."
   print_special "If you have feedback, we'd appreciate you emailing hello@withfig.com"
   echo

   read -n 1 -r -p "${TAB}Do you want to finish Fig's onboarding in your next Terminal session? [y/N] "  response

   if [[ "$response" =~ ^(yes|y|YES|Y)$ ]]
   then
      defaults write com.mschrage.fig onboarding -bool false
   else
      defaults write com.mschrage.fig onboarding -bool true
   fi

   echo

   trap - SIGINT SIGTERM # clear the trap
   kill -- -$$ # Kill the fig onboarding process
}

# If the user does ctrl + c, run the exit_script function
trap exit_script SIGINT SIGTERM




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



   ${BOLD}I don't see Fig popup next to my cursor${NORMAL}
      Hmm. Try some of the following to debug.

      1. Hit enter a few times then start typing. Maybe you hid it by hitting the up arrow key too many times.

      2. Make sure the Fig CLI tool is installed:
         * Go to Fig Menu (◧) -> Debug -> Install CLI Tool 

      3. Make sure Accessibility is enabled
         * Go to Fig Menu (◧) -> Debug -> Request Accessibility Permission
           (This should take you to System Preferences -> Security & Privacy -> Accessibility)
         * Click the lock icon to unlock (it may prompt for your password)
         * If Fig is unchecked, check it. If Fig is checked, uncheck it then check it again.

      4. Toggle Autocomplete off and on again
         * Go to Fig Menu (◧) -> Autocomplete 



      If the problem persists: please let us know! Contact the Fig team at hello@withfig.com


   ${BOLD}Where is the Fig Menu${NORMAL}
      Click the Fig Icon (◧) in your Mac status bar (top right of your screen)


   ${BOLD}What does the ↪ symbol / suggestion mean?${NORMAL}
      This lets you run the command that's currently in your Terminal. 
      Sometimes Fig's autocomplete appears when you actually want to run a command. Rather than clicking escape or the up arrow, this lets you run the command by clicking enter.
   


   ${BOLD}I want to quit this onboarding / walkthrough${NORMAL}
      Hit ctrl + c



   ${BOLD}I want to quit Fig${NORMAL}
      * Go to Fig Menu (◧) -> Quit Fig

   

   ${BOLD}I want to uninstall Fig${NORMAL}
      1. Quit Fig
      2. 'rm -rf ~/.fig'     <-- Be careful with this command! 
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



cat <<EOF ## you can also use <<-'EOF' to strip tab character from start of each line
   Hey! Welcome to ${MAGENTA}${BOLD}Fig${NORMAL}.

   This quick walkthrough will show you how Fig works.

   (If you get stuck, type ${BOLD}help${NORMAL}.)

EOF


press_any_key_to_continue

clear

cd ~
cat <<EOF
   
   ${BOLD}${MAGENTA}Fig${NORMAL} suggests commands, options, and arguments as you type.

   ${BOLD}Autocomplete Basics${NORMAL}
   * To filter: just start typing
   * To navigate: use the ${BOLD}↓${NORMAL} & ${BOLD}↑${NORMAL} arrow keys
   * To select: hit ${BOLD}enter${NORMAL} or ${BOLD}tab${NORMAL}

EOF

press_any_key_to_continue
clear

cat <<EOF

   ${BOLD}Example${NORMAL}
   Try typing ${BOLD}cd${NORMAL} then space. Autocomplete will suggest the folders in your home directory.

<<<<<<< HEAD
   ${BOLD}You Try${NORMAL}
   cd into the "${BOLD}.fig${NORMAL}" folder to continue.
   
=======
   ${BOLD}To Continue...${NORMAL}
   cd into the "${BOLD}.fig${NORMAL}" folder
  
>>>>>>> 43537f0df52e97da04d2189e112340ff81f4030f
   ${UNDERLINE}Hint${UNDERLINE_END}: Hit enter if you see the ${BOLD}↪${NORMAL} suggestion


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
      press_any_key_to_continue
      break
   

   elif [[ $input == 'cd .fig' ]]
   then
      cd ~/.fig
      print_special ${BOLD}Awesome!${NORMAL}
      print_special "Looks like you clicked backspace before hitting enter. We'll show you how to be faster in a second"
      press_any_key_to_continue
      break


   elif [[ $input == cd* ]]
   then
      cd ~/.fig
      print_special "${BOLD}Awesome!${NORMAL}"
      print_special "Looks like you cd'd into another directory. Glad you are playing around! We are going to put you in ~/.fig for the next step"
      press_any_key_to_continue
      break
   elif [[ $input == '' ]]
   then
      print_special "Type ${BOLD}cd .fig/${NORMAL} to continue"
      print_special "You can hit enter if you see the ${BOLD}↪${NORMAL} symbol"
   elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
   then 
      show_help
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
      Note: The up arrow will make Fig disappear until you start a new line

EOF
press_any_key_to_continue
clear 

# cat <<EOF

#    ${BOLD}Cool Stuff${NORMAL}

<<<<<<< HEAD
   Certain autocomplete suggestions insert extra characters and move your cursor for you. 
   
   Run ${BOLD}git commit -m 'hello'${NORMAL} to continue.

   (Don't worry, this will ${BOLD}not${NORMAL} actually run the git command)
=======
#    Try selecting the ${BOLD}-m${NORMAL} option in ${BOLD}git commit -m${NORMAL} to see how Fig moves your cursor around.

#    Run the git command to continue (don't worry, we won't actually run the command)
>>>>>>> 43537f0df52e97da04d2189e112340ff81f4030f

# EOF



# while true; do
#    input=""
#    read -e -p "${TAB}$ " input
#    echo # New line after output
#    if [[ $input == "git commit"* ]]
#    then
#       print_special "${BOLD}Nice work!${NORMAL}"
#       press_any_key_to_continue
#       break
   
#    elif [[ $input == 'continue' ]]
#    then
#       break
#    elif [[ $input == '' ]]
#    then
#       print_special "Try running ${BOLD}git commit -m 'hi'${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
#    elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
#    then 
#       show_help
#    else
#       print_special "${YELLOW}Whoops. Looks like you tried something other than git."
#       print_special "Try running ${BOLD}git commit -m 'hi'${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
#    fi
# done


# clear 




# cat <<EOF
   
#    ${BOLD}More Cool Stuff${NORMAL}
   
#    You may see the ${BOLD}↪${NORMAL} suggestion when navigating files and folders.

#    This runs whatever is already inserted in your Terminal and closes the autocomplete window.   

# EOF


# press_any_key_to_continue


clear

cat <<EOF
   
   ${BOLD}Last Step: The ${MAGENTA}Fig${NORMAL} ${BOLD}CLI${NORMAL}

   fig invite        invite new users to Fig (you have 5 total invites)
   fig feedback      send feedback directly to the Fig founders
   fig update        update Fig's autocomplete scripts
   fig --help        a summary of Fig commands with examples


   You can type ${MAGENTA}${BOLD}fig${NORMAL} then space to see the full list + descriptions

<<<<<<< HEAD

   If you invite new users, ${BOLD}try it now${NORMAL}. Otherwise type ${UNDERLINE}continue${NORMAL} to continue.
=======
   ${BOLD}To Continue...${NORMAL} 
   Run a fig command, like ${MAGENTA}${BOLD}fig invite${NORMAL} or ${MAGENTA}${BOLD}fig feedback${NORMAL}
   (You can also type ${UNDERLINE}continue${NORMAL})
>>>>>>> 43537f0df52e97da04d2189e112340ff81f4030f

EOF
# Eventually prompt the user: do you want to invite friends to fig? type y if yes or otherwise it's a no
# Only run the below if yes


while true; do
   input=""
   read -e -p "${TAB}$ " input
   echo # New line after output
   if [[ $input == "fig feedback"* ]]
   then
      eval $input
      print_special "${BOLD}Thanks${NORMAL} so much for your feedback :)"
      press_any_key_to_continue
      break

   elif [[ $input == "fig invite"* ]]
   then
      eval $input
      print_special "${BOLD}Your friends just got invited!${NORMAL}"
      press_any_key_to_continue
      break
   
   elif [[ $input == fig* ]]
   then
      eval $input
      print_special "${BOLD}Glad you like Fig!${NORMAL}"
      press_any_key_to_continue
      break
   

   elif [[ $input == 'continue' ]]
   then
      break
   elif [[ $input == '' ]]
   then
      print_special "Try a fig cli command like fig feedback or fig invite to continue. Otherwise, just type ${BOLD}continue"
   elif [[ $input  == 'help' ]] || [[ $input  == 'HELP' ]] || [[ $input  == '--help' ]] || [[ $input  == '-h' ]]
   then 
      show_help
   else
      print_special "${YELLOW}Whoops. Looks like you tried something other than a Fig command."
      print_special "Try a ${BOLD}fig${NORMAL} cli command like ${BOLD}fig feedback${NORMAL} or ${BOLD}fig invite${NORMAL} to continue. Otherwise, just type ${BOLD}continue"
   fi
done


clear 



cat <<EOF

   Wrap Up

   ${BOLD}Want to contribute${NORMAL}?
   * Check out our docs: ${UNDERLINE}https://docs.withfig.com${UNDERLINE_END}
   * Submit a pull request ${UNDERLINE}https://github.com/withfig/autocomplete${UNDERLINE_END}

   ${BOLD}Get in touch:${NORMAL}
   * ${UNDERLINE}hello@withfig.com${UNDERLINE_END}
   * Or ${MAGENTA}${BOLD}fig feedback${NORMAL}

   ${UNDERLINE}Hint${UNDERLINE_END}: Hold cmd + double-click to open URLs)


EOF



    
echo # new line
read -n 1 -s -r -p "${TAB}${HIGHLIGHT} Press any key to finish ${HIGHLIGHT_END}"
echo # new line
echo # new line


defaults write com.mschrage.fig onboarding -bool true


clear

# Done using http://patorjk.com/software/taag/#p=testall&f=Graffiti&t=fig
# Font name = Ivrit
cat <<'EOF'
                              We hope you enjoy

          _____                    _____                    _____          
         /\    \                  /\    \                  /\    \         
        /::\    \                /::\    \                /::\    \        
       /::::\    \               \:::\    \              /::::\    \       
      /::::::\    \               \:::\    \            /::::::\    \      
     /:::/\:::\    \               \:::\    \          /:::/\:::\    \     
    /:::/__\:::\    \               \:::\    \        /:::/  \:::\    \    
   /::::\   \:::\    \              /::::\    \      /:::/    \:::\    \   
  /::::::\   \:::\    \    ____    /::::::\    \    /:::/    / \:::\    \  
 /:::/\:::\   \:::\    \  /\   \  /:::/\:::\    \  /:::/    /   \:::\ ___\ 
/:::/  \:::\   \:::\____\/::\   \/:::/  \:::\____\/:::/____/  ___\:::|    |
\::/    \:::\   \::/    /\:::\  /:::/    \::/    /\:::\    \ /\  /:::|____|
 \/____/ \:::\   \/____/  \:::\/:::/    / \/____/  \:::\    /::\ \::/    / 
          \:::\    \       \::::::/    /            \:::\   \:::\ \/____/  
           \:::\____\       \::::/____/              \:::\   \:::\____\    
            \::/    /        \:::\    \               \:::\  /:::/    /    
             \/____/          \:::\    \               \:::\/:::/    /     
                               \:::\    \               \::::::/    /      
                                \:::\____\               \::::/    /       
                                 \::/    /                \::/____/        
                                  \/____/                                  
                                                                           

EOF
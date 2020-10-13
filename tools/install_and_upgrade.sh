#!/usr/bin/env bash

# This is the fig installation script. It runs just after you sign in for the first time

# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"


# Don't do set -e for the moment. There may be errors with the git clone stuff
# set -e


FIGREPO='https://github.com/withfig/fig.git'

## Checks whether a command exists (like git)
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

error() {
    echo "Error: $@" >&2
	exit 1
}


# Install fig. Override if already exists
install_fig() {

	# Create fig dir an cd into it
    mkdir -p ~/.fig
	cd ~/.fig

	# Initialise git repo. Doesn't matter if git repo already exists
    git init

    # Create remote for origin if it doesn't already exist
    git remote set-url origin $FIGREPO || git remote add origin $FIGREPO


	# Pull down changes from submodules 
	# This will override any changes you have made to fig. 
	# We may move to autostash and rebase (like line 50 or so in oh-my-zsh upgrade script) but not for the moment
	# This is like a try catch block
    { 
    	git submodule update --init --recursive &&
		git pull origin main --recurse-submodules --jobs=10 &&
		git reset --hard origin/main 
	} || {
		error "git pull failed"
	}

	# Make files and folders that the user can edit (that aren't overridden by above)
    mkdir -p ~/.fig/personal/aliases
    mkdir -p ~/.fig/personal/apps
    mkdir -p ~/.fig/personal/autocomplete
    mkdir -p ~/.fig/personal/aliases

    touch ~/.fig/personal/aliases/_myaliases.sh

    # Figpath definitions
    touch ~/.fig/personal/figpath.sh
    FIG_FIGPATH='export FIGPATH="~/.fig/bin:~/run:"'

    # Define the figpath variable in te figpath file
    # The file should look like this:
    #   export FIGPATH="~/.fig/bin:~/run:"
    #   FIGPATH=$FIGPATH'~/abc/de fg/hi''~/zyx/wvut'

    grep -q -e $FIG_FIGPATH ~/.fig/personal/figpath.sh || echo "$FIG_FIGPATH\n$(cat ~/.fig/personal/figpath.sh)" > ~/.fig/personal/figpath.sh
    grep -q -e 'FIGPATH=$FIGPATH' ~/.fig/personal/figpath.sh || echo 'FIGPATH=$FIGPATH' >> ~/.fig/personal/figpath.sh

}


# Add the fig.sh to your profiles so it can be sourced on new terminal window load
append_to_profiles() {

    OLDSOURCEVAR='[ -s ~/.fig/exports/env.sh ] && source ~/.fig/exports/env.sh'
    FIG_SOURCEVAR='[ -s ~/.fig/fig.sh ] && source ~/.fig/fig,sh'
    FIG_FULLSOURCEVAR="\n\n#### FIG ENV VARIABLES ####\n$FIG_SOURCEVAR\n#### END FIG ENV VARIABLES ####\n\n"

    # Replace old sourcing in profiles 
    [ -e ~/.profile ] && sed -i '' 's/~\/.fig\/exports\/env.sh/~\/.fig\/fig.sh/g' ~/.profile
    [ -e ~/.zprofile ] && sed -i '' 's/~\/.fig\/exports\/env.sh/~\/.fig\/fig.sh/g' ~/.zprofile
    [ -e ~/.bash_profile ] && sed -i '' 's/~\/.fig\/exports\/env.sh/~\/.fig\/fig.sh/g' ~/.bash_profile

    # Check that new sourcing exists. If it doesn't, add it
    grep -q -e $FIG_SOURCEVAR ~/.profile || echo $FIG_FULLSOURCEVAR >> ~/.profile
    grep -q -e $FIG_SOURCEVAR ~/.zprofile || echo $FIG_FULLSOURCEVAR >> ~/.zprofile
    grep -q -e $FIG_SOURCEVAR ~/.bash_profile || echo $FIG_FULLSOURCEVAR >> ~/.bash_profile
}

setup_welcome() {
    mkdir -p ~/run/;

    # Note: this gives 3 seconds to the curl request otherwise it just continues
    [ -s ~/run/welcome.run ] || curl https://app.withfig.com/welcome/welcome.run --output ~/run/welcome.run --silent --max-time 3 || true
}


main() {

    command_exists git || {
        error "git is not installed"
    }

    install_fig
    append_to_profiles
    setup_welcome

    echo success
    exit 0

}

main

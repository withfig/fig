#!/usr/bin/env bash

# This is the fig installation script. It runs just after you sign in for the first time

# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/withfig/fig/master/tools/install_and_upgrade.sh)"




FIGREPO='https://github.com/withfig/fig.git'

# We are constantly pushing changes to the public repo
# Each version of the swift app is only compatible with a certain version of the public repo
# The commit hash is passed in as a parameter to this script
# We hard reset to this commit hash
# If we don't get a hash, we just hard reset to the most recent version of the repo...
FIG_COMMITHASH="origin/main"
[  -z "$1" ] || FIG_COMMITHASH=$1


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


	# Pull down most up to date version of Fig
	# This will override any changes you have made to fig. 
    git fetch --all || error "git fetch failed"
    git reset --hard FIG_COMMITHASH || error "git reset failed"


    mkdir -p ~/.fig/autocomplete;
    cd ~/.fig/autocomplete

    {
        curl https://codeload.github.com/withfig/autocomplete/tar.gz/master | \
        tar -xz --strip=2 autocomplete-master/specs
    } || {
        error "pulling latest autocomplete files failed"
    }


	# Make files and folders that the user can edit (that aren't overridden by above)
    mkdir -p ~/.fig/user/aliases
    mkdir -p ~/.fig/user/apps
    mkdir -p ~/.fig/user/autocomplete
    mkdir -p ~/.fig/user/aliases

    touch ~/.fig/user/aliases/_myaliases.sh

    # Figpath definition
    touch ~/.fig/user/figpath.sh
    FIG_FIGPATH='export FIGPATH="~/.fig/bin:~/run:"'

    # Define the figpath variable in the figpath file
    # The file should look like this:
    #   export FIGPATH="~/.fig/bin:~/run:"
    #   FIGPATH=$FIGPATH'~/abc/de fg/hi''~/zyx/wvut'

    grep -q -e $FIG_FIGPATH ~/.fig/user/figpath.sh || echo "$FIG_FIGPATH\n$(cat ~/.fig/user/figpath.sh)" > ~/.fig/user/figpath.sh
    grep -q -e 'FIGPATH=$FIGPATH' ~/.fig/user/figpath.sh || echo 'FIGPATH=$FIGPATH' >> ~/.fig/user/figpath.sh

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

    command_exists git || error "git is not installed"

    install_fig
    append_to_profiles
    setup_welcome

    echo success
    exit 0

}

main

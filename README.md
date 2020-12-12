# Config Directory (~/.fig/)
Yes, the name **fig** comes from con**fig**uration



Fig's configuration files are located in the  `~/.fig` directory.



The config directory is structured like so:


<table>
<tr>
    <td>autocomplete/</td>
    <td>autocomplete completion specs. See <a href="https://github.com/withfig/autocomplete"> withfig/autocomplete</a></td>
</tr>
<tr>
    <td>apps/</td>
    <td>installed Fig apps. See <a href="https://github.com/withfig/autocomplete"> withfig/fig-apps</a> </td>
</tr>
<tr>
    <td>team/</td>
    <td>reserved for team apps, runbooks, and completion specs. Not tracked by git</td>
</tr>
<tr>
    <td>tools/</td>
    <td>config scripts e.g. installation, onboarding, uninstallation...</td>
</tr>
<tr>
    <td>user/</td>
    <td>reserved for individual user apps, runbooks, and completion specs. Not tracked by git</td>
</tr>
<tr>
    <td>fig.sh</td>
    <td>establishes Fig's shell and env variables. This file is sourced on every new shell session. See below</td>
</tr>
</table>



# The fig.sh script

Fig sources the `fig.sh script` by adding the following line of code to your `.bashrc`, `.zshrc`, `.zprofile`, `.profile`, and `.bash_profile`

```bash
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
```



Why do we source `fig.sh` in so many dotfiles? In order to get context on your Terminal (e.g. current working directory), we need to source Fig for each new *shell* session, not just *Terminal* session. e.g. if you open a new terminal, and switch between bash and zsh shells.


### fig.sh sourcing time

Sourcing `fig.sh`  takes around **9ms**. We use conditionals to make sure the script is only run once . If you haven't started a new shell session in a while, it could take up to 200ms. But afterwards will go back to 9ms.


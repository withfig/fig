<p align="center">
    <img width="300" src="static/FigBanner.png#gh-light-mode-only"/>
    <img width="300" src="static/FigBannerInverted.png#gh-dark-mode-only"/>
</p>

---

# 🐛 Known Issues
This is a list of issues with Fig that for one reason or another cannot be resolved upstream.

### `vim`

| Issue # |  Description |
| --- |  --- |
| | `set ttimeoutlen=0` in `vimrc` results in strange output when scrolling with the mouse |


**Workaround**: remove this line or increase the timeout value.

### `vim-tmux-navigator`

| Issue # |  Description |
| --- |  --- |
| [#460](https://github.com/withfig/fig/issues/460) |  Unable to navigate between panes using `vim-tmux-navigator`|


**Workaround**:
> I found some time to wrestle with tmux's string escaping -- here is a more concise solution that is a drop in for the `is_vim` variable that robustly accounts for subshells. Rather than making the bash script listed above, you can replace the `is_vim` function with the following directly:
> 
> ```
> is_vim="children=(); i=0; pids=( $(ps -o pid= -t '#{pane_tty}') ); \
> while read -r c p; do [[ -n c && c -ne p && p -ne 0 ]] && children[p]+=\" $\{c\}\"; done <<< \"$(ps -Ao pid=,ppid=)\"; \
> while (( $\{#pids[@]\} > i )); do pid=$\{pids[i++]\}; pids+=( $\{children[pid]-\} ); done; \
> ps -o state=,comm= -p \"$\{pids[@]\}\" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
> ```
> 
> It does the same thing as the shell script above - a quick explanation line by line:
> 
> 1. Initialize a list, `pids`, of processes running in the current `pane_tty`
> 2. Construct a tree, `children`, that maps parent to child pids
> 3. Loop through descendents of `pids` running in `pane_tty` (some of which may be running in descendant ttys)
> 4. Apply normal `is_vim` function across all descendant processes + ttys
> 
> For those using this workaround, I'm hoping this approach is more easily adaptable to future updates to the `vim-tmux-navigator` logic if support for nested ttys is not merged upstream here. For example, if you are encountering the freezing described in #299, this approach can be modified in a similar way as #300 to not use the `-t` flag of `ps` in line 1:
> 
> ```
> is_vim="children=(); i=0; pids=( $(ps -o pid=,tty= | grep -iE '#{s|/dev/||:pane_tty}' | awk '\{print $1\}') ); \
> while read -r c p; do [[ -n c && c -ne p && p -ne 0 ]] && children[p]+=\" $\{c\}\"; done <<< \"$(ps -Ao pid=,ppid=)\"; \
> while (( $\{#pids[@]\} > i )); do pid=$\{pids[i++]\}; pids+=( $\{children[pid]-\} ); done; \
> ps -o state=,comm= -p \"$\{pids[@]\}\" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
> ```
> via https://github.com/christoomey/vim-tmux-navigator/issues/295




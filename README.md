# Kubetail

Bash script that enables you to aggregate (tail/follow) logs from multiple pods into one stream.
This is the same as running "kubectl logs -f <pod>" but for multiple pods.

## Installation

Just download the [kubetail](https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail) file (or any of the [releases](https://github.com/johanhaleby/kubetail/releases)) and you're good to go.

### Homebrew

You can also install kubetail using [brew](https://brew.sh/):

	$ brew tap johanhaleby/kubetail && brew install kubetail

It's also possible to install kubetail abbreviated to `kt` by using the `--with-short-names` suffix:

	$ brew tap johanhaleby/kubetail && brew install kubetail --with-short-names

Note that you may need to run `compinit` for zsh to pick-up the changes in competition after having upgraded from the non abbreviated installation.

Use `brew install --HEAD kubetail` to install the latest (unreleased) version.

### ASDF

You can install kubetail using the [asdf](https://github.com/asdf-vm/asdf) version manager.

```
asdf plugin-add kubetail https://github.com/janpieper/asdf-kubetail.git
asdf install kubetail <version>
```

To find out the available versions to install, you can run the following command:

```
asdf list-all kubetail
```

### ZSH plugin

If you're using a ZSH plugin manager, you can install `kubetail` as a plugin.

#### Antigen

If you're using [Antigen](https://github.com/zsh-users/antigen):

1. Add `antigen bundle johanhaleby/kubetail` to your `.zshrc` where you've listed your other plugins.
2. Close and reopen your Terminal/iTerm window to **refresh context** and use the plugin. Alternatively, you can run `antigen bundle johanhaleby/kubetail` in a running shell to have `antigen` load the new plugin.

#### oh-my-zsh

If you're using [oh-my-zsh](github.com/robbyrussell/oh-my-zsh):

1. In the command line, change to _oh-my-zsh_'s custom plugin directory :

    `cd ~/.oh-my-zsh/custom/plugins/`

2. Clone the repository into a new `kubetail` directory:

    `git clone https://github.com/johanhaleby/kubetail.git kubetail`

3. Edit your `~/.zshrc` and add `kubetail` – same as clone directory – to the list of plugins to enable:

    `plugins=( ... kubetail )`

4. Then, restart your terminal application to **refresh context** and use the plugin. Alternatively, you can source your current shell configuration:

    `source ~/.zshrc`

#### zgen

If you're using [zgen](https://github.com/tarjoilija/zgen):

1. Add `zgen load johanhaleby/kubetail` to your `.zshrc` along with your other `zgen load` commands.
2. `zgen reset && zgen save`

### Completion

The easiest option is to install kubetail from homebrew to dynamically display the pods names on `$ kubetail <tab>`. Alternatively install any of the [completion scripts](completion/) (bash/zsh/fish) manually. For example:
* On Ubuntu, download the [kubetail.bash](https://raw.githubusercontent.com/johanhaleby/kubetail/master/completion/kubetail.bash) script and execute it in your `~/.bash_completion` file `source $HOME/kubetail/completion/kubetail.bash`. 
* On Mac with zsh copy the [kubetail.zsh](https://raw.githubusercontent.com/johanhaleby/kubetail/master/completion/kubetail.zsh) script to `/usr/local/share/zsh/site-functions/_kubetail`.
* On Mac with fish copy the [kubetail.fish](https://raw.githubusercontent.com/johanhaleby/kubetail/master/completion/kubetail.fish) script to `~/.config/fish/completions/`.

Don't forget to restart your terminal afterwards.

## Usage

First find the names of all your pods:

	$ kubectl get pods

This will return a list looking something like this:

```bash
NAME                   READY     STATUS    RESTARTS   AGE
app1-v1-aba8y          1/1       Running   0          1d
app1-v1-gc4st          1/1       Running   0          1d
app1-v1-m8acl  	       1/1       Running   0          6d
app1-v1-s20d0  	       1/1       Running   0          1d
app2-v31-9pbpn         1/1       Running   0          1d
app2-v31-q74wg         1/1       Running   0          1d
my-demo-v5-0fa8o       1/1       Running   0          3h
my-demo-v5-yhren       1/1       Running   0          2h
```

To tail the logs of the two "app2" pods in one go simply do:

	$ kubetail app2

To tail only a specific container from multiple pods specify the container like this:

	$ kubetail app2 -c container1

You can repeat `-c` to tail multiple specific containers:

	$ kubetail app2 -c container1 -c container2

To tail multiple applications at the same time seperate them by comma:

	$ kubetail app1,app2

For advanced matching you can use regular expressions:

	$ kubetail "^app1|.*my-demo.*" --regex
	
To tail logs within a specific namespace, make sure to append the namespace flag *after* you have provided values for containers and applications:

	$ kubetail app2 -c container1 -n namespace1

Supply `-h` for help and additional options:

	$ kubetail -h

## Colors

By using the `-k` argument you can specify how kubetail makes use of colors (only applicable when tailing multiple pods).

| Value   |     Description  |
|----------|---------------|
| pod | Only the pod name is colorized but the logged text is using the terminal default color |
| line | The entire line is colorized (default) |
| false | Don't colorize the output at all |
   
Example:

	$ kubetail app2 -k false

If you find that some colors are difficult to see then they can be skipped by supplying the color index either to the `-z` flag or by setting the `KUBETAIL_SKIP_COLORS` environment variable (either choice could be comma seperated). To find the color index you'd like to skip more easily, set the `-i` flag to `true` (`-i true`) or set the `KUBETAIL_SHOW_COLOR_INDEX` environment variable to `true` (`KUBETAIL_SHOW_COLOR_INDEX=true`). This will print the color index as a prefix to the pod name (e.g. `[3:my-pod-12341] some log` where `3` is the index of the color). This is also helpful if you suffer from color blindness since the index will always be printed with the default terminal color.
	
## Filtering / Highlighting etc

kubetail itself doesn't have filtering or highlighting capabilities built-in. If you're on MacOSX I recommend using [iTerm2](https://www.iterm2.com/) which allows for continuous highlighting of search terms, good scrolling capabilities and multitab arrangements. Another useful feature of iTerm2 is the "timeline" (`cmd` + `shift` + `e`) which lets you display a timeline in your own local timezone next to the logs (that are typically in UTC). 

If you're not using iTerm2 or think that kubetail is lacking in features there's a [fork](https://github.com/aks/kubetail) of kubetail made by [Alan Stebbens](https://github.com/aks) that allows for richer configuration and uses [multitail](https://www.vanheusden.com/multitail/) and [bash-lib](https://github.com/aks/bash-lib). Alan has been kind enough to provide a pull request but my current thinking is that I'd like kubetail to stay simple and small and not use any dependencies.

## Environment

kubetail can take default option values from environment variables matching the option name.

    KUBETAIL_SINCE
    KUBETAIL_NAMESPACE
    KUBETAIL_LINE_BUFFERED
    KUBETAIL_COLORED_OUTPUT
    KUBETAIL_TIMESTAMPS
    KUBETAIL_JQ_SELECTOR
    KUBETAIL_SKIP_COLORS
    KUBETAIL_TAIL
    KUBETAIL_SHOW_COLOR_INDEX

## More

Pull requests are very welcome!

See also: http://code.haleby.se/2015/11/13/tail-logs-from-multiple-pods-simultaneously-in-kubernetes/

<a href="https://www.buymeacoffee.com/johanhaleby" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/arial-blue.png" alt="Buy Me A Coffee" style="height: 42px !important;width: 180px !important;" height="42px" width="180px"></a>

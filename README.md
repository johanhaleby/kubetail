# Kubetail

Bash script that enables you to aggregate (tail/follow) logs from multiple pods
into one stream.  This is the same as running "kubectl logs -f <pod>" but for
multiple pods.

If available, this script will use `multitail`, an interactive, curses-based
multi-pane log viewer, or it can manage the log viewing with a simple bash
function.  Using `multitail`, each pod name can be automatically associated
with a corresponding _colorscheme_ (using the pod "base" name) that controls
the precise formatting and coloring of the viewed log files.

See the included `multitail` configuration file `kube-multitail.conf`.

## Installation

Use `make` to install into reasonably standard places; edit the `Makefile` to
adjust to your needs.

    make install

This will install the `kubetail` script and the `kube-multitail.conf` file, by
default into `$HOME/bin/kubetail` and `$HOME/etc/kube-multitail.conf`,
respectively.

## Usage

To find the names of all your pods:

    $ kubectl get pods

This will return a list looking something like this:

```bash
NAME                   READY     STATUS    RESTARTS   AGE
app1-v1-aba8y          1/1       Running   0          1d
app1-v1-gc4st          1/1       Running   0          1d
app1-v1-m8acl  		   1/1       Running   0          6d
app1-v1-s20d0  		   1/1       Running   0          1d
app2-v31-9pbpn         1/1       Running   0          1d
app2-v31-q74wg         1/1       Running   0          1d
my-demo-v5-0fa8o       1/1       Running   0          3h
my-demo-v5-yhren       1/1       Running   0          2h
```

To tail the logs of the two "app2" pods in one go simply do:

    $ kubetail app2

If the pods are using multiple containers specify the container like this:

    $ kubetail app2 -c container1

Supply `-h` for help and addtional options:

    $ kubetail -h

To see what commands are being generated to tail the logs, use the `-v` option:

    $ kubetail -v myapp

To see what commands _would_ be generated and used, without actually invoking 
them, use the `-N` option:

    $ kubetail -N myapp

To avoid using `multitail`, use the `-T` option:

    $ multitail -T myapp

## Colors

By using the `-k` argument you can specifiy how kubetail makes use of colors.

| Value   |     Description  |
|----------|---------------|
| pod | Only the pod name is colorized but the logged text is using the terminal default color |
| line | The entire line is colorized (default) |
| false | Don't colorize the output at all |
   
Example:

	$ kubetail app2 -k false
	
	
## Filtering / Highlighting etc

kubetail itself doesn't have filitering or highlighting capabilities built-in. I recommend using [iTerm2](https://www.iterm2.com/) which allows for continious highlighting of search terms, good scrolling capabilities and multitab arrangements. Another useful feature of iTerm2 is the "timeline" (`cmd` + `shift` + `e`) which lets you display a timeline in your own local timezone next to the logs (that are typically in UTC). 

If you're not using iTerm2 or think that kubetail is lacking in features there's a [fork](https://github.com/aks/kubetail) of kubetail made by [Alan Stebbens](https://github.com/aks) that allows for richer configuration and the use of [multitail](https://www.vanheusden.com/multitail/) and [bash-lab](https://github.com/aks/bash-lib). Alan has been kind enough to provide a pull request but my current thinking is that I'd like kubetail to stay simple and small and not use any dependencies.

## Known issues

When you press "ctrl+c" to end the log session you may end up with errors like this:

```bash
error: write /dev/stdout: broken pipe
```

I'm not quite sure why this happens, pull requests are welcome :)

See also: http://code.haleby.se/2015/11/13/tail-logs-from-multiple-pods-simultaneously-in-kubernetes/

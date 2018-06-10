# Kubetail

Bash script that enables you to aggregate (tail/follow) logs from multiple pods into one stream.
This is the same as running "kubectl logs -f <pod>" but for multiple pods.

## Installation

Just download the [kubetail](https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail) file (or any of the [releases](https://github.com/johanhaleby/kubetail/releases)) and you're good to go.

### Homebrew

You can also install kubetail using [brew](https://brew.sh/):

	$ brew tap johanhaleby/kubetail && brew install kubetail

Use `brew install --HEAD kubetail` to install the latest (unreleased) version.

### Completion

Install the script using homebrew to dynamically display the pods names. Alternatively install the [completion script](completion/) (bash/zsh/fish) manually. For Ubuntu, copy the scripts to `/etc/bash_completion.d/` and restart your terminal). For zsh on Mac copy the script to `/usr/local/share/zsh/site-functions/_kubetail`.

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

## More

Pull requests are very welcome!

See also: http://code.haleby.se/2015/11/13/tail-logs-from-multiple-pods-simultaneously-in-kubernetes/

# Kubetail

A bash script that enables you to aggregate (tail/follow) logs from multiple
pods into one stream.  This is the same as running "kubectl logs -f <pod>" but
for multiple pods.

If available, this script will use `multitail`, an interactive, curses-based
multi-pane log viewer, or it can manage the log viewing with a simple bash
function.  Using `multitail`, each pod name can be automatically associated
with a corresponding _colorscheme_ (using the pod "base" name) that controls
the precise formatting and coloring of the viewed log files.

See the included `multitail` configuration file `kube-multitail.conf`.

## Installation

Use `make` to install into reasonably standard places.  There are two targets:

    make install-home
    make install-usr

Both will install the `kubetail` script, the `kube-multitail.conf`
configuration file, and the man page `kubetail.man` into the corresponding
sub-directories: `bin`, `etc`, and `man`, with the directory root being either:
`~` or `/usr/local`.

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

## Known issues

When you press "ctrl+c" to end the log session you may end up with errors like this:

```bash
error: write /dev/stdout: broken pipe
```

This error is normal; it is the result of output pending from one or more log files
being unread by the interrupted script.

See also: http://code.haleby.se/2015/11/13/tail-logs-from-multiple-pods-simultaneously-in-kubernetes/

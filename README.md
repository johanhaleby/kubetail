# Kubetail

Bash script that enables you to aggregate (tail/follow) logs from multiple pods into one stream.
This is the same as running "kubectl logs -f <pod>" but for multiple pods.

## Usage

First find the names of all your pods:

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

## Known issues

When you press "ctrl+c" to end the log session you may end up with errors like this:

```bash
error: write /dev/stdout: broken pipe
```

I'm not quite sure why this happens, pull requests are welcome :)

See also: http://code.haleby.se/2015/11/13/tail-logs-from-multiple-pods-simultaneously-in-kubernetes/

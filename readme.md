## Matrix homeserver + irc bridge

### Homeserver
The homeserver is a synapse docker image pulled from silviof/docker-matrix
Configuration and runtime files go in the /data volume which is shared with the host.
See [silvio/docker-matrix]( https://github.com/silvio/docker-matrix) and [synapse](https://github.com/matrix-org/synapse)
for configuration.

### Irc bridge
The irc bridge is [matrix-appservice-irc](https://github.com/matrix-org/matrix-appservice-irc).
Configuration and runtime files go in `/data/irc`.
Once the image is build the registration file can be generated with
```
  docker run --rm -v /data:/data matrix-appservice-irc register
```

### Start

```
  docker compose -d up
```

By default only the synapse service port 8448 is exposed to the outside.

# docker-rsyncd

A minimalist image with rsync daemon. The intention is to run a rsync daemon on host with docker without the need of rsyncd setup (e.g. running on a NAS).

The benefit compare to transfer over SSH is the SPEED (avoid SSH overhead). From my testing can be at least 2x faster!

## Docker Hub

This has been published to [windix/docker-rsyncd](https://hub.docker.com/r/windix/docker-rsyncd) on docker-hub.

## Usage

The simplest use case:

On server side, start rsyncd for current directory and map its 873 port (default rsyncd port):

```bash
$ docker run -p 873:873 -v $(pwd):/volume windix/docker-rsyncd

```

On client side, to transfer files over the native rsync protocol:

```bash
$ rsync -av --progress <file-or-directory> rsync://<docker-host-ip>:873/volume

```

## Configuration

To map with your host UID and GID to avoid permission issues, you can pass `UID` and `GID` environment variables correspondingly (default value is `1000` for both).

Also you can specify `ALLOW` for IP whitelist (default is `127.0.0.1 192.168.0.0/16 10.0.0.0/16`)

Here is a more complicated example:

```bash
$ docker run -p 873:873 -e VOLUME=/incoming -e UID=1000 -e GID=100 -e ALLOW="127.0.0.1 192.168.0.0/16 10.0.0.0/16" -v /mnt/user/incoming:/incoming windix/docker-rsyncd

```

## Thanks

This is based on original work from <https://github.com/stefda/docker-rsync>

<p align="center">
<a href="https://hub.docker.com/r/deercloud/shadowsocks">
<img src="https://user-images.githubusercontent.com/2666735/50723896-0b22d000-111f-11e9-9ee4-32914e347219.png" />
</a>
</p>

<h1 align="center">shadowsocks</h1>

<p align="center">a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.</p>

<p align=center>
<a href="https://hub.docker.com/r/deercloud/shadowsocks">Docker Hub</a> ·
<a href="https://github.com/shadowsocks/shadowsocks-libev">Project Source</a> ·
<a href="https://t.me/linuxUpdate">Telegram Channel</a>
</p>

***

## latest version

|version|
|---|
|deercloud/shadowsocks:latest|
|deercloud/shadowsocks:current|
|deercloud/shadowsocks:3.3.1|


## environment variables

|name|value|
|---|---|
|SERVER_ADDR|0.0.0.0|
|SERVER_PORT|8388|
|**PASSWORD**|[RANDOM]|
|**METHOD**|aes-256-gcm|
|TIMEOUT|300|
|**DNS**|8.8.8.8,8.8.4.4|
|**OBFS**|-|
|PLUGIN|-|
|PLUGIN_OBFS|-|
|ARGS|-|

***

### Pull the image

```bash
$ docker pull deercloud/shadowsocks
```

### Start a container

```bash
$ docker run -p 8388:8388 -p 8388:8388/udp -d \
  --restart always --name=shadowsocks deercloud/shadowsocks
```

### Display shadowsocks link

```bash
$ docker logs shadowsocks

Generating random password: 95c26ad46fe73dd873f97ce1e29b8b4c

  server address: 101.6.6.6
  method: aes-256-gcm
  password: 95c26ad46fe73dd873f97ce1e29b8b4c

  ss://YWVzLTI1Ni1nY206OTVjMjZhZDQ2ZmU3M2RkODczZjk3Y2UxZTI5YjhiNGM=@101.6.6.6:8388

  !! replace 8388 to your different port.

ss-server start!
 2019-01-05 11:44:28 INFO: using tcp fast open
 2019-01-05 11:44:28 INFO: UDP relay enabled
 2019-01-05 11:44:28 INFO: initializing ciphers... aes-256-gcm
 2019-01-05 11:44:28 INFO: using nameserver: 8.8.8.8,8.8.4.4
 2019-01-05 11:44:28 INFO: tcp server listening at 0.0.0.0:8388
 2019-01-05 11:44:28 INFO: tcp port reuse enabled
 2019-01-05 11:44:28 INFO: udp server listening at 0.0.0.0:8388
 2019-01-05 11:44:28 INFO: udp port reuse enabled
 2019-01-05 11:44:28 INFO: running from root user
```

### With simple-obfs

```bash
$ docker run -p 443:8388 -p 443:8388/udp -d \
  -e PASSWORD=deercloud \
  -e METHOD=chacha20-ietf-poly1305 \
  -e OBFS=tls \
  --restart always --name=shadowsocks deercloud/shadowsocks
```

show connection link

```bash
$ docker logs shadowsocks

Using explicitly passed password: deercloud
obfs-server start!
 2019-01-05 11:49:51 [simple-obfs] INFO: obfuscating enabled
 2019-01-05 11:49:51 [simple-obfs] INFO: tcp port reuse enabled
 2019-01-05 11:49:51 [simple-obfs] INFO: listening at 0.0.0.0:8139
 2019-01-05 11:49:51 [simple-obfs] INFO: running from root user

  server address: 101.6.6.6
  method: chacha20-ietf-poly1305
  password: deercloud
  obfs: tls

  ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZWVyY2xvdWQ=@101.6.6.6:8388
  ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZWVyY2xvdWQ=@101.6.6.6:8139/?plugin=obfs-local%3Bobfs%3Dtls

  !! replace 8388 to your different port.

ss-server start!
 2019-01-05 11:49:51 INFO: using tcp fast open
 2019-01-05 11:49:51 INFO: UDP relay enabled
 2019-01-05 11:49:51 INFO: initializing ciphers... chacha20-ietf-poly1305
 2019-01-05 11:49:51 INFO: using nameserver: 8.8.8.8,8.8.4.4
 2019-01-05 11:49:51 INFO: tcp server listening at 0.0.0.0:8388
 2019-01-05 11:49:51 INFO: tcp port reuse enabled
 2019-01-05 11:49:51 INFO: udp server listening at 0.0.0.0:8388
 2019-01-05 11:49:51 INFO: udp port reuse enabled
 2019-01-05 11:49:51 INFO: running from root user
```

 > :warning: change `:8388` to your custom port `:443`.

### With v2ray-plugin

```bash
$ docker run -p 443:8388 -p 443:8388/udp -d \
 -e PASSWORD=deercloud \
 -e METHOD=chacha20-ietf-poly1305 \
 -e OBFS=ws \
 --restart always --name=shadowsocks deercloud/shadowsocks
```

show connection link

```bash
$ docker logs shadowsocks

Using explicitly passed password: deercloud

  server address: 101.6.6.6
  method: chacha20-ietf-poly1305
  password: deercloud
  obfs: ws

  ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZWVyY2xvdWQ=@101.6.6.6:8388
  ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpkZWVyY2xvdWQ=@101.6.6.6:/?plugin=v2ray-plugin%3B

  !! replace 8388 to your different port.

ss-server start!
 2019-01-12 05:40:34 INFO: using tcp fast open
 2019-01-12 05:40:34 INFO: plugin "v2ray-plugin" enabled
 2019-01-12 05:40:34 INFO: UDP relay enabled
 2019-01-12 05:40:34 INFO: initializing ciphers... chacha20-ietf-poly1305
 2019-01-12 05:40:34 INFO: using nameserver: 8.8.8.8,8.8.4.4
 2019-01-12 05:40:34 INFO: tcp server listening at 127.0.0.1:49937
 2019-01-12 05:40:34 INFO: tcp port reuse enabled
 2019-01-12 05:40:34 INFO: udp server listening at 0.0.0.0:8388
 2019-01-12 05:40:34 INFO: udp port reuse enabled
 2019-01-12 05:40:34 INFO: running from root user
2019/01/12 05:40:34 V2Ray 4.12 (Po) Custom
2019/01/12 05:40:34 A unified platform for anti-censorship.
2019/01/12 05:40:34
{
    "inbounds": [{
        "listen": "0.0.0.0",
        "port": 8388,
        "protocol": "dokodemo-door",
        "settings": {
            "address": "v1.mux.cool",
            "network": "tcp"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/",
                "headers": {
                    "Host": "cloudfront.com"
                }
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom",
        "settings": {
            "redirect": "127.0.0.1:49937"
        }
    }]
}

2019/01/12 05:40:34 [Warning] v2ray.com/core: V2Ray 4.12 started
```

> :warning: change `:8388` to your custom port `:443`.

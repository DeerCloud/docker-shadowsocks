<p align="center">
<a href="https://hub.docker.com/r/deercloud/shadowsocks">
<img src="https://user-images.githubusercontent.com/2666735/50723896-0b22d000-111f-11e9-9ee4-32914e347219.png" />
</a>
</p>

<h1 align="center">shadowsocks</h1>

<p align="center">a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes.</p>

<p align=center>
<a href="https://hub.docker.com/r/deercloud/shadowsocks">Docker Hub</a> ·
<a href="https://github.com/shadowsocks/shadowsocks-libev">Project Source</a>
</p>

***

## latest version

|version|
|---|
|deercloud/shadowsocks:latest|


## environment variables

|name|value|
|---|---|
|SERVER_ADDR|0.0.0.0|
|SERVER_PORT|8388|
|**PASSWORD**|[RANDOM]|
|**METHOD**|aes-256-gcm|
|**DNS**|8.8.8.8,8.8.4.4|
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

# docker build

```bash
docker build -t cyberlab_modsec .
docker run --rm -v $(pwd)/mount/rules:/usr/share/modsecurity-crs/rules -p 80:80 -it cyberlab_modsec
```

# pull form docker hub

```bash
docker run --rm -v $(pwd)/mount/rules:/usr/share/modsecurity-crs/rules -p 80:80 -it zet235/cyberlab2022:mod-sec
```

# exec command

```bash
docker exec -it $CONTAINER_ID /bin/bash
```
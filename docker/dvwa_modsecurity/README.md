# docker build

```bash
docker build -t cyberlab_modsec .
docker run --rm -v $(pwd)/mount/rules:/usr/share/modsecurity-crs/rules -p 80:80 -it cyberlab_modsec
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```

# pull form docker hub

```bash
docker run --rm -v $(pwd)/mount/rules:/usr/share/modsecurity-crs/rules -p 80:80 -it zet235/cyberlab2022:mod-sec /bin/bash
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```

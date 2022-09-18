# dokcer build

```bash
docker build -t cyberlab_naxsi .
docker run --rm -p 80:80 -it cyberlab_naxsi /bin/bash
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```

# pull form docker hub

```bash
docker run --rm -p 80:80 -it zet235/cyberlab2022:naxsi /bin/bash
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```


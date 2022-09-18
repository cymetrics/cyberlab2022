# build form local

```bash
docker build -t cyberlab .
docker run --rm -p 80:80 -v $(pwd)/mount:/tmp/mount -it cyberlab
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```

# pull from docker hub

```bash
docker run --rm -p 80:80 -it zet235/cyberlab2022:dvwa
# another terminal
docker exec -it $CONTAINER_ID /bin/bash
./tmp/start.sh
```




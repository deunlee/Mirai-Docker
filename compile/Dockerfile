FROM fedora:35

RUN dnf install -y gcc glibc-static golang ElectricFence mysql mariadb-common bind bind-utils
# git mariadb-server
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y gmp-devel

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
    mv cross-compiler-x86_64  x86_64
ENV PATH="$PATH:/etc/xcompile/armv4l/bin"
ENV PATH="$PATH:/etc/xcompile/armv5l/bin"
ENV PATH="$PATH:/etc/xcompile/armv6l/bin"
ENV PATH="$PATH:/etc/xcompile/i586/bin"
ENV PATH="$PATH:/etc/xcompile/i686/bin"
ENV PATH="$PATH:/etc/xcompile/m68k/bin"
ENV PATH="$PATH:/etc/xcompile/mips/bin"
ENV PATH="$PATH:/etc/xcompile/mipsel/bin"
ENV PATH="$PATH:/etc/xcompile/powerpc/bin"
# ENV PATH="$PATH:/etc/xcompile/powerpc-440fp/bin"
ENV PATH="$PATH:/etc/xcompile/sh4/bin"
ENV PATH="$PATH:/etc/xcompile/sparc/bin"
# ENV PATH="$PATH:/etc/xcompile/x86_64/bin"
ENV PATH="$PATH:/usr/local/go/bin"

RUN useradd -m -s /bin/bash -u 1000 mirai
USER mirai
WORKDIR /home/mirai/src

ENV GOPATH="/home/mirai/go"
RUN mkdir ~/go && \
    go env -w GO111MODULE=auto && \
    go get github.com/go-sql-driver/mysql && \
    go get github.com/mattn/go-shellwords

CMD [ "bash" ]

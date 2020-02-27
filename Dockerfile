FROM inspursoft/baseimage-mips:1.0

ENV GOLANG_VERSION 1.14
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN yum install -y openssh openssh-clients openssh-server \
    && yum install -y gcc \
    && yum install -y wget \
    && yum install -y tar \
    && yum install -y gzip \
    && cd / && mkdir install_tmp && cd install_tmp \
    && wget https://dl.google.com/go/go1.14.src.tar.gz \
    && tar -zxvf go1.14.src.tar.gz \
    && wget http://download.cs2c.com.cn/neokylin/server/releases/7.0/ls_64/Packages/golang-bin-1.9.2-4.ns7_4.01.mips64el.rpm \
    && rpm -ivh golang-bin-1.9.2-4.ns7_4.01.mips64el.rpm --nodeps \
    && yum install -y golang \
    && cd go/src && ./make.bash \
    && yum remove -y golang \
    && cp -r /install_tmp/go /usr/local/ \
    && ln -s /usr/local/go/bin/go  /usr/bin/go \
    && ln -s /usr/local/go/bin/gofmt  /usr/bin/gofmt \
    && rm -rf /install_tmp \
    #  locales
    && rm -rf /usr/{{lib,share}/locale,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    #  docs and man pages
    && rm -rf /usr/share/{man,doc,info,gnome/help} \
    #  cracklib
    && rm -rf /usr/share/cracklib \
    #  i18n
    && rm -rf /usr/share/i18n \
    #  sln
    && rm -rf /sbin/sln \
    && yum clean all && yum makecache

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

CMD ["go", "version"]

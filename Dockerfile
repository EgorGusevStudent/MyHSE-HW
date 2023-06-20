FROM ubuntu:18.10

# Замена стандартных репозиториев Ubuntu на old-releases.ubuntu.com
RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

ENV DEBIAN_FRONTEND=noninteractive

# Установка необходимых зависимостей
RUN apt-get update && apt-get install -y wget perl

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        texlive-latex-base \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        texlive-latex-extra \
        texlive-science \
        ghostscript \
        perl

# Загрузка и установка TeX Live
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && zcat < install-tl-unx.tar.gz | tar xf - \
    && cd install-tl-* \
    && perl ./install-tl --no-interaction --scheme=small --no-doc-install 

# Добавление TeX Live в PATH
ENV PATH="/usr/local/texlive/2023/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Установка пакетов enumitem, paracol, fontawesome, silence, background, everypage
RUN tlmgr install enumitem paracol fontawesome silence background everypage palatino

COPY /CV/main.tex /app/

COPY /CV/resources /app/resources

COPY /CV/bubblecv.sty /app/

WORKDIR /app

RUN pdflatex main.tex

CMD ["cp", "/app/main.pdf", "/output/"]

RUN mkdir /output

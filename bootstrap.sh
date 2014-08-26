#!/bin/bash

#cd to homedir first
cd ~

# Update to latest packages
sudo apt-get update

# Install essentials + a couple useful extras
sudo apt-get -y install \
        autoconf \
        build-essential \
        curl \
        mc \
        apache2 \
        php5-dev \
        php-pear \
        php5-curl \
        xterm \
        openjdk-7-jre-headless \
        git

#wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.0.tar.gz
tar zxvf /vagrant/support/modules/elasticsearch-1.2.0.tar.gz /vagrant/elasticsearch

sudo apt-get install -y python3 libsqlite3-dev sqlite3 bzip2 libbz2-dev
sudo apt-get install -y libxml2 python-dev python-pip python-setuptools yum cython
easy_install lxml

sudo ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite

cd ~
sudo apt-get install -y imagemagick
sudo apt-get install -y git

#ffmpeg related, see: https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
sudo apt-get update
sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev
mkdir ~/ffmpeg_sources
cd ~

#yasm
sudo apt-get remove yasm
cd ~/ffmpeg_sources
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
cd ~

#libx264
cd ~/ffmpeg_sources
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
PATH="$PATH:$HOME/bin" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean
cd ~

#libfdk-aac
cd ~/ffmpeg_sources
wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
cd ~

#libmp3lame
sudo apt-get install -y libmp3lame-dev

#libopus
cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
cd ~

#libvpx
cd ~/ffmpeg_sources
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean
cd ~

#ffmpeg
export TMPDIR=~/tmp-ffmpeg
mkdir $TMPDIR
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$PATH:$HOME/bin" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" \
  --extra-libs="-ldl" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree
make
make install
make distclean
hash -r
rm -rf $TMPDIR
export TMPDIR=
cp ~/bin/* /bin
cp ~/ffmpeg_build/lib/* /lib
cd

#nginx related
sudo apt-get install -y build-essential zlib1g-dev libpcre3 libpcre3-dev
sudo apt-get install -y libc6 libexpat1 libgd2-xpm libgd2-xpm-dev libgeoip1 libgeoip-dev libpam0g libssl1.0.0 libxml2 libxslt1.1 libxslt-dev zlib1g libperl5.14 perl perlapi-5.14.2 openssl
wget http://nginx.org/download/nginx-1.7.1.tar.gz
tar -xvzf nginx-1.7.1.tar.gz
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.7.30.4-beta.zip
unzip release-1.7.30.4-beta.zip
cd ngx_pagespeed-release-1.7.30.4-beta/
wget https://dl.google.com/dl/page-speed/psol/1.7.30.4.tar.gz
tar -xzvf 1.7.30.4.tar.gz # expands to psol/
cd ~/nginx-1.7.1/
./configure --add-module=$HOME/ngx_pagespeed-release-1.7.30.4-beta
./configure --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-http_ssl_module
make
sudo make install

#php related
sudo apt-get install -y php5-fpm
sudo apt-get install -y php5-xcache

./todo.sh



FROM debian:10.3
# start from debian 10.3 and get efault gcc 8.3
RUN echo "deb http://ftp.fr.debian.org/debian/ buster main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ buster main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://ftp.fr.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.fr.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
RUN apt update && apt-get install -y --no-install-recommends apt apt-utils

RUN apt-get install -y --no-install-recommends build-essential gcc g++ pkg-config make automake autoconf
RUN apt-get install -y --no-install-recommends gcc-8 g++-8 pkg-config make automake autoconf
RUN apt-get install -y --no-install-recommends git locales tar gzip parallel unzip zip bzip2 curl wget 
RUN apt-get install -y --no-install-recommends cmake libgtest-dev swig astyle zip unzip
RUN apt-get install -y --no-install-recommends autopoint bison flex gperf libtool ruby scons p7zip-full
RUN apt-get install -y --no-install-recommends intltool libtool libtool-bin nsis zip lzip gnupg libharfbuzz-dev libgdk-pixbuf2.0-dev
RUN apt-get install -y --no-install-recommends python-dev
RUN apt-get install -y default-jre-headless default-jdk-headless  

RUN cat /etc/debian_version
RUN gcc --version && g++ --version && ld --version
RUN java --version

# compile GCC 10.2
WORKDIR /tmp
RUN wget https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz
RUN tar xf gcc-10.2.0.tar.xz && cd gcc-10.2.0 && contrib/download_prerequisites
RUN mkdir build && cd build && ../gcc-10.2.0/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=/usr/local/gcc-10.2.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib --program-suffix=-10.2
RUN cd build && make -j8 && make install-strip
ENV PATH="${PATH}:/usr/local/gcc-10.2.0/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/gcc-10.2.0/lib64"
RUN gcc-10.2 --version && g++ --version

# compile MXE cross-compiler
WORKDIR /
RUN git clone https://github.com/mxe/mxe.git
WORKDIR /mxe
# checkout to the last known working/tested (for me...) commit on date of this Dockerfile i.e:
RUN git checkout 76375b2bccbbf409aaab44d4fc0cbd017c5a00e3

# compile the wanted toolchain ...
RUN make MXE_TARGETS="i686-w64-mingw32.static" qt5

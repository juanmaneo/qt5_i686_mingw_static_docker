FROM debian:10
# start from debian 10 with default gcc 8.3
RUN apt update
RUN apt-get install -y apt apt-utils
RUN apt-get install -y build-essential gcc-8 g++-8
RUN gcc --version
RUN apt-get install -y git locales tar gzip parallel unzip zip bzip2 curl wget make automake autoconf
RUN apt-get install -y cmake libgtest-dev swig astyle zip default-jdk python-dev
RUN apt-get install -y --no-install-recommends autopoint bison flex gperf libtool ruby scons unzip p7zip-full intltool libtool libtool-bin nsis zip lzip gnupg

# compile GCC 10.2
WORKDIR /tmp
RUN wget https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz
RUN tar xf gcc-10.2.0.tar.xz && cd gcc-10.2.0 && contrib/download_prerequisites
RUN mkdir build && cd build && ../gcc-10.2.0/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=/usr/local/gcc-10.2.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib --program-suffix=-10.2
RUN cd build && make -j8 && make install-strip
ENV PATH="${PATH}:/usr/local/gcc-10.2.0/bin"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/gcc-10.2.0/lib64"
RUN gcc-10.2 --version && g++ --version
RUN gcc --version && g++ --version

RUN apt-get install -y --no-install-recommends pkg-config
RUN apt-get install -y --no-install-recommends libharfbuzz-dev

# compile MXE cross-compiler
WORKDIR /
RUN git clone https://github.com/mxe/mxe.git
WORKDIR /mxe
# checkout to the last known working/tested (for me...) commit on date of this Dockerfile i.e:
RUN git checkout 76375b2bccbbf409aaab44d4fc0cbd017c5a00e3

# compile the wanted toolchain ...
RUN make MXE_TARGETS="i686-w64-mingw32.static" qt5


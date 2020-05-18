FROM gcc:9.3

RUN apt update
RUN apt-get install -y apt apt-utils
RUN apt-get install -y git locales tar gzip parallel unzip zip bzip2 curl wget make automake autoconf

WORKDIR /
RUN git clone https://github.com/mxe/mxe.git
WORKDIR /mxe
# checkout to the last known working/tested (for me...) commit on date of this Dockerfile i.e:
RUN git checkout 76375b2bccbbf409aaab44d4fc0cbd017c5a00e3

RUN apt-get install -y --no-install-recommends autopoint bison flex gperf libtool ruby scons unzip p7zip-full intltool libtool libtool-bin nsis zip lzip gnupg

# compile the wanted toolchain ...
RUN make MXE_TARGETS="i686-w64-mingw32.static" qt5
FROM silkeh/clang:11

ENV HALIDE_VERSION 12.0.1

RUN apt-get update \
  && apt-get install -y make g++ libjpeg-dev libpng-dev libz-dev \
     apt-transport-https apt-utils libtinfo-dev libxml2-dev libgl-dev \
     python3-dev python3-numpy python3-scipy python3-imageio python3-pybind11 \
     libopenblas-dev libeigen3-dev libatlas-base-dev \
     doxygen ninja-build \
  && addgroup halide \
  && adduser --ingroup halide --system halide \
  && mkdir -p /root/build/halide_src \
  && mkdir -p /root/build/halide_dist \
  && echo $LD_LIBRARY_PATH \
  && cd /root/build/ \
  && wget -O halide.tar.gz https://github.com/halide/Halide/archive/refs/tags/v${HALIDE_VERSION}.tar.gz \
  && tar -zxf halide.tar.gz -C halide_src --strip-components=1 \
  && cd halide_dist \
  && make distrib -f ../halide_src/Makefile \
  && mv ../halide_src /root/halide \
  && mv distrib /root/halide/distrib \
  && cd /root/halide \
  && cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -S . -B cmake-build-release \
  && cmake --build ./cmake-build-release \
  && cmake --install ./cmake-build-release \
  && rm -rf /roo/build \
  && apt-get clean 

WORKDIR /root


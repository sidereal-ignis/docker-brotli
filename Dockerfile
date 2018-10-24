FROM gcc:8.2

RUN set -ex \
 && apt-get update -qq \
 && apt-get install -y -q cmake \
 && rm -r /var/lib/apt/lists/*

WORKDIR /root

RUN set -ex \
 && git clone -b v1.0.7 --depth 1 https://github.com/google/brotli.git \
 && mkdir -p build \
 && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../brotli \
 && make brotli

FROM gcr.io/distroless/base

COPY --from=0 /root/build/brotli /

ENTRYPOINT [ "/brotli" ]

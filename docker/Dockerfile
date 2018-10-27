#
# stage 1
#

FROM ubuntu:18.04 as builder

RUN apt-get update

RUN apt-get install -y -qq apt-utils

# boost
RUN apt-get install -y -qq libboost-filesystem1.65-dev libboost-filesystem1.65.1 libboost-iostreams1.65-dev libboost-iostreams1.65.1 libboost-locale1.65-dev libboost-locale1.65.1 libboost-regex1.65-dev libboost-regex1.65.1 libboost-serialization1.65-dev libboost-serialization1.65.1 libasio-dev libboost-program-options1.65-dev libboost-program-options1.65.1 libboost-random1.65-dev libboost-random1.65.1 libboost-system1.65-dev libboost-system1.65.1 libboost-thread1.65-dev libboost-thread1.65.1

RUN apt-get install -y -qq bzip2 zlib1g-dev gcc g++ cmake git

# SDL
RUN apt-get install -y -qq libsdl2-dev

RUN git clone --single-branch -b 1.14 https://github.com/wesnoth/wesnoth

RUN cd wesnoth \
        && mkdir build \
        && cd build \
        && cmake .. -DENABLE_GAME=OFF -DENABLE_CAMPAIGN_SERVER=ON -DENABLE_SERVER=ON \
        && make

#
# stage2
#

FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y -qq libboost-filesystem1.65.1 libboost-iostreams1.65.1 libboost-locale1.65.1 libboost-random1.65.1 libboost-system1.65.1 libboost-thread1.65.1

RUN apt-get install -y -qq bzip2 libssl1.1

RUN apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists

COPY --from=builder /wesnoth/build/campaignd /
COPY --from=builder /wesnoth/build/wesnothd /

COPY ./wesnothd.cfg /

RUN mkdir /var/run/wesnothd && mkdir /work

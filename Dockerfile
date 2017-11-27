FROM tensorflow/tensorflow:1.1.0-gpu

MAINTAINER Adhita Selvaraj <adhita.selvaraj@stonybrook.edu>

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && apt-get install -qq -y \
	git \
	&& rm -rf /var/lib/apt/lists/*

RUN cd / && git clone https://github.com/swiftdiaries/benchmarks

ENV LD_LIBRARY_PATH /usr/local/nvidia${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

ENV PATH /usr/local/cuda-8.0/targets/x86_64-linux/lib/stubs${PATH:+:${PATH}}

ENV LD_LIBRARY_PATH /usr/local/nvidia${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

ENV LD_LIBRARY_PATH /usr/local/cuda-8.0/targets/x86_64-linux/lib/stubs${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

WORKDIR "/benchmarks/scripts/tf_cnn_benchmarks"

CMD exec /bin/bash -c "ls"

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

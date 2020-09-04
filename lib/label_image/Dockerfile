# docker build -t build-label-image .

FROM ubuntu:20.04

RUN mkdir -p /opt/label_image
WORKDIR /opt/label_image

RUN apt-get update
RUN apt-get install -y \
  build-essential \
  curl \
  git \
  python3 \
  python3-dev \
  python3-distutils \
  python3-numpy \
  unzip

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN curl -L https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-installer-linux-x86_64.sh > bazel-installer.sh
RUN bash bazel-installer.sh

RUN curl -L https://github.com/tensorflow/tensorflow/archive/v2.3.0.tar.gz > tensorflow.tar.gz
RUN tar xf tensorflow.tar.gz

WORKDIR tensorflow-2.3.0
RUN sed -i s:-lm:-static:g tensorflow/examples/label_image/BUILD
RUN PYTHON_BIN_PATH=/usr/bin/python PYTHON_LIB_PATH=/usr/lib/python3.8 TF_NEED_MKL=0 CC_OPT_FLAGS="-march=native" TF_NEED_JEMALLOC=1 TF_NEED_GCP=0 TF_NEED_HDFS=0 TF_ENABLE_XLA=0 TF_NEED_VERBS=0 TF_NEED_OPENCL=0 TF_NEED_CUDA=0 TF_NEED_MPI=0 ./configure
RUN bazel build tensorflow/examples/label_image/...

RUN curl -L "https://storage.googleapis.com/download.tensorflow.org/models/inception_v3_2016_08_28_frozen.pb.tar.gz" | tar xf -

ENTRYPOINT ./entrypoint.sh

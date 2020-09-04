#!/bin/bash
./bazel-bin/tensorflow/examples/label_image/label_image \
  --labels="./imagenet_slim_labels.txt" \
  --graph="./inception_v3_2016_08_28_frozen.pb" \
  --image="$1"

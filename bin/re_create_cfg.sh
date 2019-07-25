#!/usr/bin/env bash

set -eux

CUR_DIR=$(cd $(dirname $0);pwd)
PROJ_ROOT_DIR=$(cd ${CUR_DIR}/..; pwd)
CLJ_DIR="${CUR_DIR}/re_create_cfg"

(
    cd $CLJ_DIR
    clojure -m main $PROJ_ROOT_DIR
)

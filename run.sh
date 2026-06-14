#!/usr/bin/env bash
set -euo pipefail

GENERATOR_IMAGE="hw-generator"
ANALYZER_IMAGE="hw-analyzer"
DATA_DIR="$(pwd)/data"
LOCAL_DATA_DIR="$(pwd)/local_data"

case "${1:-}" in
  build_generator)
    docker build -t "$GENERATOR_IMAGE" ./generator;;

  run_generator)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" "$GENERATOR_IMAGE";;

  create_local_data)
    mkdir -p "$LOCAL_DATA_DIR"
    python3 generator/generate.py "$LOCAL_DATA_DIR";;

  build_reporter)
    docker build -t "$ANALYZER_IMAGE" ./analyzer;;

  run_reporter)
    docker run --rm -v "$DATA_DIR:/data" "$ANALYZER_IMAGE";;

  structure)
    find . -path ./.git -prune -o -print | sort;; # https://habr.com/ru/companies/alexhost/articles/525394/ https://www.man7.org/linux/man-pages/man1/find.1.html

  clear_data)
    rm -f "$DATA_DIR"/*.csv "$DATA_DIR"/*.html;;

  inside_generator)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" "$GENERATOR_IMAGE" ls -la /data;;

  inside_reporter)
    mkdir -p "$DATA_DIR"
    docker run --rm -v "$DATA_DIR:/data" "$ANALYZER_IMAGE" ls -la /data;;

  *)
    echo "Usage: $0 {build_generator|run_generator|create_local_data|build_reporter|run_reporter|structure|clear_data|inside_generator|inside_reporter}"
    exit 1;;
esac

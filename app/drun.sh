#!/usr/bin/env bash
exec docker run --security-opt apparmor=unconfined "$@"

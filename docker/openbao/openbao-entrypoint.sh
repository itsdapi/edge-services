#!/bin/sh
set -eu
chown -R openbao:openbao /openbao/data
envsubst < /openbao/config.hcl.tmpl > /tmp/config.hcl
exec su-exec openbao bao server -config=/tmp/config.hcl

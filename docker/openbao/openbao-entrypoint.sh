#!/bin/sh
set -eu
envsubst < /openbao/config.hcl.tmpl > /tmp/config.hcl
exec bao server -config=/tmp/config.hcl

#!/bin/sh
set -eu
chown -R openbao:openbao /openbao/data
cat > /tmp/config.hcl <<EOF
listener "tcp" {
  address     = "127.0.0.1:${INTERNAL_PORT}"
  tls_disable = true
}

listener "tcp" {
  address     = "0.0.0.0:${CLUSTER_PORT}"
  tls_disable = true
}

storage "raft" {
  path    = "/openbao/data"
  node_id = "${NODE_ID}"

  retry_join {
    leader_api_addr     = "https://${PEER1_HOSTNAME}:${OPENBAO_PORT}"
    leader_tls_servername = "${PEER1_HOSTNAME}"
  }
  retry_join {
    leader_api_addr     = "https://${PEER2_HOSTNAME}:${OPENBAO_PORT}"
    leader_tls_servername = "${PEER2_HOSTNAME}"
  }
  retry_join {
    leader_api_addr     = "https://${PEER3_HOSTNAME}:${OPENBAO_PORT}"
    leader_tls_servername = "${PEER3_HOSTNAME}"
  }
}

cluster_addr = "http://${NODE_HOSTNAME}:${CLUSTER_PORT}"
api_addr     = "https://${NODE_HOSTNAME}:${OPENBAO_PORT}"

ui = true
EOF
exec su-exec openbao bao server -config=/tmp/config.hcl

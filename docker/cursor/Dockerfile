FROM pen-base:latest

# Cursor Agent CLI (official lab tarball; version pin — bump when upgrading)
ARG CURSOR_AGENT_VERSION=2026.03.30-a5d3e17
RUN ARCH=$(dpkg --print-architecture) && \
    case "$ARCH" in \
      amd64) CUR_ARCH=x64 ;; \
      arm64) CUR_ARCH=arm64 ;; \
      *) echo "error: unsupported architecture: $ARCH" >&2; exit 1 ;; \
    esac && \
    mkdir -p /opt/cursor-agent && \
    curl -fsSL "https://downloads.cursor.com/lab/${CURSOR_AGENT_VERSION}/linux/${CUR_ARCH}/agent-cli-package.tar.gz" \
      | tar -xzf - -C /opt/cursor-agent && \
    ln -sf /opt/cursor-agent/dist-package/cursor-agent /usr/local/bin/cursor-agent && \
    ln -sf /opt/cursor-agent/dist-package/cursor-agent /usr/local/bin/agent

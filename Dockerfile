
# Use fix Node-red docker release
FROM nodered/node-red:5.0

# Switch to root user
USER root

# Set environment variables
ENV DKNR_USERNAME=admin \
      DKNR_PASSWORD=admin \
      DKNR_SECRET=dkzigbee \
      DKNR_REPOSITORY=https://github.com/JcDenis/dknr-zigbee \
      NODE_RED_ENABLE_PROJECTS=true \
      TZ=Europe/Paris

# Image label
LABEL org.opencontainers.image.authors="Jean-Christian Paul Denis" \
      org.opencontainers.image.source="https://github.com/JcDenis/dknr-zigbee" \
      org.opencontainers.image.title="DKNR Zigbee" \
      org.opencontainers.image.description="Zigbee2MQTT devices to DKNR MQTT with web UI" \
      org.opencontainers.image.licenses="AGPL-3.0"

# Set system timezone
RUN echo "$TZ" > /etc/timezone

# Prepare Node-Red structure
RUN mkdir -p /data/projects/dknr-zigbee

# Clone repository
RUN git clone ${DKNR_REPOSITORY} /data/projects/dknr-zigbee

# Fix ownership
RUN chown -R node-red:node-red /data

# Switch to node-red user
USER node-red

# Set working diretory for container starting script
WORKDIR /data

# Add container starting script
ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]

# Base image
FROM postman/newman:5.3-alpine

# Update/upgrade the image packages to the latest
RUN apk update && apk upgrade --no-cache

# Install extra packages: curl, zip, ping
RUN apk add --no-cache curl zip iputils

# Globally install node modules
RUN npm install -g newman-reporter-csvallinone

# Create an entrypoint script to set DNS at runtime
RUN echo '#!/bin/sh' > /usr/local/bin/entrypoint.sh && \
    echo 'echo "nameserver 8.8.8.8" > /etc/resolv.conf' >> /usr/local/bin/entrypoint.sh && \
    echo 'echo "nameserver 1.1.1.1" >> /etc/resolv.conf' >> /usr/local/bin/entrypoint.sh && \
    echo 'exec "$@"' >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Remove the cache
RUN rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/doc

# Set the environment variable
ENV NODE_PATH=/usr/local/lib/node_modules

# Set the working directory
WORKDIR /etc/newman

# Use the custom entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

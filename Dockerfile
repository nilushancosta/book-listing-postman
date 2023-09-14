# Use the Postman/Newman image as the base image
FROM node:18-alpine

# Create a directory for Newman collections
RUN mkdir /etc/postman

# Copy all Postman collection files to the container
COPY postman-collection-dir/*.json /etc/postman/

# Install newman cli
RUN npm i -g newman -y

# Create a script to run all collections in the directory
RUN echo '#!/bin/sh' >> /etc/run-collections.sh && \
    echo 'for file in /etc/postman/*.json; do' >> /etc/run-collections.sh && \
    echo '  newman run "$file";' >> /etc/run-collections.sh && \
    echo 'done' >> /etc/run-collections.sh && \
    chmod +x /etc/run-collections.sh

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo"
# Use the above created unprivileged user
USER 10014

# Run the script when the container starts
CMD ["/etc/run-collections.sh"]


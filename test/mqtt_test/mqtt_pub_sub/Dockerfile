FROM python:3.12.5-slim

# Install dependencies
RUN pip3 install --break-system-packages paho-mqtt \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/app/

COPY src/ /usr/app/src/

ENTRYPOINT ["/bin/bash", "-c"]
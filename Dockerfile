# Dockerfile
ARG BASE_IMAGE=rabbitmq:4-management
FROM ${BASE_IMAGE}

# Enable RabbitMQ Stream plugin by default
RUN rabbitmq-plugins enable --offline rabbitmq_stream rabbitmq_stream_management

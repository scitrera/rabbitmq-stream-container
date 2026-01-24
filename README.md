# RabbitMQ Stream Container

A Docker container image based on the official RabbitMQ image with the RabbitMQ Stream plugin pre-enabled.

## Overview

This project provides a pre-configured RabbitMQ container image that includes:
- **Base**: Official RabbitMQ 4 with Management plugin (`rabbitmq:4-management`)
- **Stream Plugin**: RabbitMQ Stream plugin enabled by default
- **Stream Management**: RabbitMQ Stream Management UI enabled by default
- **Multi-architecture**: Built for both `linux/amd64` and `linux/arm64` platforms

The image is automatically rebuilt daily to stay synchronized with upstream RabbitMQ releases.

## Resulting Image

The resulting Docker image is published to GitHub Container Registry (GHCR) at:

```
ghcr.io/scitrera/rabbitmq-stream
```

### Available Tags

Images are tagged following the RabbitMQ version pattern:

- `4-management` - Latest RabbitMQ 4.x with management and stream plugins
- `4.x-management` - Specific minor version (e.g., `4.0-management`, `4.1-management`)
- `4.x.y-management` - Specific patch version (e.g., `4.0.5-management`)

### Pre-enabled Plugins

The following plugins are enabled by default:
- `rabbitmq_stream` - RabbitMQ Stream protocol support
- `rabbitmq_stream_management` - Stream management UI extension
- All plugins included in `rabbitmq:4-management` (management, prometheus, etc.)

## Usage

### Basic Usage

Pull and run the image:

```bash
docker pull ghcr.io/scitrera/rabbitmq-stream:4-management

docker run -d \
  --name rabbitmq-stream \
  -p 5552:5552 \
  -p 15672:15672 \
  -p 5672:5672 \
  ghcr.io/scitrera/rabbitmq-stream:4-management
```

### Port Mappings

The container exposes the following ports:

| Port  | Protocol | Description                           |
|-------|----------|---------------------------------------|
| 5672  | AMQP     | AMQP 0-9-1 and AMQP 1.0               |
| 5552  | Stream   | RabbitMQ Stream protocol              |
| 15672 | HTTP     | Management UI and HTTP API            |

### Docker Compose

Example `docker-compose.yml`:

```yaml
version: '3.8'

services:
  rabbitmq:
    image: ghcr.io/scitrera/rabbitmq-stream:4-management
    ports:
      - "5552:5552"    # Stream
      - "5672:5672"    # AMQP
      - "15672:15672"  # Management UI
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: password
    volumes:
      - rabbitmq-data:/var/lib/rabbitmq

volumes:
  rabbitmq-data:
```

Start the service:

```bash
docker-compose up -d
```

### Environment Variables

All environment variables from the official RabbitMQ image are supported. Common options include:

- `RABBITMQ_DEFAULT_USER` - Default admin username (default: `guest`)
- `RABBITMQ_DEFAULT_PASS` - Default admin password (default: `guest`)
- `RABBITMQ_DEFAULT_VHOST` - Default virtual host (default: `/`)

See the [official RabbitMQ Docker documentation](https://hub.docker.com/_/rabbitmq) for a complete list.

### Accessing the Management UI

After starting the container, access the management UI at:

```
http://localhost:15672
```

Default credentials:
- Username: `guest` (or `RABBITMQ_DEFAULT_USER`)
- Password: `guest` (or `RABBITMQ_DEFAULT_PASS`)

The Stream Management plugin adds a "Streams" section to the UI for managing stream-specific resources.

### Using the Stream Protocol

Connect to the RabbitMQ Stream protocol on port `5552` using a RabbitMQ Stream client:

**Example (conceptual)**:
```
stream://localhost:5552
```

Refer to the [RabbitMQ Stream documentation](https://www.rabbitmq.com/streams.html) for language-specific client examples.

## Building Locally

To build the image locally:

```bash
docker build -t rabbitmq-stream:local .
```

With a specific base image:

```bash
docker build --build-arg BASE_IMAGE=rabbitmq:4.0-management -t rabbitmq-stream:local .
```

## Automation

This repository includes a GitHub Actions workflow that:
1. Checks daily for updates to the upstream `rabbitmq:4-management` image
2. Automatically rebuilds and publishes new images when upstream changes are detected
3. Maintains version tags aligned with upstream RabbitMQ releases
4. Tracks the upstream digest in `upstream-digest.txt` to prevent unnecessary rebuilds

## License

This project follows the same licensing as the official RabbitMQ Docker image. See the [RabbitMQ License](https://www.rabbitmq.com/mpl.html) for details.

## Resources

- [RabbitMQ Documentation](https://www.rabbitmq.com/documentation.html)
- [RabbitMQ Stream Documentation](https://www.rabbitmq.com/streams.html)
- [Official RabbitMQ Docker Image](https://hub.docker.com/_/rabbitmq)
- [RabbitMQ Stream Plugin](https://github.com/rabbitmq/rabbitmq-server/tree/main/deps/rabbitmq_stream)

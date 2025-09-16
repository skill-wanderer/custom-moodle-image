# Custom Moodle Docker Image

A custom Docker image based on Bitnami's Moodle that includes Redis support for enhanced performance and caching capabilities.

## What's Included

This custom image extends the official [Bitnami Moodle 5.0.2](https://hub.docker.com/r/bitnami/moodle) image with:

- **Redis Extension**: PHP Redis extension for high-performance caching
- **Development Tools**: PHP PEAR, PHP dev tools, and build essentials (removed after Redis installation to keep image size minimal)
- **Optimized Build**: Clean installation process that removes unnecessary packages after building

## Quick Start

### Pull and Run the Pre-built Image

```bash
# Pull the latest image
docker pull ghcr.io/skill-wanderer/custom-moodle-image:latest

# Run Moodle with default settings
docker run -d \
  --name moodle \
  -p 80:8080 \
  -p 443:8443 \
  ghcr.io/skill-wanderer/custom-moodle-image:latest
```

### Build Locally

```bash
# Clone the repository
git clone https://github.com/skill-wanderer/custom-moodle-image.git
cd custom-moodle-image

# Build the image
docker build -t custom-moodle .

# Run the container
docker run -d \
  --name moodle \
  -p 80:8080 \
  -p 443:8443 \
  custom-moodle
```

## Configuration

### Environment Variables

This image supports all the environment variables from the base Bitnami Moodle image. Here are some key ones:

```bash
docker run -d \
  --name moodle \
  -p 80:8080 \
  -p 443:8443 \
  -e MOODLE_DATABASE_HOST=mariadb \
  -e MOODLE_DATABASE_NAME=bitnami_moodle \
  -e MOODLE_DATABASE_USER=bn_moodle \
  -e MOODLE_DATABASE_PASSWORD=your_password \
  -e MOODLE_USERNAME=admin \
  -e MOODLE_PASSWORD=your_admin_password \
  ghcr.io/skill-wanderer/custom-moodle-image:latest
```

### Using with Docker Compose

```yaml
version: '3.8'

services:
  mariadb:
    image: docker.io/bitnami/mariadb:11.4
    environment:
      - MARIADB_USER=bn_moodle
      - MARIADB_PASSWORD=bitnami
      - MARIADB_DATABASE=bitnami_moodle
      - MARIADB_ROOT_PASSWORD=your_root_password
    volumes:
      - 'mariadb_data:/bitnami/mariadb'

  redis:
    image: docker.io/bitnami/redis:7.4
    environment:
      - REDIS_PASSWORD=your_redis_password
    volumes:
      - 'redis_data:/bitnami/redis/data'

  moodle:
    image: ghcr.io/skill-wanderer/custom-moodle-image:latest
    ports:
      - '80:8080'
      - '443:8443'
    environment:
      - MOODLE_DATABASE_HOST=mariadb
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_PASSWORD=bitnami
      - MOODLE_USERNAME=admin
      - MOODLE_PASSWORD=your_admin_password
    volumes:
      - 'moodle_data:/bitnami/moodle'
      - 'moodledata_data:/bitnami/moodledata'
    depends_on:
      - mariadb
      - redis

volumes:
  mariadb_data:
  redis_data:
  moodle_data:
  moodledata_data:
```

### Configuring Redis in Moodle

After running the container, you can configure Redis caching in your Moodle installation:

1. Access your Moodle admin panel
2. Go to **Site administration** > **Plugins** > **Caching** > **Configuration**
3. Add Redis as a cache store:
   - **Store name**: Redis
   - **Server**: Your Redis server address
   - **Password**: Your Redis password (if configured)

## Automated Builds

This repository includes a GitHub Actions workflow that automatically builds and publishes Docker images to GitHub Container Registry.

### Available Tags

- `latest` - Latest build from the main branch
- `main` - Latest build from the main branch
- `v1.0.0` - Specific version tags (when you create releases)
- `1.0` - Major.minor version tags

### Triggering Builds

- **Automatic**: Pushes to the `main` branch trigger new builds
- **Manual Release**: Create a git tag to build a specific version:
  ```bash
  git tag v1.0.0
  git push origin v1.0.0
  ```

### Build Features

- ✅ Multi-architecture support (AMD64 and ARM64)
- ✅ Layer caching for faster builds
- ✅ Automatic semantic versioning
- ✅ Security scanning
- ✅ Pull request validation

## Development

### Project Structure

```
.
├── dockerfile              # Main Dockerfile
├── .github/
│   └── workflows/
│       └── build-docker-image.yml  # GitHub Actions workflow
├── LICENSE                 # License file
└── README.md              # This file
```

### Building Locally

```bash
# Build for your current platform
docker build -t custom-moodle .

# Build for multiple platforms (requires buildx)
docker buildx build --platform linux/amd64,linux/arm64 -t custom-moodle .
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build locally
5. Submit a pull request

## Base Image Information

This image is based on [Bitnami Moodle](https://github.com/bitnami/containers/tree/main/bitnami/moodle), which provides:

- Moodle 5.0.2
- PHP 8.2
- Apache web server
- Optimized configuration
- Non-root user execution
- Regular security updates

## License

This project is licensed under the same terms as the base Bitnami image. See the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: Report issues on the [GitHub Issues](https://github.com/skill-wanderer/custom-moodle-image/issues) page
- **Discussions**: Join discussions in the [GitHub Discussions](https://github.com/skill-wanderer/custom-moodle-image/discussions) section
- **Base Image Documentation**: [Bitnami Moodle Documentation](https://github.com/bitnami/containers/tree/main/bitnami/moodle)

## Changelog

### v1.0.0
- Initial release based on Bitnami Moodle 5.0.2
- Added Redis PHP extension
- Automated GitHub Actions build pipeline
- Multi-architecture support (AMD64/ARM64)

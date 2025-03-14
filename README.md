# Paperless-Astra

Paperless-Astra is an intelligent document management system that combines the power of Paperless-ngx with advanced AI capabilities. It features ChromaDB vector search for semantic document retrieval, automated tagging, and natural language querying.

## Features

- All features from Paperless-ngx
- ChromaDB vector search integration
- AI-powered document analysis
- Automated tagging system
- Natural language querying
- Advanced OCR with Apache Tika
- Multi-database support (PostgreSQL, MariaDB, SQLite)

## Quick Start

The fastest way to get started is using Docker Compose:

```bash
# Clone the repository
git clone https://github.com/andrewtcrooks/paperless-astra.git
cd paperless-astra

# Start with PostgreSQL (recommended)
docker compose -f docker/compose/docker-compose.postgres.yml up -d

# Or with MariaDB
docker compose -f docker/compose/docker-compose.mariadb.yml up -d

# Or with SQLite
docker compose -f docker/compose/docker-compose.sqlite.yml up -d
```

Visit http://localhost:8000 to access the web interface.

## System Requirements

- Docker and Docker Compose
- 4GB RAM minimum (8GB recommended)
- 2 CPU cores minimum (4 cores recommended)
- Storage space for your documents

## Documentation

Detailed documentation is available in the `docs` directory:

- [Installation Guide](docs/installation.md)
- [Configuration Guide](docs/configuration.md)
- [Docker Setup](docs/docker/configuration.md)
- [Building Docker Images](docs/docker/building.md)
- [AI Features](docs/ai/index.md)
  - [Document Q&A](docs/ai/qa.md)
  - [Chat Interface](docs/ai/chat.md)
  - [Automatic Tagging](docs/ai/tagging.md)
- [API Reference](docs/api/index.md)
- [Troubleshooting](docs/troubleshooting.md)

## Docker Images

We provide official Docker images on Docker Hub:

```bash
docker pull paperlessastra/paperless-astra:latest
```

For information on building and publishing Docker images, see our [Docker building guide](docs/docker/building.md).

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## Support

- [GitHub Issues](https://github.com/andrewtcrooks/paperless-astra/issues)
- [Documentation](docs/index.md)
- [Community Discussions](https://github.com/andrewtcrooks/paperless-astra/discussions)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) - The foundation of this project
- [ChromaDB](https://github.com/chroma-core/chroma) - Vector database for semantic search
- [Apache Tika](https://tika.apache.org/) - Document parsing and metadata extraction
- All contributors and community members
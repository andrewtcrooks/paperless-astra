[![ci](https://github.com/paperless-ngx/paperless-ngx/workflows/ci/badge.svg)](https://github.com/paperless-ngx/paperless-ngx/actions)
[![Crowdin](https://badges.crowdin.net/paperless-ngx/localized.svg)](https://crowdin.com/project/paperless-ngx)
[![Documentation Status](https://img.shields.io/github/deployments/paperless-ngx/paperless-ngx/github-pages?label=docs)](https://docs.paperless-ngx.com)
[![codecov](https://codecov.io/gh/paperless-ngx/paperless-ngx/branch/main/graph/badge.svg?token=VK6OUPJ3TY)](https://codecov.io/gh/paperless-ngx/paperless-ngx)
[![Chat on Matrix](https://matrix.to/img/matrix-badge.svg)](https://matrix.to/#/%23paperlessngx%3Amatrix.org)

# Paperless-Astra

Paperless-Astra is an intelligent document management system that combines the robust document handling of Paperless-ngx with advanced AI capabilities. It helps you organize, search, and analyze your documents using state-of-the-art machine learning.

## Features

### 🤖 AI-Powered Document Analysis
- **Natural Language Search**: Ask questions about your documents in plain English
- **Smart Tagging**: Automatic document categorization and tag suggestions
- **Content Summarization**: Get quick summaries of document contents
- **Information Extraction**: Automatically extract key information like dates, amounts, and entities
- **Document Comparison**: Compare multiple documents and identify similarities/differences
- **Multi-Language Support**: Process documents in multiple languages

### 📄 Document Management
- **OCR Processing**: Convert scanned documents into searchable text
- **Automated Filing**: Smart organization based on content and metadata
- **Version Control**: Track document changes and maintain history
- **Full-Text Search**: Find any document by its content
- **Tag System**: Organize documents with hierarchical tags
- **Custom Workflows**: Automate document processing pipelines

### 🔒 Security & Privacy
- **Local Processing**: All AI processing happens on your infrastructure
- **Encryption**: Document encryption at rest and in transit
- **Access Control**: Fine-grained user permissions
- **Audit Logging**: Track all system activities
- **Backup Support**: Built-in backup and restore capabilities

### 🔌 Integration & Extensibility
- **API First**: Complete REST API for automation and integration
- **File Format Support**: Handle PDFs, Office documents, images, and emails
- **Custom Plugins**: Extend functionality with plugins
- **Export Options**: Export documents in various formats
- **Mobile Support**: Access your documents on any device

## Quick Start

### Using Docker (Recommended)

1. Create a directory for Paperless-Astra:
```bash
mkdir paperless-astra
cd paperless-astra
```

2. Download the Docker Compose file:
```bash
curl -L https://raw.githubusercontent.com/paperless-astra/paperless-astra/main/docker/compose/docker-compose.yml -o docker-compose.yml
```

3. Start Paperless-Astra:
```bash
docker compose up -d
```

4. Create your superuser account:
```bash
docker compose run --rm webserver createsuperuser
```

5. Access the web interface at http://localhost:8000

### Configuration Options

Multiple Docker Compose configurations are available:

- `docker-compose.yml`: Default configuration with SQLite
- `docker-compose.postgres.yml`: PostgreSQL configuration
- `docker-compose.mariadb.yml`: MariaDB configuration
- `docker-compose.postgres-tika.yml`: Full setup with PostgreSQL, Tika, and Gotenberg

See [Docker Configuration Guide](docs/docker/configuration.md) for detailed setup instructions.

## System Requirements

### Minimum Requirements
- CPU: 2 cores
- RAM: 4GB
- Storage: 10GB

### Recommended Requirements
- CPU: 4+ cores
- RAM: 8GB+
- Storage: 20GB+ SSD
- GPU: Optional, improves AI processing speed

## Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Guide](docs/docker/configuration.md)
- [User Guide](docs/usage.md)
- [API Documentation](docs/api.md)
- [AI Features](docs/ai/index.md)
- [Troubleshooting](docs/troubleshooting.md)

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository:
```bash
git clone https://github.com/paperless-astra/paperless-astra.git
cd paperless-astra
```

2. Set up development environment:
```bash
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
```

3. Run tests:
```bash
pytest
```

## Support

- [GitHub Issues](https://github.com/paperless-astra/paperless-astra/issues)
- [Documentation](https://paperless-astra.github.io/docs)
- [Community Forum](https://github.com/paperless-astra/paperless-astra/discussions)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Based on [Paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)
- Uses [ChromaDB](https://github.com/chroma-core/chroma) for vector search
- Powered by various open-source ML models and libraries

---

*Paperless-Astra: Your documents, smarter.*
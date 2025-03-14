# Docker Configuration Guide

This guide explains how to configure Paperless-Astra's Docker setup and enable/disable optional features.

## Base Configuration

### Essential Environment Variables

```yaml
environment:
  # Required
  PAPERLESS_SECRET_KEY: change-me
  PAPERLESS_TIME_ZONE: UTC
  PAPERLESS_URL: http://localhost:8000

  # Redis (required)
  PAPERLESS_REDIS: redis://broker:6379

  # Optional Security
  PAPERLESS_COOKIE_PREFIX: paperless
  PAPERLESS_ENABLE_HTTP_REMOTE_USER: 0
  PAPERLESS_FORCE_SCRIPT_NAME:
  PAPERLESS_TRUSTED_PROXIES: []
  PAPERLESS_CSRF_TRUSTED_ORIGINS: []
```

### Database Configuration

Choose one of the following database configurations:

#### SQLite (Default)
```yaml
environment:
  PAPERLESS_DBENGINE: sqlite
```

#### PostgreSQL
```yaml
environment:
  PAPERLESS_DBHOST: db
  PAPERLESS_DBPORT: 5432
  PAPERLESS_DBNAME: paperless
  PAPERLESS_DBUSER: paperless
  PAPERLESS_DBPASS: paperless
```

#### MariaDB
```yaml
environment:
  PAPERLESS_DBHOST: db
  PAPERLESS_DBPORT: 3306
  PAPERLESS_DBNAME: paperless
  PAPERLESS_DBUSER: paperless
  PAPERLESS_DBPASS: paperless
```

## Optional Features

### ChromaDB Integration

ChromaDB provides vector search capabilities for AI-powered document analysis. To enable:

1. Add the service:
```yaml
chromadb:
  image: ghcr.io/chroma-core/chroma:latest
  restart: unless-stopped
  volumes:
    - chromadata:/chroma/data
  environment:
    CHROMA_DB_IMPL: clickhouse
    CLICKHOUSE_HOST: localhost
    CLICKHOUSE_PORT: 8123
  ports:
    - "8001:8000"
```

2. Add to volumes:
```yaml
volumes:
  chromadata:
```

3. Add to webserver dependencies:
```yaml
depends_on:
  - chromadb
```

4. Configure environment variables:
```yaml
environment:
  PAPERLESS_CHROMA_ENABLED: 1
  PAPERLESS_CHROMA_URL: http://chromadb:8000
  PAPERLESS_CHROMA_BATCH_SIZE: 100
  PAPERLESS_CHROMA_EMBEDDING_MODEL: all-MiniLM-L6-v2
  PAPERLESS_CHROMA_COLLECTION: paperless
```

### Tika & Gotenberg Integration

For enhanced document processing (Office documents, emails):

1. Add the services:
```yaml
tika:
  image: apache/tika:2.9.1.0
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:9998/tika"]
    interval: 30s
    timeout: 10s
    retries: 3
  ports:
    - "9998:9998"

gotenberg:
  image: gotenberg/gotenberg:7.10
  restart: unless-stopped
  command:
    - "gotenberg"
    - "--api-port=3000"
    - "--chromium-disable-javascript=true"
    - "--chromium-allow-list=file:///tmp/.*"
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
    interval: 30s
    timeout: 10s
    retries: 3
  ports:
    - "3000:3000"
```

2. Add to webserver dependencies:
```yaml
depends_on:
  - tika
  - gotenberg
```

3. Configure environment variables:
```yaml
environment:
  PAPERLESS_TIKA_ENABLED: 1
  PAPERLESS_TIKA_ENDPOINT: http://tika:9998
  PAPERLESS_TIKA_GOTENBERG_ENDPOINT: http://gotenberg:3000
  PAPERLESS_TIKA_TIMEOUT: 30
  PAPERLESS_TIKA_MAX_FILE_SIZE: 100000000
```

## Advanced Configuration

### OCR Settings
```yaml
environment:
  PAPERLESS_OCR_LANGUAGE: eng
  PAPERLESS_OCR_LANGUAGES: eng+fra+deu
  PAPERLESS_OCR_MODE: skip  # skip, redo, force
  PAPERLESS_OCR_OUTPUT_TYPE: pdfa  # pdf, pdfa, pdfa-1, pdfa-2, pdfa-3
  PAPERLESS_OCR_PAGES: -1  # -1 for all pages
  PAPERLESS_OCR_IMAGE_DPI: 300
  PAPERLESS_OCR_USER_ARGS: '{"optimize": 1}'
```

### Consumption Settings
```yaml
environment:
  PAPERLESS_CONSUMER_POLLING: 0
  PAPERLESS_CONSUMER_POLLING_INTERVAL: 60
  PAPERLESS_CONSUMER_POLLING_RETRY_COUNT: 5
  PAPERLESS_CONSUMER_RECURSIVE: 1
  PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS: 1
  PAPERLESS_CONSUMER_DELETE_DUPLICATES: 1
  PAPERLESS_CONSUMER_ONE_SHOT: 0
```

### File Handling
```yaml
environment:
  PAPERLESS_FILENAME_DATE_ORDER: YMD
  PAPERLESS_FILENAME_FORMAT: "{created_year}/{correspondent}/{title}"
  PAPERLESS_THUMBNAIL_FONT_NAME: /usr/share/fonts/liberation/LiberationSerif-Regular.ttf
  PAPERLESS_CONVERT_MEMORY_LIMIT: 4096
  PAPERLESS_CONVERT_TMPDIR: /tmp
```

### Performance Tuning
```yaml
environment:
  PAPERLESS_WEBSERVER_WORKERS: 1
  PAPERLESS_TASK_WORKERS: 1
  PAPERLESS_THREADS_PER_WORKER: 1
  PAPERLESS_DB_TIMEOUT: 30
  PAPERLESS_WORKER_TIMEOUT: 1800
  PAPERLESS_WORKER_RETRY: 3
```

### Security & Authentication
```yaml
environment:
  PAPERLESS_AUTO_LOGIN_USERNAME:
  PAPERLESS_ADMIN_USER: admin
  PAPERLESS_ADMIN_PASSWORD: change-me
  PAPERLESS_ADMIN_MAIL: admin@example.com
  PAPERLESS_SESSION_COOKIE_AGE: 1209600
```

## Volume Configuration

### Standard Volumes
```yaml
volumes:
  - data:/usr/src/paperless/data      # Application data
  - media:/usr/src/paperless/media    # Document storage
  - ./consume:/usr/src/paperless/consume  # Input directory
  - ./export:/usr/src/paperless/export    # Export directory
```

### Database Volumes
```yaml
volumes:
  - pgdata:/var/lib/postgresql/data   # PostgreSQL
  - dbdata:/var/lib/mysql            # MariaDB
  - redisdata:/data                  # Redis
  - chromadata:/chroma/data          # ChromaDB (optional)
```

## Health Checks

All services include health checks to ensure reliability:

- Redis: Checks connection with `redis-cli ping`
- PostgreSQL: Verifies database access with `pg_isready`
- MariaDB: Tests connection with a simple query
- Webserver: Confirms HTTP endpoint availability
- Tika: Verifies API endpoint
- Gotenberg: Checks service health
- ChromaDB: Monitors service status

## Network Configuration

Services expose the following ports:

- Webserver: 8000
- ChromaDB: 8001
- Tika: 9998
- Gotenberg: 3000

You can modify these using the `ports` directive:
```yaml
ports:
  - "custom:container"  # e.g., "8080:8000"
```
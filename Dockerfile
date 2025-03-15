# syntax=docker/dockerfile:1
# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md

FROM debian:bookworm-slim

# Install system packages
RUN set -eux \
  && echo "Installing system packages" \
    && apt-get update \
    && apt-get install --yes --quiet --no-install-recommends \
        curl \
        ghostscript \
        gnupg \
        imagemagick \
        python3-full \
        python3-pip \
        python3-venv \
        python3-dev \
        build-essential \
        libpq-dev \
        postgresql-client \
        libmagic-dev \
        libmagic1 \
        tesseract-ocr \
        tesseract-ocr-eng \
        unpaper \
        supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and enable corepack
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && corepack enable

# Create paperless user and directories
RUN useradd -ms /bin/bash paperless && \
    mkdir -p /usr/src/paperless && \
    mkdir -p /usr/src/paperless/consume && \
    mkdir -p /usr/src/paperless/data && \
    mkdir -p /usr/src/paperless/media && \
    mkdir -p /usr/src/paperless/static && \
    mkdir -p /usr/src/paperless/static/frontend && \
    mkdir -p /usr/src/paperless/src/static/frontend/en-US && \
    mkdir -p /usr/src/paperless/static/logo/web/png && \
    chown -R paperless:paperless /usr/src/paperless

# Set working directory
WORKDIR /usr/src/paperless

# Create virtual environment
RUN python3 -m venv /usr/src/paperless/.venv

# Copy project files
COPY --chown=paperless:paperless . /usr/src/paperless/

# Copy configuration file
COPY --chown=paperless:paperless paperless.conf /usr/src/paperless/paperless.conf

# Copy logo files
RUN mkdir -p /usr/src/paperless/static/logo/web/png && \
    cp /usr/src/paperless/resources/logo/web/png/* /usr/src/paperless/static/logo/web/png/

# Install Python dependencies in virtual environment
ENV PATH="/usr/src/paperless/.venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install --no-cache-dir psycopg2-binary && \
    pip install --no-cache-dir -e .

# Install frontend dependencies and build
RUN cd src-ui && \
    pnpm install && \
    pnpm run build --configuration production && \
    mkdir -p /usr/src/paperless/static/frontend/en-US/ && \
    cp -r ../src/documents/static/frontend/en-US/* /usr/src/paperless/static/frontend/en-US/ && \
    chown -R paperless:paperless /usr/src/paperless/static/frontend/en-US/

# Create supervisor configuration
RUN mkdir -p /etc/supervisor/conf.d
COPY --chown=root:root docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create startup script
COPY --chown=root:root docker/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Switch to paperless user
USER paperless

# Start services
CMD ["/usr/local/bin/startup.sh"]

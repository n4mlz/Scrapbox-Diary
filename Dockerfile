# Build the static site using the locked converter and runtime credentials.
FROM node:22-bookworm-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --prod --frozen-lockfile

COPY astro.config.mjs build-site.sh tsconfig.json ./
COPY public ./public
COPY src ./src
RUN mkdir -p src/content \
    && chown -R 1000:1000 /app

USER 1000:1000

LABEL org.opencontainers.image.source="https://github.com/n4mlz/Scrapbox-Diary"

CMD ["sh", "./build-site.sh"]

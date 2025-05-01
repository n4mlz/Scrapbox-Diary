FROM node:slim AS base

ARG PROJECT_NAME
ARG PAGE_TITLE
ARG CONNECT_SID

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

# inject scrapbox content
RUN curl https://scrapbox.io/api/pages/${PROJECT_NAME}/${PAGE_TITLE}/text -b "connect.sid=${CONNECT_SID}" | npx @hogashi/sb2md@latest | sed '1d' > /app/src/content/daily.md

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# saved at /app/dist
RUN pnpm run build

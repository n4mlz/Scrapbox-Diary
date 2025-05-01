FROM node:slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS build
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

ARG PROJECT_NAME
ARG PAGE_TITLE
ARG CONNECT_SID

ENV PROJECT_NAME=${PROJECT_NAME}
ENV PAGE_TITLE=${PAGE_TITLE}
ENV CONNECT_SID=${CONNECT_SID}

# inject scrapbox content and saved at /app/dist
RUN apt update && apt install -y curl
ENTRYPOINT [ "sh", "-c", "curl https://scrapbox.io/api/pages/${PROJECT_NAME}/${PAGE_TITLE}/text -b \"connect.sid=${CONNECT_SID}\" | npx @hogashi/sb2md@latest | sed '1d' > /app/src/content/diary.md && pnpm run build"]

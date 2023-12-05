FROM docker.io/node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3001

WORKDIR /app

RUN corepack enable
RUN addgroup --system svc-user && \
    adduser --system -G svc-user svc-user

COPY dist/apps/svc-user svc-user
RUN chown -R svc-user:svc-user .

RUN pnpm --prefix svc-user --prod -f install

CMD [ "node", "svc-user" ]
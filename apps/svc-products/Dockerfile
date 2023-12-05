FROM docker.io/node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN corepack enable
RUN addgroup --system svc-products && \
    adduser --system -G svc-products svc-products

COPY dist/apps/svc-products svc-products
RUN chown -R svc-products:svc-products .

RUN pnpm --prefix svc-products --prod -f install

CMD [ "node", "svc-products" ]
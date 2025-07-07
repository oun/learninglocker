FROM node:12 as builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN npm_config_build_from_source=true yarn install --ignore-engines --frozen-lockfile

COPY . .

RUN yarn build-ui-server && yarn build-ui-client

RUN rm -rf node_modules \
  && npm_config_build_from_source=true yarn install --offline --production --ignore-engines --frozen-lockfile

FROM node:12-alpine

WORKDIR /app

COPY --from=builder /app/ui/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Install envsubst
RUN apk add --no-cache gettext

COPY entrypoint.sh env.template ./
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["node", "./dist/server"]
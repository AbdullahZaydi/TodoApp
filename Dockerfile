FROM public.ecr.aws/docker/library/node:20.9.0-slim AS builder

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM public.ecr.aws/docker/library/node:20.9.0-slim
WORKDIR /app
COPY --from=builder /app ./
CMD ["node", "server.js"] # Adjust if your entry point is different
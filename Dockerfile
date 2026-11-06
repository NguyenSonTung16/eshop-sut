FROM node:24-bookworm AS build

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ && rm -rf /var/lib/apt/lists/*

COPY backend/package*.json backend/
RUN npm ci --prefix backend --build-from-source=sqlite3

COPY frontend-web/package*.json frontend-web/
RUN npm ci --prefix frontend-web
COPY frontend-web/ frontend-web/
RUN npm run build --prefix frontend-web

COPY frontend-admin/package*.json frontend-admin/
RUN npm ci --prefix frontend-admin
COPY frontend-admin/ frontend-admin/
RUN npm run build --prefix frontend-admin -- --base=/admin/

COPY backend/ backend/

FROM node:24-bookworm-slim
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/backend /app/backend
COPY --from=build /app/frontend-web/dist /app/frontend-web/dist
COPY --from=build /app/frontend-admin/dist /app/frontend-admin/dist
EXPOSE 10000
CMD ["node", "backend/server.js"]

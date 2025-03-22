# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# install necessary build dependencies 
RUN apk add --no-cache python3 make g++

#Copy package file
COPY package*.json ./

#Install dependencies
RUN npm ci

#Copy all project files
COPY . .

#Build the next.js application
RUN npm run build

# Production stage with Nginx
FROM node:18-alpine AS runner
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static/ ./next/static
COPY --from=build /app/public ./public

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000
CMD ["node", "server.js"]

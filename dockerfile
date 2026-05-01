# STAGE 1: Builder
# Uses a full Alpine image to install dependencies and build the app
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files and install all dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of your source code
COPY . .

# (Optional) If you have a build step (like TypeScript), run it here
# RUN npm run build

# STAGE 2: Runner
# Uses a "Distroless" image containing only the Node.js runtime
FROM gcr.io/distroless/nodejs20
WORKDIR /app

# Copy only the necessary files from the builder stage
# This keeps the final image size extremely small and secure
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/app.js ./

# Expose the app port
EXPOSE 3000

# Start the application
CMD ["app.js"]

# Use the official Node.js 18 image as a base
FROM node:20-slim AS build

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json into the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Build the Next.js application
RUN npm run build

# Prepare the app for production
RUN npm install --production

# ----- Begin final image ----- #
# Use a minimal Node.js base image for the final build
FROM node:18-alpine

# Set working directory for production container
WORKDIR /app

# Copy production dependencies from the previous build stage
COPY --from=build /app/node_modules ./node_modules

# Copy built application from the build stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./

# Set environment variable to production
ENV NODE_ENV=production

# AWS Lambda doesn't require port 3000 to be exposed. Lambda routes requests from API Gateway directly to your app.
# However, you still define the default port for local development or other environments
ENV PORT=3000

# Lambda will invoke the handler directly, but in case you're testing locally, you might want to expose the app
EXPOSE 3000

# Define the Lambda function's entry point by using Next.js production start command
CMD ["npm", "run", "start"]

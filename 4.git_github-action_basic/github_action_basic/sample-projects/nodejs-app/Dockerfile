FROM node:20-alpine

WORKDIR /app

# Copy package files first (layer caching)
COPY package.json .

# Install production dependencies only
RUN npm install --production

# Copy application code
COPY server.js .

EXPOSE 3000

CMD ["npm", "start"]

# Use a Node.js image as our base image
FROM node:20.8.0-alpine3.18

# Set the working directory in the docker container
WORKDIR /usr/src/app

# Copy the local project files into the container
COPY . .

# Install the dependencies in the container
RUN npm install

# Generate Prisma types
RUN npx prisma generate

# Compile TypeScript to JavaScript
RUN npm run compile

# Expose port
EXPOSE 4000

# Set the command to run your application. This can be `npm start` or `node your-entry-file.js`, etc.
CMD [ "npm", "run", "start:prod" ]
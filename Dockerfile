# Builder
FROM node:12-alpine AS builder

WORKDIR /app

# copy both 'package.json' and 'yarn.lock' (if available)
COPY package*.json ./
COPY yarn.lock ./

# Run build command.
RUN yarn install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .
RUN yarn run build

EXPOSE 8080

CMD ["yarn", "serve"]

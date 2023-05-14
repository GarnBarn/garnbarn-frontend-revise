## Builder Stage
FROM node:12-alpine AS build-stage

WORKDIR /app

# copy both 'package.json' and 'yarn.lock' (if available)
COPY package*.json ./
COPY yarn.lock ./

# Run build command.
RUN yarn install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .

# Build
RUN yarn run build

# Remove sourcemap file before send output to production-stage
RUN find . -name "*.map" -type f -delete



## Production Stage
FROM nginx:stable-alpine as production-stage

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=build-stage /app/dist /usr/share/nginx/html/


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

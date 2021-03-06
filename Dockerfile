  
# ##### Stage 1

# FROM node:10 as node

# LABEL author="Maina Wycliffe"

# WORKDIR /app

# COPY . .

# # install yarn
# RUN npm i yarn

# #install packages
# # you can change the version of angular CLI to the one you are using in your application
# RUN yarn install


# # if you have libraries in your workspace that the angular app relies on, build them here

# #RUN ng build library-name --prod

# # build your application
# #RUN ng build --prod
# RUN npx ng build --prod
# # STAGE 2
# # Deploy APP

# # In this stage, we are going to take the build artefacts from stage one and build a deployment docker image
# # We are using nginx:alpine as the base image of our deployment image

# FROM nginx:alpine

# COPY --from=node /app/dist/wirid-lab-web-app /usr/share/nginx/html
# COPY --from=node /app/.docker/nginx.conf /etc/nginx/conf.d/default.conf

# EXPOSE 80

# Stage 0, "build-stage", based on Node.js, to build and compile the frontend


FROM node:10 as build-stage


# Puppeteer dependencies, from: https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

WORKDIR /app

RUN npm install puppeteer

COPY ./nginx.conf /nginx.conf

WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
ARG configuration=production
RUN npm run build -- --output-path=./dist/out  --configuration $configuration
#RUN npm run build -- --output-path=./dist/out  
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.15
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html





# Copy the default nginx.conf provided by tiangolo/node-frontend
COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf

# Copy the EntryPoint
#COPY ./entryPoint.sh /
#RUN chmod +x entryPoint.sh

#ENTRYPOINT ["/entryPoint.sh"]

# # FROM tiangolo/node-frontend:10 as build-stage
# # WORKDIR /app
# # COPY package*.json /app/
# # RUN npm install
# # COPY ./ /app/
# # ARG configuration=production
# # RUN npm run build -- --output-path=./dist/out --configuration $configuration
# # # Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
# # FROM nginx:1.15
# # COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
# # # Copy the default nginx.conf provided by tiangolo/node-frontend
# # COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf


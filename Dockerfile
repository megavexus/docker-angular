FROM node:9.4-alpine
MAINTAINER Javier Gutierrez

# Install npm
RUN npm install -g @angular/cli

ARG APP_NAME

# Create de working dir
RUN mkdir -p /app
WORKDIR /app

# Copy and install the dependencies of the angular project
COPY ./${APP_NAME}/package.json /app/
RUN ["npm", "install"]

# Create the deployment folder
RUN ["mkdir", "/app/dist"]

# Copy the rest of the app
COPY ./${APP_NAME}/ /app

EXPOSE 4200/tcp

VOLUME [ "/app/dist", "/app/src" ]

# Set up scripts to manage the angular app
RUN printf '#!/bin/sh\nng build -delete-output-path=false' > /usr/bin/build && \
    chmod +x /usr/bin/build
RUN printf '#!/bin/sh\nng build --prod -delete-output-path=false' > /usr/bin/build_prod && \
    chmod +x /usr/bin/build_prod
RUN printf '#!/bin/sh\nng serve -delete-output-path=false' > /usr/bin/serve && \
    chmod +x /usr/bin/serve
RUN printf '#!/bin/sh\nng serve --prod -delete-output-path=false' > /usr/bin/serve_prod && \
    chmod +x /usr/bin/serve_prod
# In a dockerized environment the selenium tests doesnt work
# TODO: https://github.com/angular/angular-cli/issues/5019 to install xvfb
#RUN printf '#!/bin/sh\nng e2e -delete-output-path=false' > /usr/bin/e2e && \
#    chmod +x /usr/bin/e2e
#RUN printf '#!/bin/sh\nng e2e --prod -delete-output-path=false' > /usr/bin/e2e_prod && \
#    chmod +x /usr/bin/e2e_prod

CMD ["npm", "start", "--", "--host", "0.0.0.0", "--poll", "500", "--no-delete-output-path"]
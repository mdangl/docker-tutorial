################
# Run in NGINX #
################
FROM nginx:1.25-alpine
COPY dist /usr/share/nginx/html

# When the container starts, replace the env.js with values from environment variables
CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js ; exec nginx -g 'daemon off;'"]
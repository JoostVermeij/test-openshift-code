#angular frontend
FROM node:alpine AS nodeApp
WORKDIR /nodeApp
COPY .. .

#ADD https://github.com/kyubisation/angular-server-side-configuration/releases/download/v18.1.0/ngssc_64bit /nodeApp/ngssc

RUN echo $PATH

ARG DEPLOYMENT_NAME="prod"

ARG MESSAGE
ARG MY_NODE_NAME
ARG MY_POD_NAME
ARG MY_POD_NAMESPACE
ARG MY_POD_IP
ARG MY_POD_SERVICE_ACCOUNT

ENV MESSAGE="message_${DEPLOYMENT_NAME}_${MESSAGE}"
ENV POD_NAME="pod_name_${DEPLOYMENT_NAME}_${POD_NAME}"
ENV MY_NODE_NAME="node_name_${DEPLOYMENT_NAME}_${MY_NODE_NAME}"
ENV MY_POD_NAMESPACE="pod_namespace_${DEPLOYMENT_NAME}_${MY_POD_NAMESPACE}"
ENV MY_POD_IP="pod_ip_${DEPLOYMENT_NAME}_${MY_POD_IP}"
ENV MY_POD_SERVICE_ACCOUNT="pod_service_account_${DEPLOYMENT_NAME}_${MY_POD_SERVICE_ACCOUNT}"

RUN npm install -g envsub
RUN envsub /nodeApp/src/environments/environment.$DEPLOYMENT_NAME.ts /nodeApp/src/environments/environment.$DEPLOYMENT_NAME.ts
RUN cat /nodeApp/src/environments/environment.$DEPLOYMENT_NAME.ts

#RUN npm install -g @angular/cli
RUN npm install
RUN npm run build-$DEPLOYMENT_NAME
#RUN npm run ngssc

RUN echo "node app done"

# nginx server
FROM nginxinc/nginx-unprivileged AS nginxApp
WORKDIR /nginxApp

# Install ngssc binary

# Add ngssc init script

COPY --from=nodeApp /nodeApp/dist/test-app /usr/share/nginx/html
COPY --from=nodeApp /nodeApp/nginx.conf /etc/nginx/conf.d/default.conf
#COPY --from=nodeApp --chmod=0777 /nodeApp/ngssc /nginxApp/ngssc

#RUN /nginxApp/ngssc insert --nginx /usr/share/nginx/html

#ARG MESSAGE="hello_arg"
#ARG POD_NAME="pod_name_arg"
#ENV MESSAGE="hello_env"
#ENV POD_NAME="pod_name_env"

#RUN ls /usr/share/nginx/html -al

#RUN cat /usr/share/nginx/html/index.html
#RUN cat /usr/share/nginx/html/ngssc.json

#RUN cat /usr/share/nginx/html
RUN echo "nginx app done"

EXPOSE 8081
USER daemon
CMD ["nginx", "-g", "daemon off;"]
#, "&&", "/nginxApp/ngssc", "insert", "--nginx", " /usr/share/nginx/html"]

FROM pegasystems/postgres-pljava-openjdk:11

# Copy custome initdb & scripts
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY scripts /scripts
RUN chmod -R +x '/scripts'

# Install pljava
#RUN apt-get update && apt-get install -y postgresql-9.5-pljava
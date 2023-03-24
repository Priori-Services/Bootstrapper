set dotenv-load
set ignore-comments

default: dev-env

build-dev-db:
    buildah build --tag="$PRIORI_DATABASE_IMAGE" ./PRIORI_SERVICES_DB

create-dev-db:
    -"$CONTAINER_RUNNER" run \
    -e "ACCEPT_EULA=Y" \
    -e "MSSQL_SA_PASSWORD=$PRIORI_DATABASE_PASSWORD" \
    -e "MSSQL_PID=Express" \
    -p 1433:1433 \
    --name "$PRIORI_DATABASE_NAME" \
    "$PRIORI_DATABASE_IMAGE"

dev-env: create-dev-db
    "$CONTAINER_RUNNER" start "$PRIORI_DATABASE_NAME"
    mprocs --config=mprocs.yaml

sqlcmd: 
    "$CONTAINER_RUNNER" exec -it "$PRIORI_DATABASE_NAME" \
        /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 \
        -U sa -P "$PRIORI_DATABASE_PASSWORD"

default-env:
    cp -f ".env-template" ".env"

[linux]
database-perms:
    chcon -Rt svirt_sandbox_file_t /vagrant/PRIORI_SERVICES_DB

[windows]
setup-vagrant:
    vagrant plugin install vagrant-winnfsd

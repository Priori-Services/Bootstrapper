set dotenv-load
set ignore-comments

default: dev-env

apply-data:
    "$CONTAINER_RUNNER" exec "$PRIORI_DATABASE_NAME" "/opt/mssql-tools/bin/sqlcmd" "-S" "localhost" "-U" "sa" "-P" "${PRIORI_DATABASE_PASSWORD}" "-i" "/opt/app/Priori.sql"

dev-env:
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

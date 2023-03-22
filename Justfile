set dotenv-load
set ignore-comments
justfiles := "PRIORI_SERVICES_API/Justfile PRIORI_SERVICES_WEB/Justfile"

default: dev-env

[private]
ignore-error +ACTION:
    -just {{ACTION}}

[private]
do-for-all +ACTION:
    for justfile in {{justfiles}} ; do \
        just -f "$justfile" {{ACTION}} ; \
    done

build: (do-for-all "build-image") # Must be syncronous, or else the containers won't build

create: (do-for-all "create-container") create-database

start: (ignore-error 'do-for-all "start-container"') start-database

stop: (do-for-all "stop-container")
    -"$CONTAINER_RUNNER" stop "$PRIORI_DATABASE_NAME"

cleanup: (ignore-error "stop") (ignore-error 'do-for-all "cleanup"')
    -"$CONTAINER_RUNNER" rm "$PRIORI_DATABASE_NAME"

prod: build create

create-database:
    "$CONTAINER_RUNNER" run \
                -e "ACCEPT_EULA=Y" \
                -e "MSSQL_SA_PASSWORD=$PRIORI_DATABASE_PASSWORD" \
                -e "MSSQL_PID=Express" \
                -p 1433:1433 \
                --name "$PRIORI_DATABASE_NAME" \
                -d 'mcr.microsoft.com/mssql/server:2022-latest' \
                
                
start-database: (ignore-error 'create-database')
    "$CONTAINER_RUNNER" start "$PRIORI_DATABASE_NAME"

machine:
    vagrant up && vagrant ssh

dev-env: start-database
    mprocs --config=mprocs.yaml

sqlcmd: 
    "$CONTAINER_RUNNER" exec -it "$PRIORI_DATABASE_NAME" \
        /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 \
        -U sa -P "$PRIORI_DATABASE_PASSWORD"

[windows]
setup-vagrant:
    vagrant plugin install vagrant-winnfsd

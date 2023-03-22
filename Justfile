default: dev-env

containers +options:
    just -f Containers.Justfile {{options}}

database +options:
    just -f Database.Justfile {{options}}

prod: (containers "build") (containers "create")

machine:
    vagrant up && vagrant ssh

dev-env: (database "start")
    mprocs --config=mprocs.yaml

sqlcmd: 
    "$CONTAINER_RUNNER" exec -it "$PRIORI_DATABASE_NAME" \
        /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 \
        -U sa -P "$PRIORI_DATABASE_PASSWORD"

default-env:
    cp -f ".env-template" ".env"

[windows]
setup-vagrant:
    vagrant plugin install vagrant-winnfsd

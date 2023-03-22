set dotenv-load
set ignore-comments
root_justfiles := "PRIORI_SERVICES_API/Justfile PRIORI_SERVICES_WEB/Justfile"

[private]
ignore-error +ACTION:
    -just {{ACTION}}

[private]
do-for-all +ACTION:
    for justfile in {{root_justfiles}} ; do \
        just -f "$justfile" {{ACTION}} ; \
    done

database +options:
    just -f Database.Justfile {{options}}

build: (do-for-all "container" "build") # Must be syncronous, or else the containers won't build

create: (do-for-all "container" "create") (database "create")

start: (ignore-error 'do-for-all "container" "start"') (database "start")

stop: (do-for-all "container" "stop")
    -"$CONTAINER_RUNNER" stop "$PRIORI_DATABASE_NAME"

cleanup: (ignore-error "stop") (ignore-error 'do-for-all "container" "cleanup"')
    -"$CONTAINER_RUNNER" rm "$PRIORI_DATABASE_NAME"

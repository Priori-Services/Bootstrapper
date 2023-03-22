set dotenv-load
set ignore-comments

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
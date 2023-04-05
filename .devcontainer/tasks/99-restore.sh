#!/bin/sh
for CSHARP_PROJ in $(find ./PRIORI-* -iname '*.csproj' -exec 'dirname' "{}" ';') ; do
    dotnet restore "$CSHARP_PROJ" &
done

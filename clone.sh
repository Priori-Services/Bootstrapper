#!/bin/sh
for REPO in PRIORI_SERVICES_WEB PRIORI_SERVICES_API PRIORI_SERVICES_DB ; do
    git clone "https://github.com/tulilirockz/${REPO}.git"
done

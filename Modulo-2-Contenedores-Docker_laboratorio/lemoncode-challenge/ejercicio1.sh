#!/bin/bash
#
# 
#
set -x
### VARIABLES
NETWORK="lemoncode-challenge"
MONGODB="some-mongo"
PORT_DB="27017" ## FOR TEST ONLY, DONT EXPOSE IN PRODUCTION
DBDATA="DBDATA"
BACKUPDBFILE="auxfiles/Topics.bson"
PATH_CONTEXT_BACKEND="backend/"
BACKEND="topics-api"
PORT_BACKEND="5000" ## FOR TEST ONLY, DONT EXPOSE IN PRODUCTION
PATH_CONTEXT_FRONTEND="frontend/"
FRONTEND="frontend-js"
PORT_FRONTEND_OUT="8080"
PORT_FRONTEND_IN="3000"
TESTAPI="http://localhost:8080"

echo
echo Ejercicio 1 - Modulo Contenedores - Lemoncode
echo
echo Levantando DB LAYER $MONGODB en puerto $PORT_DB en red $NETWORK
echo Levantando BACKEND LAYER $BACKEND en puerto $PORT_BACKEND en red $NETWORK
echo Levantando FRONTEND LAYER $FRONTEND en puertos $PORT_FRONTEND_OUT:$PORT_FRONTEND_IN en red $NETWORK
echo


# NETWORK LAYER
echo
echo Creando red $NETWORK...
echo
docker network create $NETWORK

# DB LAYER - DONT EXPOSE PORT ONLY VISIBLE IN PRIVATE NETWORK
echo
echo Levantando DB LAYER $MONGODB en puerto $PORT_DB en red $NETWORK...
echo
docker run -d --name $MONGODB --network $NETWORK --mount source=$DBDATA,target=/data/db mongo 

# POPULATE MONGODB
## mongoexport --db TopicstoreDb --collection Topics --out=/tmp/backupdb.json
## mongodump -o /tmp/
## mongorestore -db TopicstoreDb Topics.bson
echo 
echo Populando DB $MONGODB con DB TopicstoreDb Coleccion Topics...
echo
docker cp $BACKUPDBFILE $MONGODB:/tmp/
docker exec $MONGODB mongorestore --db TopicstoreDb /tmp/$BACKUPDBFILE

# BACKEND LAYER DONT EXPOSE PRIVATE NETWORK!
echo
echo Levantando BACKEND LAYER $BACKEND en puerto $PORT_BACKEND en red $NETWORK...
echo
cd $PATH_CONTEXT_BACKEND
docker build -t $BACKEND:latest .
docker run -d --name $BACKEND --network $NETWORK $BACKEND:latest
cd ..

# FRONTEND LAYER
echo
echo Levantando FRONTEND LAYER $FRONTEND en puertos $PORT_FRONTEND_OUT:$PORT_FRONTEND_IN en red $NETWORK...
echo
cd $PATH_CONTEXT_FRONTEND
docker build -t $FRONTEND:latest .
docker run -d --name $FRONTEND -p $PORT_FRONTEND_OUT:$PORT_FRONTEND_IN --network $NETWORK $FRONTEND:latest
cd ..

echo 
echo Realizando test...
echo
sleep 5 ### WITH THIS DELAY IM SURE SERVICE IS UP
HTTP_CODE=$(curl --write-out %{http_code} --silent --output /dev/null "$TESTAPI")
if [[ "$HTTP_CODE" -ne 200 ]] ; then
 echo "Fallo de conexion con la API"
else
 echo "Conexion satisfactoria"
 exit 0
fi
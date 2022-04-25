# README Laboratorio Módulo 2 Contenedores LEMONCODE
## Consideraciones:
1.- Puesto que se genera una red "lemoncode-challenge" para hospedar los microservicios, de manera explícita no se ha expuesto los puertos ni de la base de datos ni del backend, para que solo sea visibles por el frontend en el que evidentemente es el único que se ha expuesto hacia fuera.

2.- Por la misma razón, al no estar expuestos los servicios en esta red privada, he tenido que modificar los endpoints en código para que apunten a los nombres dns generados por docker que serán visibles dentro de la red. 
    - cambio: 'http://localhost:5000/api/topics' --> 'http://topics-api:5000/api/topics' (frontend/server.js)
    - cambio: "mongodb://localhost:27017" --> "mongodb://admin:lemoncode@some-mongo:27017" (backend/appsettings.json)

3.- Populo algunos registros en el mongo a través de mongorestore.

4.- Por ultimo hago un pequeño test con curl buscando simplemente un 200 en la conexión.

5.- Inicialmente el Dockerfile que me genera el IDE (vscode) para el frontend en node intentaba levantar node index.js y lo modifique por node server.js. (otra opción hubiera sido npm start)

6.- Al introducir la capa de usuario/password en la base de datos, desplegando por comandos todo funciona bien, incluso populando los registros, pero por docker-compose falla el despliegue (docker-compose también desplegaba bien antes de introducir usuario y pass en mongo.)

## Cómo desplegar
### EJERCICIO 1
Estando situados dentro de la carpeta de Módulo-2, simplemente dar permisos de ejecucion a ejercicio1.sh y ejecutarlo, está preparado para desplegarlo todo por nosotros.

### EJERCICIO 2
Estando situados dentro de la carpeta de Módulo-2:
    - Desplegar: docker-compose up
    - Parar: docker-compose stop
    - Parar y eliminar: docker compose down
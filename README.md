# Angular dockerized server
Es una imagen sobre alpine que contiene un servidor de docker que permite desplegar una app mientras se desarrolla y facilita la construcción y despliegue de la misma en el host.

## Opciones de entorno
Se ubican en el archivo .env
* **SERVE_PORT**. Es el puerto de nuestra máquina para mapearlo con el puerto 4200 de angular.
* **APP_NAME**. El nombre de la aplicación. Debe de coincidir con el nombre de la subcarpeta que contiene el proyecto.
* **PATH_SRC**. El path de los archivos dentro de la aplicación. Por defecto debería ser $APP\_NAME/src.
* **PATH_E2E**. El path de los archivos dentro de la aplicación. Por defecto debería ser $APP\_NAME/e2e.
* **PATH_BUILD**. El archivo donde se compilarán los archivos de angular.

Extras para proxy:
* **http_proxy**. Proxy de conexión HTTP. Debe de seguir el formato: `http://<user>:<password>@<host>:<port>/`
* **https_proxy**. Proxy de conexión HTTP. Debe de seguir el formato: `http://<user>:<password>@<host>:<port>/`
* **no_proxy**. Listado de IPS que no pasarían por el proxy (IPs internas)

## ¿Cómo usarla?

### Crear un proyecto desde 0

Queremos iniciar un nuevo proyecto desde 0, empezar 'desde scratch'.

1. Nos bajamos una copia de este proyecto: `git clone <repositorio_docker_angular> -d docker-example_project`.
2. Accedemos a la carpeta recién creada: `cd docker-example_project`.
3. Creamos con angular-cli el nuevo proyecto sin dependencias (Docker las instalará): `ng new project_name --skip-install`.
4. Configuramos las variables de entorno para que no haya solapamiento de puertos con otros proyectos, y para darle el nombre apropiado a la app (**APP_NAME**), y dónde se guardará el dist con los archivos compilados.
5. Lanzar el docker: `docker-compose up -d`.

### Usar un proyecto ya existente

Tenemos ya un proyecto de Angular creado en nuestro repositorio, llamemoslo `example_project` y queremos desarrollarlo con este docker. Los pasos a seguir serían:

1. Nos bajamos una copia de este proyecto: `git clone <repositorio_docker_angular> -d docker-example_project`.
2. Dentro de la carpeta recién creada, creamos el directorio app (`cd docker-example_project && mkdir app`)
3. En ese directorio recién creado, clonamos el proyecto `example_project`: `git clone <repositorio-example_project> -d docker-example_project`.
4. Configuramos las variables de entorno para que no haya solapamiento de puertos con otros proyectos, y para darle el nombre apropiado a la app (**APP_NAME**), y dónde se guardará el dist con los archivos compilados.
5. Lanzar el docker: `docker-compose up -d`.

### Compilar un proyecto.

Cuando hemos creado el docker, hemos puesto en `PATH_BUILD` la carpeta de nuestro hosts donde se nos crearán los archivos compilados en la construcción.

Para la simplificación del manejo de angular, se han creado varios scripts que nos simplifican el trabajo. Para llamarlos desde docker-compose, no hace falta ni entrar en la consola en modo interactivo, basta con hacer:

```docker-compose angular exec build[_prod]```

Para que compile los archivos y los lleve a la carpeta indicada por PATH_BUILD.

## Comandos de administración

* `docker-compose angular exec build`

Este comando compilará, usando `ng build --dev -dop=false`, el proyecto de angular y lo servirá en la carpeta `dist`, montada en el host local donde se le haya indicado

* `docker-compose angular exec build_prod`

Es igual que el comando anterior, pero usando la opción `--prod`, que minimizará los archivos generados.

* `docker-compose angular exec serve`

Este comando ejecutará la monitorización de los archivos a servir (por defecto lo hará también nuestro docker), usando `ng serve --dev -dop=false`.

* `docker-compose angular exec serve_prod`

Igual que el anterior comando, pero usando la opción de `--prod`

## TODO:

* Habilitar las pruebas de e2e. Se han encontrado problemas dado que Selenium requiere de chrome y de dependencias gráficas. Revisar el post de https://github.com/angular/angular-cli/issues/5019

## Referencias

* https://blogs.msmvps.com/theproblemsolver/2017/04/17/developing-angular-applications-using-docker/

* http://blog.teracy.com/2016/09/22/how-to-develop-angular-2-applications-easily-with-docker-and-angular-cli/


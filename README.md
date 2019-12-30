# Docker for PEGA Personal Edition

### Note: This project currently only supports Pega 8.3 personal edition (this might work with older verisons, but not guaranteed).

This project is intended to help PEGA enthusiasts deploy and experiment PEGA PRPC Personal Edition using docker. 

This project has been tested against Pega PRPC Personal Edition 8.3 version on a Manjaro 5.3.15 host OS. Those of you who intend to run this on a windows host might have to do some additonal setup in your docker installation to support linux images(these are easily searchable on the internet). These modifications are not specific to this project, but something that has to be done to run linux based docker images on Windows host OS.

"Pega PRPC Personal Edition" will be refered to as "PEGA-PE" for the sake of simplicity in rest of the project & documentation.

## Getting Started

Follow these instruction to setup PEGA-PE & backend Postgresql as docker containers.

### Prerequisites

You would need the following requisites to use this project

#### Hardware Requirements

Memory : 4 GB minimum / 8 GB preferred

Active internet connection with decent speed. Installation dowloads around 500-700MB of data - and will vary from machine to machine based on the packages already installed and how up-to-date the machine is.

Atleast 5-7 GB of free disk space [most of which will be consumed by postgresl container volume]

#### Software Requirement

Host OS should have docker & docker-compose installed. This can be installed easily using the instructions below:

[Install Docker](https://docs.docker.com/install/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

#### OS Requirement

Though the project is tested on an Ubuntu flavour, docker builds should work the same on most host operating systems. Windows users will have to make some additional modifications to the docker installation to support linux images.

#### Files

PEGA PRPC Personal Edition zip file downloaded from PEGA website
  * Pega.com > Support > Download Pega Software > [Download Personal Edition](https://community1.pega.com/digital-delivery)
  * Certain binaries from within this downloaded zip has to used to build & deploy PEGA-PE.


## Build Docker Image

This project only provides you with a Dockerfile which can be used to build an image for yourself. Since the build includes using propreitary files provided by Pegasystems, this images shouldn't be hosted on a public platform or distributed to others without prior consent from Pegasystems. 

### 1. Get the project

* Download / checkout this project to a suitable location in your hardrive and extract the contents. 

* Rest of the instructions below are w.r.t the current folder location.

### 2. Prepare for docker image build  of postgresql

* Extract the file pega.dump from PEGA-PE zip downloaded as mentioned in Files Prerequisite. For example, pega.dump can be located as **115148_PE_721.zip/data/pega.dump** in PEGA-PE 7.2.1. 

* Mention the location of pega.dump file in the file docker-compose.yml.

    ```yml
        volumes:
          - ${PEGA_DUMP}:/tmp/resources/  #substitue $  {PEGA_DUMP} with directory holding pega.dump file
    ```
    Instead of directly mentioning the location inside  docker-compose.yml, a neater way will be to use an   environment file. 
    Create a new file ".env" and add the location for   pega.dump inside "*.env"


    Content of .env file in my case is as below as i have   extracted pega.dump to /home/<user>/DockerBuild/  resources/pega.dump
    ```env
    PEGA_DUMP=/home/<user>/DockerBuild/resources/
    ```

* Pass username, password & db details to   docker-compose.yml file. These details will be used to    create the backend db, which will be used by PEGA-PE. 

    ```yml
    environment:
          - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  #   substitute .with db password
          - POSTGRES_USER=${POSTGRES_USER}  # substitute    with db user
          - POSTGRES_DB=${POSTGRES_DB}  # substitute with   db name
    ```

    again, the neater way will be to just include these     too in the .env file
    ```env
    POSTGRES_PASSWORD=postgres
    POSTGRES_USER=postgres
    POSTGRES_DB=postgres
    PEGA_DUMP=/home/<user>/DockerBuild/resources/
    ```
    
    **Important: Eventhough this project supports use of    any username & password, the base image provided by    Pegasystems has hardcoded username "postgres" inside   one of the sql scripts. Because of this the username  will have to be "postgres".**
    
    **Important: POSTGRES_DB value has be "postgres" because    the contents in pega.dump file are specific to     database postgres.**


### 3. Prepare for docker image build  of pega web app

* Extract the files prweb.war, prhelp.war from PEGA-PE zip downloaded as mentioned in Files Prerequisite. For example, these files can be located as **115148_PE_721.zip/PRPC_PE.jar/PersonalEdition.zip/tomcat/webapps** in PEGA-PE 7.2.1. 

* Place the files extracted on the previous step to **Project_Root/PegaPRPC-WebApp/resources**

* Download the jdbc driver from [here](https://jdbc.postgresql.org/download/postgresql-42.1.1.jre7.jar) and place in **Project_Root/PegaPRPC-WebApp/resources/jdbc_drivers**

### 4. Build docker images for postgresql & pega web app

* Run the below command to build the docker images for both postgresql & pega web app

    ```bash
    docker-compose build --no-cache
    ```
    This command will take some time to build the images based on your internet connection speed and your hardware specs. First time run will download  the required base images from internet. 

* Start **only postgresql container** because it on     the first run that databases are created and pega.dump  is restored back to postgresql

    ```bash
    docker-compose up postgresql-pega-backend
    ```
    This again will run for around 5-10mins. Make sure  that the default drive used by docker has atleast 5GB    of free space, as this step will restore pega.dump to  postgresql. 

    **Important: this image uses mount volume in the base image. Hence eventhough the volumes are not explicitly mentioned in docker-compose.yml, the data is persisted between restarts**

* Once the restore is complete, shutdown the docker instance by doing a Ctrl+C on the same terminal window that is running the docker instance or issuing the below command from a different terminal window
    ```bash
    docker-compose down postgresql-pega-backend
    ```

## Start & Stop docker containers
1. Issue the below command to start both pega web app & postgresql and send to background
    ```bash
    docker-compose up -d
    ```
2. Issue the below command to stop both pega web app & postgresql
    ```bash
    docker-compose stop
    ```

## Additional command references
If you have to re-build the image for postgresql with modified Dockerfile, you might notice that the stale image built previously is being picked again and again. 

To force re-creating the container again use
```bash
docker-compose up --force-recreate postgresql-pega-backend
```

To remove all unused images use
```bash
docker system prune
```

To remove all unused volumes use the below. You will notice that multiple build & run will fill up your harddisk very fast. This is because of the approx.5GB volumes consumed by each build.

```bash
docker volume prune
```

## Authors

* **Kannan Raveendran Nair** - *Initial work* - [kannan-raveendran-nair](https://github.com/kannan-raveendran-nair)

See also the list of [contributors](https://github.com/kannan-raveendran-nair/prpc-pe-linux/contributors) who participated in this project.

## License

This project is licensed under [Attribution-NonCommercial 4.0 International](https://creativecommons.org/licenses/by-nc/4.0/). You are free to copy, modify & redistribute this code for non-commercial purposes.

Use of Pega Personal Edition itself is licensed by Pegasystems and licensing details can be found in the zip file downloaded in Prerequisites/Files
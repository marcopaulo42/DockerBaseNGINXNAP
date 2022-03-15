# Create Base Docker NGINX Plus with NAP deployment

## Docker Deployment Instructions 

This deployment is based on the instructions detailed at https://docs.nginx.com/nginx-app-protect/admin-guide/install/

specifically the section *"Docker-deployment-instructions"*.

These commands are run on the local host, assuming here Ubuntu.




## Step 1: Create Dockerfile

Create `Dockerfile` similar to **[NGINX Plus Dockerfile (Debian 11)](./Dockerfile)**

Which  exposes port 80 on the Container.








## Step 1: Build NGINX Plus Image

Copy the files to the directory where the Dockerfile is located.
Log in to the Customer Portal and download the following two files:

`nginx-repo.key`
`nginx-repo.crt`


In the same directory create an `entrypoint.sh` file with executable permissions, and the following content (replace bash with sh for Alpine):

```
#!/usr/bin/env bash

/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 >> /var/log/app_protect/bd-socket-plugin.log &" nginx
/usr/sbin/nginx -g 'daemon off;'
```



## Step x: Create Docker Image

Run command

`sudo DOCKER_BUILDKIT=1 docker build --no-cache -t nginxnap --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key .`



The `DOCKER_BUILDKIT=1` enables `docker build` to recognize the `--secret` flag which allows the user to pass secret information to be used in the Dockerfile for building docker images in a safe way that will not end up stored in the final image. This is a recommended practice for the handling of the certificate and private key for NGINX repository access (`nginx-repo.crt` and `nginx-repo.key` files).

The --no-cache option tells Docker to build the image from scratch and ensures the installation of the latest version of NGINX Plus and NGINX App Protect WAF. If the Dockerfile was previously used to build an image without the --no-cache option, the new image uses versions from the previously built image from the Docker cache.


This role has multiple template related variables. The descriptions and defaults for all these variables can be found in **[vars/main.yml](./vars/main.yml)**

## Step x: Run Docker Image



This command runs precreated image, but maps localhost directory /home/ubuntu/dockerbuildstuff/conf to container /etc/nginx/conf.d directory

`sudo docker run -v /home/ubuntu/dockerbuildstuff/conf:/etc/nginx/conf.d --name mynginxplus -dp 80:80 nginxplus`









# Create Base Docker NGINX Plus deployment

## Docker Deployment Instructions 

This deployment is based on the instructions detailed at https://www.nginx.com/blog/deploying-nginx-nginx-plus-docker/
specifically the section *"Deploying NGINX Plus with Docker"*.

These commands are run on the local host, assuming here Ubuntu.

## Step 1: Create Dockerfile

Create `Dockerfile` similar to **[NGINX Plus Dockerfile (Debian 11)](./Dockerfile)**

Which  exposes port 80 on the Container.


## Step 2: Build NGINX Plus Image

With the `Dockerfile`, `nginx-repo.crt`, and `nginx-repo.key` files in the same directory, run the following command there to create a Docker image called `nginxplus` (as before, note the final period):

```# DOCKER_BUILDKIT=1 docker build --no-cache -t nginxplus --secret id=nginx-crt,src=</path/to/your/nginx-repo.crt> --secret id=nginx-key,src=</path/to/your/nginx-repo.key> .```

for example:

``# sudo DOCKER_BUILDKIT=1 docker build --no-cache -t nginxplus --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key .``


The `DOCKER_BUILDKIT=1` flag indicates that we are using Docker BuildKit to build the image, as required when including the `--secret` option.

The `--no-cache` option tells Docker to build the image from scratch and ensures the installation of the latest version of NGINX Plus. If the `Dockerfile` was previously used to build an image and you do not include the `--no-cache option`, the new image uses the version of NGINX Plus from the Docker cache. (As noted, we purposely do not specify an NGINX Plus version in the Dockerfile so that the file does not need to change at every new release of NGINX Plus.) Omit the `--no-cache` option if it’s acceptable to use the NGINX Plus version from the previously built image.

The `--secret` option passes the certificate and key for your NGINX Plus license to the Docker build context without risking exposing the data or having the data persist between Docker build layers. The values of the id arguments cannot be changed without altering the base `Dockerfile`, but you need to set the src arguments to the path to your NGINX Plus certificate and key files (the same directory where you are building the Docker image if you followed the previous instructions).

## Sep 3: Verify Creation of Docker Image

Run command `# sudo docker images` to ensure that the image was created successfuly.

## Step 4: Create Docker Container

### Docker Container on port 80
Using the following commands to create the Docker Container:

`# sudo docker run --name mynginxplus -p 80:80 -d nginxplus`

where **x** is host, and **y** is the container for the - p option **x:y**

Once created, the default `nginx.conf` and `default.conf` files are deployed.

### Docker Container on port 80 with directory mapping

The following command creates and runs the Container and maps the localhost directory for example: `/home/ubuntu/dockerbuildstuff/conf` to the Container directory `/etc/ninx/conf.d`, and can be used to update the config files in the container through the mapping instead of directly in the Container.

`# sudo docker run -v /home/ubuntu/dockerbuildstuff/conf:/etc/nginx/conf.d --name mynginxplus -dp 80:80 nginxplus`

Once created, the default `nginx.conf` file is deployed along with any other `*.conf` files in the mapped directory, for example, **[default.conf](./default.conf)**.


## Extra

### To log into the running Docker Container 

On the localhost, run command: 
`# sudo docker exec -it mynginxplus /bin/bash`

### Verify running NGINX Container

On the localhost, run command:
`# curl localhost`
 
to obtain reply including `Welcome to nginx!`

### Usefull Docker commands
`# sudo docker ps -a`

`# sudo docker images`

`# sudo docker stop <Container Name>`

`# sudo docker start <Container Name>`

`# sudo docker rm <Container Name>`

`# sudo docker image rm <Docker Image Name>`











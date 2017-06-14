# Docker-based ONOS Distributed tutorial

## Requirements

* packer
* terraform
* Properly configured aws credentials (use `aws credentials` to contfigure)

These packages can be obtained from homebrew or whatever you package management
of choice is.

## What does this do?

This repo will build an ONOS Distributed Tutorial VM containing four containers
(three onos, one mininet) on EC2 and output one or more AMIs in each desired
region.

The ONOS containers are already clustered so no extra configuration is required.
The mininet switches are also pointing to all the onos containers. All the
containers are set to auto restart, so killing one containers will have no
significant disruptive effect.

This repo is structured as follows:

* **build**: The packer files contained in the build subdirectory will build
desired AMIs and provide the AMI id as output.
* **deploy**: The terraform files contained in the deploy subdirectory will
deploy the created AMIs in the desired region.

# Build Process

The contents of build/variables.json contains all the configuration (with
default values) to use for the build out of the AMI.

## Build configuration

```
  {
    "_comment": "Which onos version to use, see docker tags for reference",
    "onos_version" : "1.10.0",
    "_comment": "Where to perform the build",
    "region" : "us-west-1",
    "_comment": "What type of instance to use for the build",
    "instance_type" : "m4.xlarge",
    "_comment": "Use the below to bid for spot pricing, but make sure you instance_type supports spot pricing",
    "spot_price" : "0",
    "spot_price_auto_product" : "Linux/UNIX (Amazon VPC)",
    "_comment": "Replace with your vpc and subnet id below if you are using a VPC-only instance other leave it blank.",
    "default_vpc" : "<vpc_id>",
    "default_subnet" : "<subnet_id>",
    "default_ami_name" : "*ubuntu-xenial-16.04-amd64-server-*",
    "default_user" : "ubuntu",
    "_comment": "Which regions to copy the AMI to",
    "default_ami_regions" : "eu-central-1"
  }
```


## Build it!

```
  $ cd build
  $ packer build -var-file="variables.json" onos-ec2-vm.json
```

## Resulting output

```
  ...
  eu-central-1: <some_ami_id>
  us-west-1: <some_other_ami_id>
```

Use these AMI ids in the terraform configuration.

# Deploy Process

The contents of deploy/variables.tf contains all the configuration for a
deployment. It creates all the necessary EC2 infrastructure for deploying
the AMI correctly.

## Notable configuration items

* **instances_to_start**: Number of instances to start. Terraform will compute the difference between existing and desired instances and either start more or teardown a few.
* **profile**: AWS profile to use. Leave blank if default creds should be used.
* **ubuntu_amis**: Which AMIs to launch. Typically these will be the output of the packer step.
* **public_key**: Put your public key here. This will allow the Tutorial instructor to log in to the machine to inspect it if need be.

## Deploy it!

```
  $ cd deploy
  $ terraform apply
```

Have fun with this by changing the `instances_to_start` variables and re-running `terraform apply`.

## Resulting output

```
  Outputs:

  public_ips = [
    52.53.232.69,
    54.67.126.145
  ]
```

# Usage

Once deployed you can connect do the docker host by exporting the DOCKER_HOST variable as shown below:

```
  export DOCKER_HOST="tcp://<AWS_IP>:2375"
```

## docker ps

You can now run `docker ps` and see the following:

```
  iBeast:build ash$ docker ps

  CONTAINER ID        IMAGE                     COMMAND                 CREATED             STATUS         PORTS                                                                                        NAMES
  5a32983a9e8f        alshabib/mininet          "/docker-entry-point"   9 hours ago         Up 2 minutes                                                                                                     mininet
  9399daea8f17        onosproject/onos:1.10.0   "./bin/onos-service"    9 hours ago         Up 2 minutes        0.0.0.0:6653->6653/tcp, 0.0.0.0:8101->8101/tcp, 6640/tcp, 9876/tcp, 0.0.0.0:8181->8181/tcp   onos1
  0ceff76fb228        onosproject/onos:1.10.0   "./bin/onos-service"    9 hours ago         Up 2 minutes        6640/tcp, 9876/tcp, 0.0.0.0:6655->6653/tcp, 0.0.0.0:8103->8101/tcp, 0.0.0.0:8183->8181/tcp   onos3
  2f38427c4280        onosproject/onos:1.10.0   "./bin/onos-service"    9 hours ago         Up 2 minutes        6640/tcp, 9876/tcp, 0.0.0.0:6654->6653/tcp, 0.0.0.0:8102->8101/tcp, 0.0.0.0:8182->8181/tcp   onos2
```

## Attach to mininet

```
  $ docker attach mininet
```

## Installing an ONOS application

```
  $ onos-app <AWS_IP> install target/foo-app-1.0-SNAPSHOT.oar
```

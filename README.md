# Automation to Provision a Full-Stack Application for any Environment

This deploys a full-stack application into a Kubernetes cluster, provisioned using Terraform. The application components include a frontend, backend, and database. This supports deployment into multiple environments by adding a terraform variable configuration file for the target environment.

The following AWS Resources are provisioned:
- VPC
- EKS with Self-Managed NodeGroups running Ubuntu 20
- KMS Key to encrypt ETCD

## Approaches

I had two options in mind when implementing this solution.

### Solution 1

Deploy the following components

- VPC
- AutoScaling Groups
- Application Load Balancer

This original design involves creating a userdata that will install the application and dependencies on the server as deploy time. The server are created in an autoscaling group with a load balancer routing traffic to the server. 

The shortcomings of this approach include:
- Time taken to deploy the application will significantly increase because application and dependencies are installed at deploy time. A workaround is to pre-bake an AMI and pass the configuration settings for the given environment at deployment. 
- Changes in any application dependency can cause the application to fail at deploy time. A workaround is to pin all the dependencies versions.
- Increase cost of operation since we are going to be deploying an application per server to avoid resource and dependency contentions

### Solution 2

Deploy the following components

- VPC
- EKS Cluster

I decided to go with a containerized approached to ensure repeatability of the deployment process while being insulated from changes to the underlying application dependencies. This also optimizes the use of the underlying compute infrastructure since the nodes are shared between applications.

## Trade-Offs

There are some lapses in my overall implementaion, listed below. These are cost trade-offs for the challenge

* No TLS to the frontend, between the frontend, backend and database was implemented
* No domain was registered for the frontend
* Database storage was configured to use the Host Volume instead of an independent, reliable, easy to backup/replicate storage
* No CIS Benchmarks were adhered to for the Node OS (Ubuntu) and the Kubernetes cluster

## Application Components

The following application components are provisioned via this script

* Nginx Frontend Proxy
* ReactJS + Redux Frontend Application
* Express + Bookshelf Backend Application
* Postgres Database 

## Provisioning Instructions

### Step 1: Prerequisties
* [Install awscli](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) AWS Credentials into environment.

```bash
$ export AWS_ACCESS_KEY_ID="your_access_key"
$ export AWS_SECRET_ACCESS_KEY="your_secret_key"
$ export AWS_DEFAULT_REGION="your_region"
```

* [Install terraform](https://www.terraform.io/downloads.html)
* For Windows Users [Install Git-Bash](https://git-scm.com/downloads) and run deployment command from Git-Bash Shell


### Step 2: Deployment Instructions
* Run Deployment Script for Development environment
```bash
$ terraform init
$ terraform plan -var-file=dev.tfvars
$ terraform apply  -var-file=dev.tfvars
```

The entire bootstrap process should take approximately 10 - 20 minutes and provisions the whole infrastructure and deploys the full-stack application. After all the bootstrap scripts are run, the following information will be outputed to the console:
- Frontend Application URL

### Step 3: Teardown Instructions
* Tear down infrastructure by running command below locally
```bash
$ terraform destroy -var-file=dev.tfvars
```

## Infrastructure description with a hierarchy of core technologies

These are the major technologies employed:
- Container Orchestration: Elastic Kubernetes Service
- Cloud Infrastructure: Amazon Web Services
- Infrastructure as Code: Terraform
- Overall Deployment Script: Bash
- Database: Postgres 10
- UI development: React+Redux
- REST APIs and Microservices: Express+Bookshelf

## Summary of Resources Provisioned

The following resources are provisioned in the repository

* VPC and Subnets using [terraform module](./modules/vpc)
* KMS Keys using [kms module](./modules/kms)
* EKS using [eks module](./modules/eks)
* K8s Manifests using [k8s manifest module](./modules/manifest)

## References

- Frontend Application - https://github.com/khaledosman/react-redux-realworld-example-app
- Backend Application - https://github.com/tanem/express-bookshelf-realworld-example-app
- EKS Module - https://github.com/terraform-aws-modules/terraform-aws-eks
- AWS Load Balancer Controller Installation - https://github.com/Young-ook/terraform-aws-eks/tree/main/modules/lb-controller

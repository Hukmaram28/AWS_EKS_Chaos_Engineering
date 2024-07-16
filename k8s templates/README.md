# Overview

This folder is intended for practice purposes. It contains essential Kubernetes resource templates for web and API microservices, along with a MySQL deployment.

## Kubernetes Resources

This setup creates the following Kubernetes resources:

- **Persistent Volume Claim**: Used to persist the MySQL database.
- **Secrets Template**: Contains database secrets.
- **ConfigMap**: Contains the database name.
- **NodePort Service for MySQL**: Allows access to the database by the API microservice and for external access in the local environment for testing.
- **MySQL Deployment Template**: For deploying the MySQL containers.
- **NodePort Service and Deployment Template for API Microservice**: For deploying and accessing the API microservice.
- **NodePort Service and Deployment Template for Web Microservice**: For deploying and accessing the web microservice.


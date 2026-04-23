# employee-mgmt-terraform-docker
Full-stack Employee Management System: Frontend, Python Flask Backend, and Terraform configuration for automated Docker orchestration.

# Follow the steps below to deploy the full stack (Flask + PostgreSQL).

1. Prerequisites
Ensure you have the following installed on your local environment:

* **Docker Desktop** (Ensuring the Docker Engine is running)
* **Terraform** (v1.0+)
* **Git**

2. Clone the Repository
```bash
git clone [https://github.com/Jaqliyne-Wambui/employee-mgmt-terraform-docker.git](https://github.com/Jaqliyne-Wambui/employee-mgmt-terraform-docker.git)
cd employee-mgmt-terraform-docker
Initialize Terraform
Before deploying, you must initialize the working directory to download the required Docker provider:

Bash
cd terraform
terraform init
Deploy the Infrastructure
Terraform will automatically build the Docker images from the source code, create the network, and start the containers in the correct order:

Bash
terraform apply -auto-approve
Accessing the Application
Once the resources are created, the application will be available at the following local endpoints:

Frontend: http://localhost:80

Backend API: http://localhost:5000

Cleanup
To destroy the infrastructure and stop all running containers:

Bash
terraform destroy -auto-approve
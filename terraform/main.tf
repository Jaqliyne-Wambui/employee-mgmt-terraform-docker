terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# 1. Network so containers can talk to each other
resource "docker_network" "employee_network" {
  name = "employee-network"
}

# 2. Persistent volume for database data
resource "docker_volume" "postgres_data" {
  name = "employee-postgres-data"
}

# 3. PostgreSQL Database Container
resource "docker_image" "postgres" {
  name         = "postgres:13"
  keep_locally = false
}

resource "docker_container" "postgres" {
  name  = "employee-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  volumes {
    container_path = "/var/lib/postgresql/data"
    volume_name    = docker_volume.postgres_data.name
  }

  networks_advanced {
    name = docker_network.employee_network.name
  }
}

# 4. Flask Backend Container
resource "docker_image" "backend" {
  name         = "employee-backend:latest"
  keep_locally = true

  build {
    # Path corrected to look inside your current sub-folder
    context = "../app/backend"
  }
}

resource "docker_container" "backend" {
  name  = "employee-backend"
  image = docker_image.backend.image_id

  env = [
    "DATABASE_URL=postgresql://${var.db_user}:${var.db_password}@employee-postgres:5432/${var.db_name}"
  ]

  ports {
    internal = 5000
    external = 5000
  }

  networks_advanced {
    name = docker_network.employee_network.name
  }

  depends_on = [docker_container.postgres]
}

# 5. Frontend Container
resource "docker_image" "frontend" {
  name         = "employee-frontend:latest"
  keep_locally = true

  build {
    # Path corrected to look inside your current sub-folder
    context = "../app/frontend"
  }
}

resource "docker_container" "frontend" {
  name  = "employee-frontend"
  image = docker_image.frontend.image_id

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.employee_network.name
  }

  depends_on = [docker_container.backend]
}
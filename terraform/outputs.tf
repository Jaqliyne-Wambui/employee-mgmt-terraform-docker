output "frontend_url" {
  value       = "http://localhost:8080"
  description = "URL to access the employee app"
}

output "backend_url" {
  value       = "http://localhost:5000"
  description = "URL to access the Flask API"
}

output "postgres_port" {
  value       = "5432"
  description = "PostgreSQL port"
}
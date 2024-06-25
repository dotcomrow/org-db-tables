resource "google_bigquery_table" "reset_password_token" {
  dataset_id = var.dataset_id
  table_id   = "reset_password_token"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "reset_password_token_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "customer_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "token",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP()",
    "mode": "REQUIRED",
    "name": "created_at",
    "type": "TIMESTAMP"
  }
]
EOF
}
resource "google_bigquery_table" "migration" {
  dataset_id = var.dataset_id
  table_id   = "migration"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "migration_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "module",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "version",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "created_at",
    "type": "TIMESTAMP"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "updated_at",
    "type": "TIMESTAMP"
  }
]
EOF
}
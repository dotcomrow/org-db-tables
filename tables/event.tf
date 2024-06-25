resource "google_bigquery_table" "event" {
  dataset_id = var.dataset_id
  table_id   = "event"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "event_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "name",
    "type": "STRING"
  },
  {
    "name": "data",
    "type": "JSON"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "created_at",
    "type": "TIMESTAMP"
  }
]
EOF
}
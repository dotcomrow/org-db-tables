resource "google_bigquery_table" "url_rewrite" {
  dataset_id = var.dataset_id
  table_id   = "url_rewrite"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "url_rewrite_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "'en'",
    "mode": "REQUIRED",
    "name": "language",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "request_path",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "target_path",
    "type": "STRING"
  },
  {
    "name": "entity_uuid",
    "type": "STRING"
  },
  {
    "name": "entity_type",
    "type": "STRING"
  }
]
EOF
}
resource "google_bigquery_table" "setting" {
  dataset_id = var.dataset_id
  table_id   = "setting"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "setting_id",
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
    "name": "value",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "is_json",
    "type": "BOOLEAN"
  }
]
EOF
}
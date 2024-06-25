resource "google_bigquery_table" "attribute_option" {
  dataset_id = var.dataset_id
  table_id   = "attribute_option"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "attribute_option_id",
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
    "name": "attribute_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "attribute_code",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "option_text",
    "type": "STRING"
  }
]
EOF
}
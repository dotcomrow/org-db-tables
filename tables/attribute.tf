resource "google_bigquery_table" "attribute" {
  dataset_id = var.dataset_id
  table_id   = "attribute"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "attribute_id",
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
    "name": "attribute_code",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "attribute_name",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "type",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "is_required",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "display_on_frontend",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "0",
    "mode": "REQUIRED",
    "name": "sort_order",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "is_filterable",
    "type": "BOOLEAN"
  }
]
EOF
}
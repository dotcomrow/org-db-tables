resource "google_bigquery_table" "product_custom_option" {
  dataset_id = var.dataset_id
  table_id   = "product_custom_option"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_custom_option_id",
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
    "name": "product_custom_option_product_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "option_name",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "option_type",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "is_required",
    "type": "BOOLEAN"
  },
  {
    "name": "sort_order",
    "type": "INTEGER"
  }
]
EOF
}
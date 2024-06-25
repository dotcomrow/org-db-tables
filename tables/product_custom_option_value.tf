resource "google_bigquery_table" "product_custom_option_value" {
  dataset_id = var.dataset_id
  table_id   = "product_custom_option_value"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_custom_option_value_id",
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
    "name": "option_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "extra_price",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "sort_order",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "value",
    "type": "STRING"
  }
]
EOF
}
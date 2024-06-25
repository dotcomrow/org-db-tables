resource "google_bigquery_table" "shipping_zone_method" {
  dataset_id = var.dataset_id
  table_id   = "shipping_zone_method"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "shipping_zone_method_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "method_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "zone_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "true",
    "mode": "REQUIRED",
    "name": "is_enabled",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "cost",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "calculate_api",
    "type": "STRING"
  },
  {
    "name": "condition_type",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "max",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "min",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  }
]
EOF
}
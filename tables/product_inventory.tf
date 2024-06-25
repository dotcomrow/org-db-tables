resource "google_bigquery_table" "product_inventory" {
  dataset_id = var.dataset_id
  table_id   = "product_inventory"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_inventory_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_inventory_product_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "0",
    "mode": "REQUIRED",
    "name": "qty",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "manage_stock",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "stock_availability",
    "type": "BOOLEAN"
  }
]
EOF
}
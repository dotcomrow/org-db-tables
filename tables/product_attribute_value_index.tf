resource "google_bigquery_table" "product_attribute_value_index" {
  dataset_id = var.dataset_id
  table_id   = "product_attribute_value_index"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_attribute_value_index_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "attribute_id",
    "type": "INTEGER"
  },
  {
    "name": "option_id",
    "type": "INTEGER"
  },
  {
    "name": "option_text",
    "type": "STRING"
  }
]
EOF
}
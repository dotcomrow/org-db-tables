resource "google_bigquery_table" "product_collection" {
  dataset_id = var.dataset_id
  table_id   = "product_collection"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_collection_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "collection_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_id",
    "type": "INTEGER"
  }
]
EOF
}
resource "google_bigquery_table" "product_description" {
  dataset_id = var.dataset_id
  table_id   = "product_description"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_description_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_description_product_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "name",
    "type": "STRING"
  },
  {
    "name": "description",
    "type": "STRING"
  },
  {
    "name": "short_description",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "url_key",
    "type": "STRING"
  },
  {
    "name": "meta_title",
    "type": "STRING"
  },
  {
    "name": "meta_description",
    "type": "STRING"
  },
  {
    "name": "meta_keywords",
    "type": "STRING"
  }
]
EOF
}
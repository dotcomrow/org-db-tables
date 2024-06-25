resource "google_bigquery_table" "product_image" {
  dataset_id = var.dataset_id
  table_id   = "product_image"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_image_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_image_product_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "origin_image",
    "type": "STRING"
  },
  {
    "name": "thumb_image",
    "type": "STRING"
  },
  {
    "name": "listing_image",
    "type": "STRING"
  },
  {
    "name": "single_image",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "name": "is_main",
    "type": "BOOLEAN"
  }
]
EOF
}
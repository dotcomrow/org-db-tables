resource "google_bigquery_table" "category_description" {
  dataset_id = var.dataset_id
  table_id   = "category_description"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "category_description_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "category_description_category_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "name",
    "type": "STRING"
  },
  {
    "name": "short_description",
    "type": "STRING"
  },
  {
    "name": "description",
    "type": "STRING"
  },
  {
    "name": "image",
    "type": "STRING"
  },
  {
    "name": "meta_title",
    "type": "STRING"
  },
  {
    "name": "meta_keywords",
    "type": "STRING"
  },
  {
    "name": "meta_description",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "url_key",
    "type": "STRING"
  }
]
EOF
}
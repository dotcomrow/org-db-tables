resource "google_bigquery_table" "cms_page_description" {
  dataset_id = var.dataset_id
  table_id   = "cms_page_description"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "cms_page_description_id",
    "type": "INTEGER"
  },
  {
    "name": "cms_page_description_cms_page_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "url_key",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "name",
    "type": "STRING"
  },
  {
    "name": "content",
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
  }
]
EOF
}
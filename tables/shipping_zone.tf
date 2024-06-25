resource "google_bigquery_table" "shipping_zone" {
  dataset_id = var.dataset_id
  table_id   = "shipping_zone"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "shipping_zone_id",
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
    "name": "name",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "country",
    "type": "STRING"
  }
]
EOF
}
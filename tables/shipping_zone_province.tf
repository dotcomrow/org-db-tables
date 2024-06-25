resource "google_bigquery_table" "shipping_zone_province" {
  dataset_id = var.dataset_id
  table_id   = "shipping_zone_province"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "shipping_zone_province_id",
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
    "name": "zone_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "province",
    "type": "STRING"
  }
]
EOF
}
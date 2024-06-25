resource "google_bigquery_table" "cart_address" {
  dataset_id = var.dataset_id
  table_id   = "cart_address"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "cart_address_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "name": "full_name",
    "type": "STRING"
  },
  {
    "name": "postcode",
    "type": "STRING"
  },
  {
    "name": "telephone",
    "type": "STRING"
  },
  {
    "name": "country",
    "type": "STRING"
  },
  {
    "name": "province",
    "type": "STRING"
  },
  {
    "name": "city",
    "type": "STRING"
  },
  {
    "name": "address_1",
    "type": "STRING"
  },
  {
    "name": "address_2",
    "type": "STRING"
  }
]
EOF
}
resource "google_bigquery_table" "customer_address" {
  dataset_id = var.dataset_id
  table_id   = "customer_address"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "customer_address_id",
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
    "name": "customer_id",
    "type": "INTEGER"
  },
  {
    "name": "full_name",
    "type": "STRING"
  },
  {
    "name": "telephone",
    "type": "STRING"
  },
  {
    "name": "address_1",
    "type": "STRING"
  },
  {
    "name": "address_2",
    "type": "STRING"
  },
  {
    "name": "postcode",
    "type": "STRING"
  },
  {
    "name": "city",
    "type": "STRING"
  },
  {
    "name": "province",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "country",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "created_at",
    "type": "TIMESTAMP"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "updated_at",
    "type": "TIMESTAMP"
  },
  {
    "name": "is_default",
    "type": "INTEGER"
  }
]
EOF
}
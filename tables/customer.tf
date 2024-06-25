resource "google_bigquery_table" "customer" {
  dataset_id = var.dataset_id
  table_id   = "customer"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "customer_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "1",
    "mode": "REQUIRED",
    "name": "status",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "1",
    "name": "group_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "email",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "password",
    "type": "STRING"
  },
  {
    "name": "full_name",
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
  }
]
EOF
}
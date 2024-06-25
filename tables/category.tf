resource "google_bigquery_table" "category" {
  dataset_id = var.dataset_id
  table_id   = "category"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "category_id",
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
    "name": "status",
    "type": "BOOLEAN"
  },
  {
    "name": "parent_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "include_in_nav",
    "type": "BOOLEAN"
  },
  {
    "name": "position",
    "type": "INTEGER"
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
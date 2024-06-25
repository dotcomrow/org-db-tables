resource "google_bigquery_table" "order_activity" {
  dataset_id = var.dataset_id
  table_id   = "order_activity"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "order_activity_id",
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
    "name": "order_activity_order_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "comment",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "customer_notified",
    "type": "BOOLEAN"
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
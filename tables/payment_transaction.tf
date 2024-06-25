resource "google_bigquery_table" "payment_transaction" {
  dataset_id = var.dataset_id
  table_id   = "payment_transaction"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "payment_transaction_id",
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
    "name": "payment_transaction_order_id",
    "type": "INTEGER"
  },
  {
    "name": "transaction_id",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "transaction_type",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "amount",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "parent_transaction_id",
    "type": "STRING"
  },
  {
    "name": "payment_action",
    "type": "STRING"
  },
  {
    "name": "additional_information",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "CURRENT_TIMESTAMP",
    "name": "created_at",
    "type": "TIMESTAMP"
  }
]
EOF
}
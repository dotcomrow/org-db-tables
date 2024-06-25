resource "google_bigquery_table" "shipment" {
  dataset_id = var.dataset_id
  table_id   = "shipment"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "shipment_id",
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
    "name": "shipment_order_id",
    "type": "INTEGER"
  },
  {
    "name": "carrier",
    "type": "STRING"
  },
  {
    "name": "tracking_number",
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
resource "google_bigquery_table" "coupon" {
  dataset_id = var.dataset_id
  table_id   = "coupon"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "coupon_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "true",
    "mode": "REQUIRED",
    "name": "status",
    "type": "BOOLEAN"
  },
  {
    "mode": "REQUIRED",
    "name": "description",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "discount_amount",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "free_shipping",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "'1'",
    "mode": "REQUIRED",
    "name": "discount_type",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "coupon",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "0",
    "mode": "REQUIRED",
    "name": "used_time",
    "type": "INTEGER"
  },
  {
    "name": "target_products",
    "type": "JSON"
  },
  {
    "name": "condition",
    "type": "JSON"
  },
  {
    "name": "user_condition",
    "type": "JSON"
  },
  {
    "name": "buyx_gety",
    "type": "JSON"
  },
  {
    "name": "max_uses_time_per_coupon",
    "type": "INTEGER"
  },
  {
    "name": "max_uses_time_per_customer",
    "type": "INTEGER"
  },
  {
    "name": "start_date",
    "type": "TIMESTAMP"
  },
  {
    "name": "end_date",
    "type": "TIMESTAMP"
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
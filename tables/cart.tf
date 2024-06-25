resource "google_bigquery_table" "cart" {
  dataset_id = var.dataset_id
  table_id   = "cart"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "cart_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "name": "sid",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "currency",
    "type": "STRING"
  },
  {
    "name": "customer_id",
    "type": "INTEGER"
  },
  {
    "name": "customer_group_id",
    "type": "INTEGER"
  },
  {
    "name": "customer_email",
    "type": "STRING"
  },
  {
    "name": "customer_full_name",
    "type": "STRING"
  },
  {
    "name": "user_ip",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "status",
    "type": "BOOLEAN"
  },
  {
    "name": "coupon",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "shipping_fee_excl_tax",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "shipping_fee_incl_tax",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "discount_amount",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "sub_total",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "sub_total_incl_tax",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "total_qty",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "total_weight",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "tax_amount",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "grand_total",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "shipping_method",
    "type": "STRING"
  },
  {
    "name": "shipping_method_name",
    "type": "STRING"
  },
  {
    "name": "shipping_zone_id",
    "type": "INTEGER"
  },
  {
    "name": "shipping_address_id",
    "type": "INTEGER"
  },
  {
    "name": "payment_method",
    "type": "STRING"
  },
  {
    "name": "payment_method_name",
    "type": "STRING"
  },
  {
    "name": "billing_address_id",
    "type": "INTEGER"
  },
  {
    "name": "shipping_note",
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
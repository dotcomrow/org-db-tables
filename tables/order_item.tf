resource "google_bigquery_table" "order_item" {
  dataset_id = var.dataset_id
  table_id   = "order_item"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "order_item_id",
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
    "name": "order_item_order_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_id",
    "type": "INTEGER"
  },
  {
    "name": "referer",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "product_sku",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "product_name",
    "type": "STRING"
  },
  {
    "name": "thumbnail",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "product_weight",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "product_price",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "product_price_incl_tax",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "qty",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "final_price",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "final_price_incl_tax",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "mode": "REQUIRED",
    "name": "tax_percent",
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
    "name": "total",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "variant_group_id",
    "type": "INTEGER"
  },
  {
    "name": "variant_options",
    "type": "STRING"
  },
  {
    "name": "product_custom_options",
    "type": "STRING"
  },
  {
    "name": "requested_data",
    "type": "STRING"
  }
]
EOF
}
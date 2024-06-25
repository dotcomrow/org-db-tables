resource "google_bigquery_table" "product" {
  dataset_id = var.dataset_id
  table_id   = "product"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "product_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "GENERATE_UUID()",
    "mode": "REQUIRED",
    "name": "uuid",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "'simple'",
    "mode": "REQUIRED",
    "name": "type",
    "type": "STRING"
  },
  {
    "name": "variant_group_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "true",
    "mode": "REQUIRED",
    "name": "visibility",
    "type": "BOOLEAN"
  },
  {
    "defaultValueExpression": "1",
    "name": "group_id",
    "type": "INTEGER"
  },
  {
    "mode": "REQUIRED",
    "name": "sku",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "price",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "NULL",
    "name": "weight",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "name": "tax_class",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "status",
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
  },
  {
    "name": "category_id",
    "type": "INTEGER"
  }
]
EOF
}
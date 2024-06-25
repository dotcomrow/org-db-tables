resource "google_bigquery_table" "tax_rate" {
  dataset_id = var.dataset_id
  table_id   = "tax_rate"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "tax_rate_id",
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
    "name": "name",
    "type": "STRING"
  },
  {
    "name": "tax_class_id",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "'*'",
    "mode": "REQUIRED",
    "name": "country",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "'*'",
    "mode": "REQUIRED",
    "name": "province",
    "type": "STRING"
  },
  {
    "defaultValueExpression": "'*'",
    "mode": "REQUIRED",
    "name": "postcode",
    "type": "STRING"
  },
  {
    "mode": "REQUIRED",
    "name": "rate",
    "precision": "12",
    "scale": "4",
    "type": "NUMERIC"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "is_compound",
    "type": "BOOLEAN"
  },
  {
    "mode": "REQUIRED",
    "name": "priority",
    "type": "INTEGER"
  }
]
EOF
}
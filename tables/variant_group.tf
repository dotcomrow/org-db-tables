resource "google_bigquery_table" "variant_group" {
  dataset_id = var.dataset_id
  table_id   = "variant_group"
  deletion_protection = false
  project                     = var.project_id
  schema = <<EOF
[
  {
    "mode": "REQUIRED",
    "name": "variant_group_id",
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
    "name": "attribute_group_id",
    "type": "INTEGER"
  },
  {
    "name": "attribute_one",
    "type": "INTEGER"
  },
  {
    "name": "attribute_two",
    "type": "INTEGER"
  },
  {
    "name": "attribute_three",
    "type": "INTEGER"
  },
  {
    "name": "attribute_four",
    "type": "INTEGER"
  },
  {
    "name": "attribute_five",
    "type": "INTEGER"
  },
  {
    "defaultValueExpression": "false",
    "mode": "REQUIRED",
    "name": "visibility",
    "type": "BOOLEAN"
  }
]
EOF
}
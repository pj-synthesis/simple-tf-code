module "rds-sqlserver" {
  source  = "aws-samples/windows-workloads-on-aws/aws//modules/rds-sqlserver"

  rds_db_instance_class = "db.t3.medium"
  user_name             = "admin_mssql"
}

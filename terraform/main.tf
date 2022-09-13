# CloudSQL MySQL instance creation point-in-time-recovery.


module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.1.1"
}
variable "gcp_region" {
  type        = string
  description = "Region of Liveability project execution"
  default     = "australia-southeast1"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config" 
}
provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}
  

resource "google_sql_database_instance" "liveability-mysql" {
  name             = "aus-liveability-demo-mysql"
  region           = var.gcp_region
  database_version = "MYSQL_8_0"
  settings {
    #tier = "db-f1-micro"
    tier = "db-custom-2-7680"
    user_labels = {
      "environment" = "development"
    }
    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      start_time                     = "20:55"
      transaction_log_retention_days = "5"
    }
    ip_configuration {
      # [START cloud_sql_postgres_instance_authorized_network]
      authorized_networks {
        name = "AppSheet_01"
        value = "34.71.7.214"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_02"
        value = "34.82.138.241"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_03"
        value = "34.83.247.7"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_04"
        value = "34.86.96.199"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_05"
        value = "34.87.102.230"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_06"
        value = "34.87.103.64"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_07"
        value = "34.87.131.237"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_08"
        value = "34.87.159.166"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_09"
        value = "34.87.233.115"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_10"
        value = "34.91.142.99"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_11"
        value = "34.91.161.74"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_12"
        value = "34.116.117.132"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_13"
        value = "34.123.81.112"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_14"
        value = "34.141.206.242"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_15"
        value = "34.145.159.146"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_16"
        value = "35.189.26.70"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_17"
        value = "35.194.89.186"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_18"
        value = "35.197.185.203"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_19"
        value = "35.203.191.15"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_20"
        value = "35.204.102.20"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_21"
        value = "35.204.159.159"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_22"
        value = "35.204.213.55"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_23"
        value = "35.222.253.144"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_24"
        value = "35.230.32.44"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_25"
        value = "35.232.30.149"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_26"
        value = "35.239.112.17"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_27"
        value = "35.239.203.99"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_28"
        value = "35.240.241.182"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_29"
        value = "35.240.247.148"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_30"
        value = "35.244.107.184"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_31"
        value = "35.244.126.141"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_32"
        value = "35.245.45.144"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_33"
        value = "35.245.209.204"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_34"
        value = "35.245.229.252"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_35"
        value = "35.247.40.210"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_36"
        value = "35.247.56.116"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      # [END cloud_sql_mysql_instance_authorized_network]
      
       # [START cloud_sql_mysql_instance_datastream]
      authorized_networks {
        name = "Datastream_US_Central1_01"
        value = "34.72.28.29"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_02"
        value = "34.67.234.134"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_03"
        value = "34.67.6.157"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_04"
        value = "34.72.239.218"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_05"
        value = "34.71.242.81"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_01"
        value = "35.247.10.221"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_02"
        value = "35.233.208.195"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_03"
        value = "34.82.253.59"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_04"
        value = "35.247.95.52"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_05"
        value = "34.82.254.46"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_01"
        value = "34.116.127.89"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_02"
        value = "35.201.23.39"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_03"
        value = "35.197.161.138"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_04"
        value = "35.244.113.19"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_05"
        value = "35.201.16.163"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      # [END cloud_sql_mysql_instance_datastream]
    }
  }
  deletion_protection = false # set to true to prevent destruction of the resource
}

# Generates the user for CloudSQL database
resource "google_sql_user" "users" {
  name     = "appsheet"
  instance = google_sql_database_instance.liveability-mysql.name
  host = "%"
  password = "12345678"
}

# Generates the database in cloud sql
resource "google_sql_database" "database" {
  name     = "db_liveability"
  instance = google_sql_database_instance.liveability-mysql.name
}

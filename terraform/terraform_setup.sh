#1.create a project and export it into a variable(project creation- manual)
export PROJECT_ID="ment360live-beta"
gcloud config set project ${PROJECT_ID}
export LOCATION="australia-southeast1"
export GOOGLE_APPLICATION_CREDENTIALS=../key.json
export MYSQL_INSTANCE="aus-liveability-demo-mysql"

#12.Create the SQL instance using terraform
terraform init
terraform plan    
terraform apply -auto-approve
cd 

#16.Datastream user creation replica process and allowing privilleges for the 'datastream' user.
SERVICE_ACCOUNT=$(gcloud sql instances describe ${MYSQL_INSTANCE} | grep serviceAccountEmailAddress | awk '{print $2;}')
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT:objectViewer gs://${PROJECT_ID}
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/create-ds-user-privileges.sql --quiet

#17.Create table in mysql
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/ddl_user_activity.sql --quiet

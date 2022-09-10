#1.create a project and export it into a variable(project creation- manual)
export PROJECT_ID="ment360-liveability-alpha"
      
#2.Sets the project,location &dataset
gcloud config set project ${PROJECT_ID}
export LOCATION="us-west1"
export BQ_DATASET="liveability"

#3.Create the service account with same proj name and export it to a variable which can be used in later stages    
gcloud iam service-accounts create ${PROJECT_ID} \
 --description="Service account for the Liveability project" \
 --display-name="Liveability Service Account"    

export SERVICE_ACCOUNT_ID=${PROJECT_ID}

# 4.Assign different roles to the services account.

#dataflow
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/dataflow.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/datastore.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/iam.serviceAccountUser

#datastream
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectViewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectCreator
    
#cloud sql
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudsql.admin

#pub/sub
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.subscriber
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.viewer

#5.Creating a service account key
gcloud iam service-accounts keys create key.json --iam-account=${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=key.json

#6.Enable all the APIs

# dataflow 
gcloud services enable dataflow.googleapis.com
#firestore
gcloud services enable firestore.googleapis.com
#appengine for firestore
gcloud services enable appengine.googleapis.com
#cloud sql
gcloud services enable sqladmin.googleapis.com
#datastream
gcloud services enable datastream.googleapis.com
#pubsubapi
gcloud services enable pubsub.googleapis.com

#7.Create fire store DB for schema to be used in dataflow
gcloud app create --region=${LOCATION}
gcloud firestore databases create --region=${LOCATION}

#8.Generates a GCS bucket with the project id.
gsutil mb -l ${LOCATION} gs://${PROJECT_ID}
    
#9.Create a datset in bq
bq --location=${LOCATION} mk \
 --dataset ${BQ_DATASET} 

#10.Clone the data and schema from git to cloud shell
git clone https://github.com/liveabilityment360/final_demo

#11. Copy the files to cloud storage
gsutil cp final_demo/data/* gs://${PROJECT_ID}/data/batch_data/
gsutil cp final_demo/ddl/* gs://${PROJECT_ID}/ddl/

#12.Create the SQL instance using terraform
cd final_demo/terraform
cp ~/key.json .
terraform init
terraform plan    
terraform apply -auto-approve
cd 

############################# For data stream start ########################################################

#13.Export the values for cloud sql
export MYSQL_INSTANCE="aus-liveability-demo-mysql"
export MYSQL_PORT="3306"
export MYSQL_USER="datastream"
export MYSQL_PASS="12345678"

#14.Parameters for the Datastream Connection Profile generation.
export MYSQL_CONN_PROFILE="liveability-mysql-cp"
export GCS_CONN_PROFILE="liveability-gcs-cp"
export GCS_DS_PATH_PREFIX="/data/stream_data/"
export DS_PUBSUB_TOPIC="liveability-topic"
export DS_PUBSUB_SUBSCRIPTION="liveability-subscription"
export DS_DIR_PATH="data/stream_data/"

#15.Parameters for the Datastream creation.
export DS_MYSQL_GCS_NAME="liveability-mysql-gcs-stream"
export DS_SOURCE_JSON="final_demo/mysql_source_user_activities_config.json"
export DS_TARGET_JSON="final_demo/gcs_destination_user_activities_config.json"

#16.Datastream user creation replica process and allowing privilleges for the 'datastream' user.
SERVICE_ACCOUNT=$(gcloud sql instances describe ${MYSQL_INSTANCE} | grep serviceAccountEmailAddress | awk '{print $2;}')
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT:objectViewer gs://${PROJECT_ID}
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/create-ds-user-privileges.sql --quiet

#17.Create table in mysql
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/ddl_user_activity.sql --quiet

#18.Creates a topic for the user activity table from CloudSQL and create a subscription from the same topic.
gcloud pubsub topics create ${DS_PUBSUB_TOPIC}
gcloud pubsub subscriptions create ${DS_PUBSUB_SUBSCRIPTION} --topic=${DS_PUBSUB_TOPIC}

#19.Create a notification to track the changes on the pub/sub topic -> under - Bucket_name -> PROJECT_ID and under folder -> data/stream_data
gsutil notification create -f "json" -p "${DS_DIR_PATH}" -t "${DS_PUBSUB_TOPIC}" "gs://${PROJECT_ID}"

#20.To get the IP address from the CloudSQL description
MYSQL_IP_ADDRESS=$(gcloud sql instances describe ${MYSQL_INSTANCE} --format="value(ipAddresses.ipAddress)")

#21.Creates a connection profile for the MySQL database
gcloud datastream connection-profiles create ${MYSQL_CONN_PROFILE} --location=${LOCATION} --type=mysql --mysql-password=${MYSQL_PASS} --mysql-username=${MYSQL_USER} --display-name=${MYSQL_CONN_PROFILE} --mysql-hostname=${MYSQL_IP_ADDRESS} --mysql-port=${MYSQL_PORT} --static-ip-connectivity

#22.Create a connection profile for the Google Cloud Storage Bucket.
gcloud datastream connection-profiles create ${GCS_CONN_PROFILE} --location=${LOCATION} --type=google-cloud-storage --bucket=${PROJECT_ID} --root-path=${GCS_DS_PATH_PREFIX} --display-name=${GCS_CONN_PROFILE}

#23.Adding stream using the connection profiles. - Validation process --validate-only=true  
gcloud datastream streams create ${DS_MYSQL_GCS_NAME} --location=${LOCATION} --display-name=${DS_MYSQL_GCS_NAME} --source=${MYSQL_CONN_PROFILE} --mysql-source-config=${DS_SOURCE_JSON} --destination=${GCS_CONN_PROFILE} --gcs-destination-config=${DS_TARGET_JSON} --backfill-none --validate-only

#24.Generates the data stream.
gcloud datastream streams create ${DS_MYSQL_GCS_NAME} --location=${LOCATION} --display-name=${DS_MYSQL_GCS_NAME} --source=${MYSQL_CONN_PROFILE} --mysql-source-config=${DS_SOURCE_JSON} --destination=${GCS_CONN_PROFILE} --gcs-destination-config=${DS_TARGET_JSON} --backfill-none

#To enable datastream run
gcloud datastream streams update ${DS_MYSQL_GCS_NAME} --location=${LOCATION} --state=RUNNING --update-mask=state

#25.Run the streaming, need to start streaming manually
gcloud beta dataflow flex-template run datastream-replication1 \
        --project="${PROJECT}" --region="${LOCATION}" \
        --template-file-gcs-location="gs://dataflow-templates-us-west1/latest/flex/Cloud_Datastream_to_BigQuery" \
        --enable-streaming-engine \
        --parameters \
inputFilePattern="gs://${PROJECT}/data/",\
gcsPubSubSubscription="projects/${PROJECT}/subscriptions/${DS_PUBSUB_SUBSCRIPTION}",\
outputProjectId="${PROJECT}",\
outputStagingDatasetTemplate="${BQ_DATASET}",\
outputDatasetTemplate="${BQ_DATASET}",\
outputStagingTableNameTemplate="{_metadata_table}",\
outputTableNameTemplate="{_metadata_table}_log",\
deadLetterQueueDirectory="gs://${PROJECT}/dlq/",\
maxNumWorkers=2,\
autoscalingAlgorithm="THROUGHPUT_BASED",\
mergeFrequencyMinutes=1,\
inputFileFormat="avro"

############################## For data stream end ########################################################

############################# For data flow start ########################################################

#26.Create a directory
mkdir batch_data
cd batch_data
#copy the json key of service account to current folder
cp ~/key.json .

#27.Copy the py from shell to the current  directory
cp ~/final_demo/scripts/datastore_schema_import.py .   
cp ~/final_demo/scripts/requirements.txt .
cp ~/final_demo/scripts/data_ingestion_configurable.py .

#28.Move the schema file to the current folder
cp ~/final_demo/schema/*.csv .

#29.Create virtual environment
python3 -m pip install --user virtualenv
virtualenv -p python3 venv
source venv/bin/activate

#30.Install the required libraries
pip install -r requirements.txt

#31.Create the schema in firestore for all the files
python3 datastore_schema_import.py --schema-file=hospitals.csv
python3 datastore_schema_import.py --schema-file=childcarecenters.csv
python3 datastore_schema_import.py --schema-file=religiousorganizations.csv
python3 datastore_schema_import.py --schema-file=restaurants.csv
python3 datastore_schema_import.py --schema-file=schools.csv
python3 datastore_schema_import.py --schema-file=shoppingcentres.csv
python3 datastore_schema_import.py --schema-file=sportsclubs.csv

#32.Run the dataflow pipe line for each csv files seperately(you can run it also by mentioning it as comma seperated
python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=hospitals.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=childcarecenters.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=religiousorganizations.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=restaurants.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=schools.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=shoppingcentres.csv \
--bq-dataset=liveability

python3 data_ingestion_configurable.py \
--runner=DataflowRunner \
--save_main_session True \
--max_num_workers=100 \
--autoscaling_algorithm=THROUGHPUT_BASED \
--region=${LOCATION} \
--staging_location=gs://${PROJECT_ID}/data/staging \
--temp_location=gs://${PROJECT_ID}/data/temp \
--project=${PROJECT_ID} \
--input-bucket=gs://${PROJECT_ID}/ \
--input-path=data/batch_data \
--input-files=sportsclubs.csv \
--bq-dataset=liveability

#exit from the virtual environment, but this will completely go out of shell -need to look into this
exit




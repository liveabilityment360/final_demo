export PROJECT_ID="ment360-liveability-alpha"
export LOCATION="us-west1"
export BQ_DATASET="liveability"

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
export DS_SOURCE_JSON="mysql_source_user_activities_config.json"
export DS_TARGET_JSON="gcs_destination_user_activities_config.json"


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

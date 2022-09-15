#Export projectid,location and bq dataset into variables
export PROJECT_ID="liveability-final"
export LOCATION="australia-southeast1"
export BQ_DATASET="liveability"

# Sets the project in the shell
gcloud config set project ${PROJECT_ID}

#Set the name and id for the service account
export SERVICE_ACCOUNT_ID="sa-"${PROJECT_ID}
export SA_NAME="sa-"${PROJECT_ID}
export SA_DESCRIPTION="Service Account for Liveability Project"
export SA_DISPLAY_NAME="Liveability Service Account"

#Creating the service account
gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID} \
    --description="${SA_DESCRIPTION}" \
    --display-name="${SA_DISPLAY_NAME}"

#Enable all the necessary apis
# dataflow 
gcloud services enable dataflow.googleapis.com
gcloud services enable datapipelines.googleapis.com
gcloud services enable cloudscheduler.googleapis.com
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
#cloudbuild
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
#cloud composer
gcloud services enable composer.googleapis.com

#Assign different roles to the services account.
#common- Service Account user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/iam.serviceAccountUser
#dataflow
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/dataflow.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/datastore.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.admin
#datastream
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectViewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectCreator 
#cloud sql
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudsql.admin
#pub/sub
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.subscriber
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/pubsub.viewer
#dbt
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/bigquery.jobUser
#cloud build
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudbuild.builds.editor
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudbuild.workerPoolUser
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/logging.logWriter
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/workflows.invoker
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator
# cloud composer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/composer.worker

# Creating a key for the usage in services.
gcloud iam service-accounts keys create key.json --iam-account=${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com
export GOOGLE_APPLICATION_CREDENTIALS=key.json

#create App Engine for schema - Dataflow
gcloud app create --region=${LOCATION}

#Creates the fire store for the Batch data processing
gcloud firestore databases create --region=${LOCATION}
gcloud firestore databases update --type=firestore-native

#Create bucket in cloud storage
gsutil mb -l ${LOCATION} gs://${PROJECT_ID}

#Create a datset for the batchdata
bq --location=${LOCATION} mk \
	 --dataset ${BQ_DATASET}   

#Copy the files to cloud storage
gsutil cp mvp-liveability-setup/data/* gs://${PROJECT_ID}/data/batch_data/
gsutil cp mvp-liveability-setup/ddl/* gs://${PROJECT_ID}/ddl/
gsutil cp key.json gs://${PROJECT_ID}/credentials/key.json

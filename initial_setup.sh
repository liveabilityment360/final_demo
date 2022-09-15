#1.create a project and export it into a variable(project creation- manual)
export PROJECT_ID="liveability-gama"
      
#2.Sets the project,location &dataset
gcloud config set project ${PROJECT_ID}
export LOCATION="australia-southeast1"
export BQ_DATASET="liveability"
export Git_Root="https://github.com/liveabilityment360/final_demo"

#3.Create the service account with same proj name and export it to a variable which can be used in later stages    
gcloud iam service-accounts create ${PROJECT_ID} \
	 --description="Service account for the Liveability project" \
	  --display-name="Liveability Service Account"    

export SERVICE_ACCOUNT_ID=${PROJECT_ID}

# 4.Assign different roles to the services account.
#common
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
#cloudbuild
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com

#7.Create fire store DB for schema to be used in dataflow
gcloud app create --region=${LOCATION}
gcloud firestore databases create --region=${LOCATION}

#8.Generates a GCS bucket with the project id.
gsutil mb -l ${LOCATION} gs://${PROJECT_ID}
    
#9.Create a datset in bq
bq --location=${LOCATION} mk \
	 --dataset ${BQ_DATASET} 

#10.Clone the data and schema from git to cloud shell
git clone ${Git_Root}

#11. Copy the files to cloud storage
gsutil cp ~/final_demo/data/* gs://${PROJECT_ID}/data/batch_data/
gsutil cp ~/final_demo/ddl/* gs://${PROJECT_ID}/ddl/


############################# For data flow start ########################################################

#26.Create a directory
#mkdir batch_data
#cd batch_data
#copy the json key of service account to current folder
#cp ~/key.json .

#cp ~/key.json ~/final_demo/scripts/key.json
#cp ~/key.json ~/final_demo/dataflow/key.json
#cp ~/key.json ~/final_demo/terraform/key.json
#git add .
#git commit -m "Key updated to the script"
#git push

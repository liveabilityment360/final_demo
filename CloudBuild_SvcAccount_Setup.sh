# Export the proj and location
export PROJECT_ID="liveability-final"
export LOCATION="australia-southeast1"

# Sets the project in the shell
gcloud config set project ${PROJECT_ID}

export SA_NAME="sa-liveability-cloudbuild"
export SA_DESCRIPTION="Service account for the Cloud Build of Liveability project"
export SA_DISPLAY_NAME="Cloud Build Service Account for Liveability "
export SERVICE_ACCOUNT_ID="sa-liveability-cloudbuild"

# Generates a new service account.
gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID} \
    --description="${SA_DESCRIPTION}" \
    --display-name="${SA_DISPLAY_NAME}"

#cloudbuild
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable cloudscheduler.googleapis.com

# Svc Account user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectViewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/logging.logWriter
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/workflows.invoker
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudbuild.builds.editor
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudbuild.workerPoolUser
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/cloudbuild.serviceAgent

# GCS
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.admin

#datastream
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectViewer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/storage.objectCreator

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/owner

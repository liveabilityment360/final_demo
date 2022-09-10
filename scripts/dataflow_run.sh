#1.create a project and export it into a variable(project creation- manual)
export PROJECT_ID="liveability-demo-036"
      
#2.Sets the project,location &dataset
gcloud config set project ${PROJECT_ID}
export LOCATION="us-west1"
export BQ_DATASET="liveability"

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


############################# For data flow start ########################################################
cd scripts
export GOOGLE_APPLICATION_CREDENTIALS=key.json

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



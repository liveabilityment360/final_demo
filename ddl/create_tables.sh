


#create childcare center table
bq mk -t --description "childcare centers"  \liveability.childcarecenters  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING
 
##create hospitals  table
bq mk -t --description "hospitals"  \liveability.hospitals  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING

#create religiousorganizations table
bq mk -t --description "religiousorganizations"  \liveability.religiousorganizations  Category:STRING,Name:STRING,Address:STRING,Suburb:STRING,State:STRING,Postcode:STRING,CombinedAddress:STRING,Latitude:STRING,Longitude:STRING,Fax:STRING,Email:STRING,Website:STRING,Staff:STRING,Established:STRING,ABN:STRING,ABN_Status:STRING,ABN_Type:STRING,ABN_Accuracy:STRING,Created_Date:STRING

#create restaurants  table
bq mk -t --description "restaurants"  \liveability.restaurants  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING

#create schools table
bq mk -t --description "schools"  \liveability.schools  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING

#create shoppingcentres table
bq mk -t --description "shoppingcentres"  \liveability.shoppingcentres  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING

#create sportsclubs table
bq mk -t --description "sportsclubs"  \liveability.sportsclubs  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:STRING

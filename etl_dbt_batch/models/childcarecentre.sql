{{ config(materialized='table') }}

with transform_child_care_centre as (

    select 
         Name
        ,Categories
        ,Address
        ,City
        ,State
        ,SAFE_CAST(Postcode as INT) as Postcode
        ,Phone
        ,Fax
        ,SAFE_CAST(Latitude as FLOAT64) as Latitude
        ,SAFE_CAST(Longitude as FLOAT64) as Longitude
        ,ST_GeogPoint(SAFE_CAST(Longitude as FLOAT64),SAFE_CAST(Latitude as FLOAT64)) as Location
    from liveability.childcarecenters
)

select * from transform_child_care_centre

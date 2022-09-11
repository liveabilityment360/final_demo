{{ config(materialized='table') }}

with transform_religious_org as (

    select 
         Name
        ,Category
        ,Address
        ,Suburb
        ,State
        ,SAFE_CAST(Postcode as INT) as Postcode
        ,Website
        ,Email
        ,SAFE_CAST(Latitude as FLOAT64) as Latitude
        ,SAFE_CAST(Longitude as FLOAT64) as Longitude
        ,ST_GeogPoint(SAFE_CAST(Longitude as FLOAT64),SAFE_CAST(Latitude as FLOAT64)) as Location 
    from liveability.religiousorganizations
)

select * from transform_religious_org

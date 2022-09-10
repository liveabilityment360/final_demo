{{ config(materialized='view') }}

WITH total_amenities AS (
	SELECT cdata.postcode as postcode
		  ,cdata.suburb as suburb
		  ,SUM(cdata.count_amenities) as total_count_amenities
	FROM {{ref('combined_data')}} cdata
	GROUP BY cdata.postcode, cdata.suburb

)

SELECT * FROM total_amenities
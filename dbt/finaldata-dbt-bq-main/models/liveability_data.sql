{{ config(materialized='view') }}

WITH final_liveability AS (

  WITH user_location AS (
   	  SELECT new_geo 
			,confirm_new_postcode as new_postcode
 	        ,RANK() over (
 		     ORDER BY ui3.created_date DESC
 		   ) AS rank_no3 
 	    FROM `streamdata.user_input` ui3
  )

  SELECT ulive.name
		,ulive.category 
        ,ulive.cat_colour
        ,ulive.address
        ,ulive.city
		,ulive.postcode
        ,ulive.location
		,uloc.new_geo
  FROM {{ref('user_liveability')}} ulive
  LEFT JOIN user_location uloc
  ON ulive.postcode = uloc.new_postcode
  WHERE uloc.rank_no3 = 1
)

SELECT * FROM final_liveability


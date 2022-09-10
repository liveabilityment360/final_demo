{{ config(materialized='table') }}

WITH ranks AS (
        SELECT totamn.postcode
              ,totamn.suburb
              ,totamn.total_count_amenities
              ,DENSE_RANK() OVER (
                 ORDER BY (totamn.total_count_amenities) DESC
               ) rankso
        FROM {{ref('total_amenities')}} totamn
        WHERE totamn.postcode BETWEEN 3000 and 3999

)

SELECT * FROM ranks
WHERE rankso IN (1,2,3,4,5,6,7)
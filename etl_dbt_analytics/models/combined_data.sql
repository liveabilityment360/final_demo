{{ config(materialized='view') }}

WITH combined_data AS (

     SELECT ccare.postcode as postcode
           ,ccare.city as suburb
           ,ccare.categories as category
           ,COUNT(ccare.categories) AS count_amenities
     FROM `transform_batchdata.childcarecentre` ccare
     WHERE ccare.postcode IS NOT NULL
     GROUP BY ccare.postcode, ccare.city , ccare.categories
     UNION ALL
     SELECT hosp.postcode as postcode
           ,hosp.city as suburb
           ,hosp.categories as category
           ,COUNT(hosp.categories) AS count_amenities
     FROM `transform_batchdata.hospitals` hosp
     WHERE hosp.postcode IS NOT NULL
     GROUP BY hosp.postcode, hosp.city, hosp.categories
     UNION ALL
     SELECT relg.postcode as postcode
           ,relg.suburb as suburb
           ,relg.category as category
           ,COUNT(relg.category) AS count_amenities
     FROM `transform_batchdata.religiousorganizations` relg
     WHERE relg.postcode IS NOT NULL
     GROUP BY relg.postcode, relg.suburb, relg.category
     UNION ALL
     SELECT rest.postcode as postcode
           ,rest.city as suburb
           ,rest.categories as category
           ,COUNT(rest.categories) AS count_amenities
     FROM `transform_batchdata.restaurants` rest
     WHERE rest.postcode IS NOT NULL
     GROUP BY rest.postcode, rest.city, rest.categories
     UNION ALL
     SELECT sch.postcode as postcode
           ,sch.city as suburb
           ,sch.categories as category
           ,COUNT(sch.categories) AS count_amenities
     FROM `transform_batchdata.schools` sch
     WHERE sch.postcode IS NOT NULL
     GROUP BY sch.postcode, sch.city, sch.categories
     UNION ALL
     SELECT shop.postcode as postcode
           ,shop.city as suburb
           ,shop.categories as category
           ,COUNT(shop.categories) AS count_amenities
     FROM `transform_batchdata.shoppingcentre` shop
     WHERE shop.postcode IS NOT NULL
     GROUP BY shop.postcode, shop.city, shop.categories
     UNION ALL
     SELECT sprt.postcode as postcode
           ,sprt.city as suburb
           ,sprt.categories as category
           ,COUNT(sprt.categories) AS count_amenities
     FROM `transform_batchdata.sportsclubs` sprt
     WHERE sprt.postcode IS NOT NULL
     GROUP BY sprt.postcode, sprt.city, sprt.categories
)

SELECT * FROM combined_data
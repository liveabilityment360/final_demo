{{ config(materialized='table') }}

WITH distribution_amenities AS (
        SELECT * FROM
        (
           SELECT cc.postcode as postcode
		     ,cc.city as suburb
                 ,cc.categories as category
                 ,COUNT(cc.categories) AS count_amenities
           FROM `transform_batchdata.childcarecentre` cc
           WHERE cc.postcode IS NOT NULL
           GROUP BY cc.postcode, cc.city, cc.categories
           UNION ALL
           SELECT hp.postcode as postcode
		     ,hp.city as suburb 
                 ,hp.categories as category
                 ,COUNT(hp.categories) AS count_amenities
           FROM `transform_batchdata.hospitals` hp
           WHERE hp.postcode IS NOT NULL
           GROUP BY hp.postcode, hp.city, hp.categories
           UNION ALL
           SELECT rel.postcode as postcode
		     ,rel.suburb as suburb
                 ,rel.category as category
                 ,COUNT(rel.category) AS count_amenities
           FROM `transform_batchdata.religiousorganizations` rel
           WHERE rel.postcode IS NOT NULL
           GROUP BY rel.postcode, rel.suburb, rel.category
           UNION ALL
           SELECT rst.postcode as postcode
		     ,rst.city as suburb
                 ,rst.categories as category
                 ,COUNT(rst.categories) AS count_amenities
           FROM `transform_batchdata.restaurants` rst
           WHERE rst.postcode IS NOT NULL
           GROUP BY rst.postcode, rst.city, rst.categories
           UNION ALL           
           SELECT sc.postcode as postcode
		     ,sc.city as suburb
                 ,sc.categories as category
                 ,COUNT(sc.categories) AS count_amenities
           FROM `transform_batchdata.schools` sc
           WHERE sc.postcode IS NOT NULL
           GROUP BY sc.postcode, sc.city, sc.categories
           UNION ALL      		   
           SELECT sh.postcode as postcode
		     ,sh.city as suburb
                 ,sh.categories as category
                 ,COUNT(sh.categories) AS count_amenities
           FROM `transform_batchdata.shoppingcentre` sh
           WHERE sh.postcode IS NOT NULL
           GROUP BY sh.postcode, sh.city, sh.categories
           UNION ALL 
           SELECT sp.postcode as postcode
		     ,sp.city as suburb
                 ,sp.categories as category
                 ,COUNT(sp.categories) AS count_amenities
           FROM `transform_batchdata.sportsclubs` sp
           WHERE sp.postcode IS NOT NULL
           GROUP BY sp.postcode, sp.city, sp.categories		   
        )
        WHERE postcode IN
           (SELECT rankt.postcode from {{ref('suburb_ranks')}} rankt
               WHERE rankt.rankso IN (1,2,3,4,5,6,7,8))
)

SELECT * FROM distribution_amenities
WITH USED_CARS AS (

  SELECT * 
  
  FROM {{ source('TESTING.PUBLIC', 'USED_CARS') }}

),

reformat AS (

  SELECT 
    DATA['manufacturer'] AS manufacturer,
    DATA['model'] AS model,
    DATA['modelDate'] AS modelDate
  
  FROM USED_CARS

),

salesByModel AS (

  SELECT 
    any_value(MANUFACTURER) AS MANUFACTURER,
    any_value(MODEL) AS MODEL,
    min(MODELDATE) AS LAUNCH_DATE,
    COUNT(1) AS MODELS_SOLD
  
  FROM reformat
  
  GROUP BY MODEL

),

OrderBySale AS (

  SELECT * 
  
  FROM salesByModel AS in0
  
  ORDER BY MODELS_SOLD DESC NULLS LAST

),

Top10 AS (

  SELECT * 
  
  FROM OrderBySale AS in0
  
  LIMIT 10

)

SELECT * 

FROM Top10

WITH USED_CARS AS (

  SELECT * 
  
  FROM {{ source('TESTING.PUBLIC', 'USED_CARS') }}

),

reformat AS (

  SELECT 
    DATA['manufacturer']::STRING AS manufacturer,
    DATA['model']::STRING AS model,
    DATA['price'] / 280 AS price
  
  FROM USED_CARS

),

salesByModel AS (

  SELECT 
    any_value(MANUFACTURER) AS MANUFACTURER,
    any_value(MODEL) AS MODEL,
    max(PRICE) AS PRICE
  
  FROM reformat
  
  GROUP BY MODEL

),

OrderBySale AS (

  SELECT * 
  
  FROM salesByModel AS in0
  
  ORDER BY PRICE DESC NULLS LAST

),

Top10 AS (

  SELECT * 
  
  FROM OrderBySale AS in0
  
  LIMIT 10

),

HumanReadable AS (

  SELECT 
    MANUFACTURER AS MANUFACTURER,
    MODEL AS MODEL,
    {{ jaffle_shop.human_readable_number('PRICE') }} AS PRICE
  
  FROM Top10 AS in0

)

SELECT * 

FROM HumanReadable

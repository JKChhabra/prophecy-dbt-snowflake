WITH CUSTOMERS AS (

  SELECT * 
  
  FROM {{ source('JAFFLE_SHOP.PUBLIC', 'CUSTOMERS') }}

),

ORDERS AS (

  SELECT * 
  
  FROM {{ source('JAFFLE_SHOP.PUBLIC', 'ORDERS') }}

),

byCustomerId AS (

  SELECT 
    CUSTOMERS.FIRST_ORDER AS FIRST_ORDER,
    CUSTOMERS.MOST_RECENT_ORDER AS MOST_RECENT_ORDER,
    CUSTOMERS.NUMBER_OF_ORDERS AS NUMBER_OF_ORDERS,
    ORDERS.CUSTOMER_ID AS CUSTOMER_ID,
    ORDERS.COUPON_AMOUNT AS COUPON_AMOUNT,
    ORDERS.CREDIT_CARD_AMOUNT AS CREDIT_CARD_AMOUNT,
    ORDERS.ORDER_ID AS ORDER_ID,
    ORDERS.STATUS AS STATUS,
    ORDERS.BANK_TRANSFER_AMOUNT AS BANK_TRANSFER_AMOUNT,
    ORDERS.ORDER_DATE AS ORDER_DATE,
    ORDERS.GIFT_CARD_AMOUNT AS GIFT_CARD_AMOUNT,
    ORDERS.AMOUNT AS AMOUNT
  
  FROM ORDERS
  INNER JOIN CUSTOMERS
     ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID

),

AmountByCustomer AS (

  SELECT 
    SUM(AMOUNT) AS AMOUNT,
    CUSTOMER_ID AS CUSTOMER_ID,
    MAX(ORDER_DATE) AS ORDER_DATE
  
  FROM byCustomerId AS in0
  
  GROUP BY CUSTOMER_ID

),

TopCustomers AS (

  SELECT * 
  
  FROM AmountByCustomer AS in0
  
  ORDER BY AMOUNT DESC NULLS LAST

),

Top10 AS (

  SELECT * 
  
  FROM TopCustomers AS in0
  
  LIMIT 10

)

SELECT * 

FROM Top10

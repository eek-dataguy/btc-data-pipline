{{ config(materialized='ephemeral')}}

WITH STG_BTC_TRANSACTIONS AS (
    SELECT
        *
    FROM {{ ref('stg_btc_outputs')}}
    WHERE is_coinbase = false
)
SELECT
    *
FROM STG_BTC_TRANSACTIONS
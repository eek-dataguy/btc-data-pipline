{{
    config(
        materialized='incremental',
        unique_key='HASH_KEY',
        incremental_strategy='merge'
    )
}}

WITH STG_BTC AS (
    SELECT 
    *
    FROM {{ source('btc', 'btc') }}
)
SELECT * FROM STG_BTC


{% if is_incremental() %}
    WHERE BLOCK_TIMESTAMP >= (SELECT MAX(BLOCK_TIMESTAMP) FROM {{this}} )
{% endif %}
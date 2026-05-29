{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

WITH STG_BTC_OUTPUTS AS (
    SELECT
        tx.HASH_KEY,
        tx.BLOCK_NUMBER,
        tx.BLOCK_TIMESTAMP,
        tx.IS_COINBASE,
        f.value:address:: STRING AS OUTPUT_ADDRESS,
        f.value:value:: FLOAT AS OUTPUT_VALUE
    FROM {{ ref('stg_btc') }} tx,
    LATERAL FLATTEN(INPUT => OUTPUTS) f
    WHERE  f.value:address IS NOT NULL
) 
SELECT 
    *
FROM STG_BTC_OUTPUTS


{% if is_incremental() %}
    WHERE BLOCK_TIMESTAMP >= (SELECT MAX(BLOCK_TIMESTAMP) FROM {{this}} )
{% endif %}
/*
Data Consistency
Data Accuracy
Data Standardization
Null or duplicate primary keys
Unwanted spaces for in string fields
Data standardization and consistency
Invalid date ranges and orders
Data consistency between related fields

Note :  I did all checks after loading cleaned data in silver layer
*/

--Data Standardization & Consistency
SELECT DISTINCT 
cntry 
FROM silver.erp_loc_a101
ORDER BY cntry
select * from silver.erp_loc_a101
--check unwanted spaces
SELECT * FROM bronze.erp_px_cat_giv2
where cat !=trim (cat) OR subcat!=trim(subcat) OR maintenance!=trim(maintenance)
--Data Standardization & Consistency
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_giv2

SELECT *FROM silver.erp_px_cat_giv2

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info


--Check for nulls or duplicates in primary key
--Expectation: No results

SELECT 
cst_id,COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL
 
 SELECT DISTINCT cst_material_status
 FROM bronze.crm_cust_info

 SELECT 
 cst_id,
 COUNT(*)
 FROM silver.crm_cust_info
 GROUP BY cst_id
 HAVING COUNT(*) >1 OR cst_id IS NULL

 --Check for unwanted spaces 
 --Expectation: No results#
 SELECT cst_firstname
 FROM silver.crm_cust_info
 WHERE cst_firstname != TRIM(cst_firstname)

 --Data Standardization and consistency 
 SELECT DISTINCT cst_gndr
 FROM silver.crm_cust_info
 --Data Quality Checks
--Check For Nulls or Duplicates in Primary Key
--Expectation: No Result
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

--Check for unwanted Spaces
--Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLs or Negative Numbers
--Expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost<0 OR prd_cost IS null

--Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt<prd_start_dt

select * 
FROM silver.crm_prd_info
-- Identigfy out of range dates 
SELECT DISTINCT 
bdate 
FROM bronze.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate > GETDATE()

--Data Standardization & consistency 
SELECT DISTINCT 
gen
FROM silver.erp_cust_az12

select * from silver.erp_cust_az12

--SELECT FOR INVALID DATES
SELECT 
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt<=0
OR LEN(sls_order_dt) !=8
OR sls_order_dt <19000101
OR sls_order_dt>20500101

--Check for invalid date orders 
SELECT
* 
FROM silver.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt

--Check data consistency: Between Sales quantity and price 
-->> sales =quantity*price
-->> values must not be null, zero or negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price 
FROM silver.crm_sales_details
WHERE sls_sales !=sls_quantity*sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price

select * from silver.crm_sales_details

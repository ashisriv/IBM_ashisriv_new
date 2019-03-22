create or replace 
PROCEDURE SP_REFRESH_CATALOGUE_METADATA
AS
V_INS_CNT NUMBER;
V_PROCE_NAME    ERROR_LOG.PROCE_NAME%TYPE;
BEGIN
---truncate all tables ---
--DBMS_OUTPUT.PUT_LINE('TRUNCATION STARTED');

V_PROCE_NAME := 'SP_REFRESH_CATALOGUE_METADATA';

DELETE FROM ERROR_LOG where PROCE_NAME =V_PROCE_NAME and TRUNC(LOG_DATE) < TRUNC(SYSDATE);

SP_ERROR_LOG(1,V_PROCE_NAME,SYSDATE, 'SP_REFRESH_CATALOGUE_METADATA START');

EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_BASIC_DETAILS REUSE STORAGE';
--EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_B2B_CANCEL REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_DC_STNDRD_DLVRY REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_DDEXP_STNDRD_DLVRY REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_LOCN_ID REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_XSELL_PRODUCTS REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_METADATA REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_NON_IFC_PRICEMATCH REUSE STORAGE';

--DBMS_OUTPUT.PUT_LINE('ALL 7 TABLES TRUNCATED SUCCESSFULLY');

SP_ERROR_LOG(2,V_PROCE_NAME,SYSDATE, 'ALL 7 TABLES TRUNCATED SUCCESSFULLY');

--1 CATALOGUE_BASIC_DETAILS
SP_ERROR_LOG(3,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_BASIC_DETAILS TABLE STARTED');



INSERT INTO CATALOGUE_BASIC_DETAILS
SELECT DISTINCT gpot.CATALOGUE_NUMBER ,
  pd.product_id,
  gpot.channel_code AS Brand ,
  gpot.suffix,
  gpot.price ,
  pd.BUYERS_RANGE_NUMBER,
  pd.OUTLET_CODE,
  pd.line_item_ref ,
  gpot.RESTRICTION_CODE ,
  --gpot.option_number ,
  pd.dd_indicator,
  pd.product_type_code,
  pd.carrier_code,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 2
    WHEN 'FXMP2'
    THEN 6
    WHEN 'FXMSC'
    THEN 7
    WHEN 'FXLP1'
    THEN 10
    WHEN 'RMSPEC'
    THEN 11
    WHEN 'S'
    THEN 20
    WHEN 'QUANT'
    THEN 73
    WHEN 'EBIRD'
    THEN 76
    WHEN 'SOTL'
    THEN 77
    WHEN 'RMTRCK'
    THEN 30
    WHEN 'RMSIGN'
    THEN 31
    WHEN 'RM24'
    THEN 41
    ELSE NULL
  END AS CARRIER_REFERENCE,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 'Letter Post 1st Class'
    WHEN 'FXMP2'
    THEN 'Yodel (MED)'
    WHEN 'FXMSC'
    THEN 'Yodel (MED)'
    WHEN 'FXLP1'
    THEN 'Yodel (LGT)'
    WHEN 'RMSPEC'
    THEN 'Special Delivery'
    WHEN 'S'
    THEN 'Supplier?s Own Transport.'
    WHEN 'QUANT'
    THEN 'Quantum'
    WHEN 'EBIRD'
    THEN 'EARLY BIRD'
    WHEN 'SOTL'
    THEN 'SOT LIGHTWEIGHT'
    WHEN 'RMTRCK'
    THEN 'RM TRACKED'
    WHEN 'RMSIGN'
    THEN 'RM SIGNED FOR'
    WHEN 'RM24'
    THEN 'RM TRACKED 24'
    ELSE NULL
  END AS CARRIER_REF_DESCRIPTION,
  pd.line_item_description,
  pd.WARRANTY_INDICATOR,
  pd.WARRANTY_CODE ,
  TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
FROM PRODUCT@grdbtoopruat.world pd,
  GET_PRODUCT_OPT_TERMS_STAGED@grdbtoopruat.world gpot,
  outlet_extract@grdbtoopruat.world oe ,
  offer@grdbtoopruat.world OFF
WHERE pd.CATALOGUE_NUMBER  =gpot.CATALOGUE_NUMBER
AND pd.outlet_code         =gpot.outlet_code
AND gpot.channel_code      ='LEX'
AND pd.dd_indicator       IN(1, 0)
AND gpot.channel_code      = oe.channel_code
AND pd.BUYERS_RANGE_NUMBER = off.BUYERS_RANGE_NUMBER
AND gpot.outlet_code       = oe.outlet_code
AND oe.OUTLET_CODE         = off.OUTLET_CODE
AND TRUNC(sysdate) BETWEEN TRUNC(oe.outlet_on_sale_date) AND TRUNC(oe.outlet_off_sale_date)
AND TRUNC(sysdate) BETWEEN TRUNC(off.offer_onsale_date) AND TRUNC(off.offer_offsale_date)
UNION
SELECT DISTINCT gpot.CATALOGUE_NUMBER ,
  pd.product_id,
  gpot.channel_code AS Brand ,
  gpot.suffix,
  gpot.price ,
  pd.BUYERS_RANGE_NUMBER,
  pd.OUTLET_CODE,
  pd.line_item_ref ,
  gpot.RESTRICTION_CODE ,
  --gpot.option_number ,
  pd.dd_indicator,
  pd.product_type_code,
  pd.carrier_code,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 2
    WHEN 'FXMP2'
    THEN 6
    WHEN 'FXMSC'
    THEN 7
    WHEN 'FXLP1'
    THEN 10
    WHEN 'RMSPEC'
    THEN 11
    WHEN 'S'
    THEN 20
    WHEN 'QUANT'
    THEN 73
    WHEN 'EBIRD'
    THEN 76
    WHEN 'SOTL'
    THEN 77
    WHEN 'RMTRCK'
    THEN 30
    WHEN 'RMSIGN'
    THEN 31
    WHEN 'RM24'
    THEN 41
    ELSE NULL
  END AS CARRIER_REFERENCE,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 'Letter Post 1st Class'
    WHEN 'FXMP2'
    THEN 'Yodel (MED)'
    WHEN 'FXMSC'
    THEN 'Yodel (MED)'
    WHEN 'FXLP1'
    THEN 'Yodel (LGT)'
    WHEN 'RMSPEC'
    THEN 'Special Delivery'
    WHEN 'S'
    THEN 'Supplier?s Own Transport.'
    WHEN 'QUANT'
    THEN 'Quantum'
    WHEN 'EBIRD'
    THEN 'EARLY BIRD'
    WHEN 'SOTL'
    THEN 'SOT LIGHTWEIGHT'
    WHEN 'RMTRCK'
    THEN 'RM TRACKED'
    WHEN 'RMSIGN'
    THEN 'RM SIGNED FOR'
    WHEN 'RM24'
    THEN 'RM TRACKED 24'
    ELSE NULL
  END AS CARRIER_REF_DESCRIPTION,
  pd.line_item_description,
  pd.WARRANTY_INDICATOR,
  pd.WARRANTY_CODE ,
  TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
FROM PRODUCT@grdbtoopruat.world pd,
  GET_PRODUCT_OPT_TERMS_STAGED@grdbtoopruat.world gpot,
  outlet_extract@grdbtoopruat.world oe ,
  offer@grdbtoopruat.world OFF
WHERE pd.CATALOGUE_NUMBER  =gpot.CATALOGUE_NUMBER
AND pd.outlet_code         =gpot.outlet_code
AND gpot.channel_code      ='LAI'
AND pd.dd_indicator       IN(1, 0)
AND gpot.channel_code      = oe.channel_code
AND pd.BUYERS_RANGE_NUMBER = off.BUYERS_RANGE_NUMBER
AND gpot.outlet_code       = oe.outlet_code
AND oe.OUTLET_CODE         = off.OUTLET_CODE
AND TRUNC(sysdate) BETWEEN TRUNC(oe.outlet_on_sale_date) AND TRUNC(oe.outlet_off_sale_date)
AND TRUNC(sysdate) BETWEEN TRUNC(off.offer_onsale_date) AND TRUNC(off.offer_offsale_date)
UNION
SELECT DISTINCT gpot.CATALOGUE_NUMBER ,
  pd.product_id,
  gpot.channel_code AS Brand ,
  gpot.suffix,
  gpot.price ,
  pd.BUYERS_RANGE_NUMBER,
  pd.OUTLET_CODE,
  pd.line_item_ref ,
  gpot.RESTRICTION_CODE ,
  --gpot.option_number ,
  pd.dd_indicator,
  pd.product_type_code,
  pd.carrier_code,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 2
    WHEN 'FXMP2'
    THEN 6
    WHEN 'FXMSC'
    THEN 7
    WHEN 'FXLP1'
    THEN 10
    WHEN 'RMSPEC'
    THEN 11
    WHEN 'S'
    THEN 20
    WHEN 'QUANT'
    THEN 73
    WHEN 'EBIRD'
    THEN 76
    WHEN 'SOTL'
    THEN 77
    WHEN 'RMTRCK'
    THEN 30
    WHEN 'RMSIGN'
    THEN 31
    WHEN 'RM24'
    THEN 41
    ELSE NULL
  END AS CARRIER_REFERENCE,
  CASE pd.carrier_code
    WHEN 'LPST1'
    THEN 'Letter Post 1st Class'
    WHEN 'FXMP2'
    THEN 'Yodel (MED)'
    WHEN 'FXMSC'
    THEN 'Yodel (MED)'
    WHEN 'FXLP1'
    THEN 'Yodel (LGT)'
    WHEN 'RMSPEC'
    THEN 'Special Delivery'
    WHEN 'S'
    THEN 'Supplier?s Own Transport.'
    WHEN 'QUANT'
    THEN 'Quantum'
    WHEN 'EBIRD'
    THEN 'EARLY BIRD'
    WHEN 'SOTL'
    THEN 'SOT LIGHTWEIGHT'
    WHEN 'RMTRCK'
    THEN 'RM TRACKED'
    WHEN 'RMSIGN'
    THEN 'RM SIGNED FOR'
    WHEN 'RM24'
    THEN 'RM TRACKED 24'
    ELSE NULL
  END AS CARRIER_REF_DESCRIPTION,
  pd.line_item_description,
  pd.WARRANTY_INDICATOR,
  pd.WARRANTY_CODE , 
  TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
FROM PRODUCT@grdbtoopruat.world pd,
  GET_PRODUCT_OPT_TERMS_STAGED@grdbtoopruat.world gpot,
  outlet_extract@grdbtoopruat.world oe ,
  offer@grdbtoopruat.world OFF
WHERE pd.CATALOGUE_NUMBER  =gpot.CATALOGUE_NUMBER
AND pd.outlet_code         =gpot.outlet_code
AND gpot.channel_code      ='LWI'
AND pd.dd_indicator       IN(1, 0)
AND gpot.channel_code      = oe.channel_code
AND pd.BUYERS_RANGE_NUMBER = off.BUYERS_RANGE_NUMBER
AND gpot.outlet_code       = oe.outlet_code
AND oe.OUTLET_CODE         = off.OUTLET_CODE
AND TRUNC(sysdate) BETWEEN TRUNC(oe.outlet_on_sale_date) AND TRUNC(oe.outlet_off_sale_date)
AND TRUNC(sysdate) BETWEEN TRUNC(off.offer_onsale_date) AND TRUNC(off.offer_offsale_date)
ORDER BY CATALOGUE_NUMBER;

V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(4,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_BASIC_DETAILS');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_BASIC_DETAILS COMPUTE STATISTICS';
SP_ERROR_LOG(5,V_PROCE_NAME,SYSDATE,'TABLE CATALOGUE_BASIC_DETAILS ANALYZED');
--
----2 CATALOGUE_B2B_CANCEL
--DBMS_OUTPUT.PUT_LINE('INSERT INTO CATALOGUE_B2B_CANCEL TABLE STARTED');
--
--INSERT INTO CATALOGUE_B2B_CANCEL
--select distinct sa.line_num as CATALOGUE_NUMBER , TO_CHAR(TRUNC(sa.date_end),'DD-MM-YYYY') AS B2b_END_DATE, 'YES' B2b_CANCEL
--from B2B_DBA.supplier_parameters@GRDBTOB2BUAT.WORLD sp,
--B2B_DBA.atp_stock_availability@GRDBTOB2BUAT.WORLD sa
--where 
--sa.supplier_code=sp.supplier_code
--and sp.level_of_integration='0'
--and sa.availability_type='Current'
--and sa.stock_status='IS'
--and TRUNC(sa.date_end) > TRUNC(sysdate)
--;
--
--V_INS_CNT := SQL%ROWCOUNT;
--
--DBMS_OUTPUT.PUT_LINE(V_INS_CNT ||' Rows inserted into CATALOGUE_B2B_CANCEL');
--
--COMMIT;

--EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_B2B_CANCEL COMPUTE STATISTICS';
--DBMS_OUTPUT.PUT_LINE('TABLE CATALOGUE_B2B_CANCEL ANALYZED');

--3 CATALOGUE_DC_STNDRD_DLVRY
SP_ERROR_LOG(6,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_DC_STNDRD_DLVRY TABLE STARTED');

INSERT INTO CATALOGUE_DC_STNDRD_DLVRY
SELECT DISTINCT pi.prod_id AS CATALOGUE_NUMBER , --,cbd.Brand ,
    cdr.dlvry_serv_lev_code    AS DC_STANDARD_DELIVERY , 
    TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
  FROM customer_dc_requests@GRDBTODMSUAT.WORLD cdr,
    customer_orders@GRDBTODMSUAT.WORLD co,
    parcels@GRDBTODMSUAT.WORLD p,
    parcel_items@GRDBTODMSUAT.WORLD pi,
    CATALOGUE_BASIC_DETAILS cbd
  WHERE cdr.agent_no       =co.agent_no
  AND p.parcel_id          =pi.parcel_id
  AND cdr.cust_dc_req_id   =p.cust_dc_req_id
  AND cbd.CATALOGUE_NUMBER = pi.prod_id
  AND cbd.dd_indicator     = 0
  AND cbd.Brand           IN('LEX','LAI','LWI')
  ORDER BY pi.prod_id DESC;

V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(7,V_PROCE_NAME,SYSDATE,V_INS_CNT||' Rows inserted into CATALOGUE_DC_STNDRD_DLVRY');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_DC_STNDRD_DLVRY COMPUTE STATISTICS';
SP_ERROR_LOG(8,V_PROCE_NAME,SYSDATE,'TABLE CATALOGUE_DC_STNDRD_DLVRY ANALYZED');

--4 CATALOGUE_DDEXP_STNDRD_DLVRY
SP_ERROR_LOG(9,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_DDEXP_STNDRD_DLVRY TABLE STARTED');

INSERT INTO CATALOGUE_DDEXP_STNDRD_DLVRY              -- DD STANDARD DELIVERY and EXPRESS DELIVERY
   SELECT DISTINCT sds.line_num AS CATALOGUE_NUMBER , -- ,cbd.Brand  , 
    sds.NEXTDAY_AVAILABLE_IND NEXTDAY_AVAILABLE_IND ,
    (
    CASE (sds.TIME_CUTOFF_NEXTDAY_ORDER)
      WHEN 1200
      THEN 'DDEXP1'
      WHEN 1400
      THEN 'DDEXP2'
      WHEN 1600
      THEN 'DDEXP3'
      ELSE NULL
    END) AS DD_EXPRESS_DELIVERY,
    (
    CASE sds.NEXTDAY_AVAILABLE_IND
      WHEN 1
      THEN '24HR'
      WHEN 0
      THEN 'STANDARD'
    END ) DD_STANDARD_DELIVERY ,TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
  FROM CATALOGUE_BASIC_DETAILS cbd,
    product@ATPUAT2COMMONDM.WORLD P,
    SUPPLIER_DESPATCH_SERVICES@ATPUAT2COMMONDM.WORLD sds
  WHERE cbd.CATALOGUE_NUMBER = sds.line_num
  AND P.LINE_NUM             = sds.line_num
  AND cbd.CATALOGUE_NUMBER   = P.LINE_NUM
  AND cbd.dd_indicator       = 1
  AND cbd.Brand             IN('LEX','LAI','LWI')
  ORDER BY sds.line_num
  ;
  
V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(10,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_DDEXP_STNDRD_DLVRY');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_DDEXP_STNDRD_DLVRY COMPUTE STATISTICS';
SP_ERROR_LOG(11,V_PROCE_NAME,SYSDATE,'TABLE CATALOGUE_DDEXP_STNDRD_DLVRY ANALYZED');

--5  
SP_ERROR_LOG(12,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_LOCN_ID TABLE STARTED');


   INSERT INTO CATALOGUE_LOCN_ID --- LOCATION ID
     SELECT DISTINCT pls.prod_id AS CATALOGUE_NUMBER,
      pls.locn_id,
      dl.locn_name ,TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
    FROM product_location_statuses@GRDBTODMSUAT.WORLD pls ,
      DC_LOCATIONS@GRDBTODMSUAT.WORLD dl ,
      CATALOGUE_BASIC_DETAILS cbd
    WHERE pls.prod_id = cbd.CATALOGUE_NUMBER
    AND pls.locn_id   = dl.locn_id
    AND cbd.Brand IN('LEX','LAI','LWI')
    ORDER BY pls.prod_id;
	
	
V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(13,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_LOCN_ID');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_LOCN_ID COMPUTE STATISTICS';
SP_ERROR_LOG(14,V_PROCE_NAME,SYSDATE,'TABLE CATALOGUE_LOCN_ID ANALYZED');

--6
SP_ERROR_LOG(15,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_XSELL_PRODUCTS TABLE STARTED');

INSERT INTO CATALOGUE_XSELL_PRODUCTS
SELECT DISTINCT p.CATALOGUE_NUMBER ,
  P.BRAND,
  (
  CASE p.DD_indicator
    WHEN 1
    THEN 'DD'
    WHEN 0
    THEN 'DC'
  END ) AS DD_indicator ,
 -- LEX 0,100,150,200,400 -- LAI 0,50,99-- lWI 0,100,150,200
(
  CASE
  WHEN (p.Price > 400 AND p.BRAND IN ('LEX')) THEN
    400
  WHEN(p.Price > 200 AND p.BRAND IN ('LEX')) THEN
    200
  WHEN(p.Price > 150 AND p.BRAND IN ('LEX')) THEN
    150
  WHEN(p.Price > 100 AND p.BRAND IN ('LEX')) THEN
    100
  WHEN(p.Price > 0 AND p.BRAND IN ('LEX')) THEN
    0
  WHEN(p.Price > 99 AND p.BRAND IN ('LAI')) THEN
    99
  WHEN(p.Price > 50 AND p.BRAND IN ('LAI')) THEN
    50
  WHEN(p.Price > 0 AND p.BRAND IN ('LAI')) THEN
    0
  WHEN(p.Price > 200 AND p.BRAND IN ('LWI')) THEN
    200
  WHEN(p.Price > 150 AND p.BRAND IN ('LWI')) THEN
    150
  WHEN(p.Price > 100 AND p.BRAND IN ('LWI')) THEN
    100
  WHEN(p.Price > 0 AND p.BRAND IN ('LWI')) THEN
    0
  END )
AS
  MOV,
  p.price,
  (
  CASE
    WHEN UPPER(p.line_item_description) LIKE '%LAPTOP%'
    THEN 'LAPTOP'
    WHEN UPPER(p.line_item_description) LIKE '%TAB%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%FRIDGE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%WASHING%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%TV%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%CAMERA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%MOBILE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%SOCKET%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%SWITCH%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%WIRELESS%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%PRINTER%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%VACCUM%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%DISHWASHER%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%CHIMNEY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%CABLE%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%FAN%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%LIGHT%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%MICRO%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%ELECTRIC%'
    THEN 'ELECTRICAL'
    WHEN UPPER(p.line_item_description) LIKE '%SAMSUNG%'
    THEN 'SAMSUNG'
    WHEN UPPER(p.line_item_description) LIKE '%LG%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%SONY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%MOTOROLA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%NOKIA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%PANASONIC%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%PHILIPS%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%TOSHIBA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%BOSCH%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%APPLE%'
    THEN 'APPLE'
    WHEN UPPER(p.line_item_description) LIKE '%SANSUI%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(p.line_item_description) LIKE '%SOFA%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(p.line_item_description) LIKE '%MATTRESS%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(p.line_item_description) LIKE '%CURTAINS%'
    THEN 'UPHOLESTRY'
    ELSE 'OTHERS'
  END )                                AS PRODUCT_CATEGORY,
  p.line_item_description              AS PRODUCT_DESCRIPTION ,
  TO_CHAR(ps.date_start, 'DD-MM-YYYY') AS date_start,
  TO_CHAR(ps.date_end, 'DD-MM-YYYY')   AS date_end,
   TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE ,
  ps.CHILD_CATNO CROSS_SELL_CATALOGUE ,
  ps.SELLING_SCRIPT CROSS_SELL_description ,
  p.CARRIER_CODE ,
  p.CARRIER_REFERENCE ,
  p.CARRIER_REF_DESCRIPTION,
  p.PRODUCT_TYPE_CODE,
  p.WARRANTY_INDICATOR
  --p.WARRANTY_CODE 
FROM CATALOGUE_BASIC_DETAILS p ,
  PRODUCT_XSELL_ASSOCIATION@grdbtoopruat.world ps ,
  CATALOGUE_BASIC_DETAILS d
WHERE p.CATALOGUE_NUMBER    = ps.parent_CATNO
AND d.CATALOGUE_NUMBER      = ps.CHILD_CATNO
AND p.Brand                IN('LEX','LAI','LWI')
AND p.brand                 = ps.channel_code
AND PS.REDUNDANT_INDICATOR IS NULL
AND TRUNC(ps.date_end)      > TRUNC(SYSDATE)
ORDER BY p.CATALOGUE_NUMBER,
  p.BRAND;


V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(16,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_XSELL_PRODUCTS');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_XSELL_PRODUCTS COMPUTE STATISTICS';
SP_ERROR_LOG(17,V_PROCE_NAME,SYSDATE,'TABLE CATALOGUE_XSELL_PRODUCTS ANALYZED');


SP_ERROR_LOG(18,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_METADATA TABLE STARTED');
--7
INSERT INTO CATALOGUE_METADATA
WITH CATALOGUE_DD_STOCK_CHECK AS ---- DD CATALOGUE STOCK CHECk
  ( SELECT DISTINCT cbd.CATALOGUE_NUMBER CATALOGUE_NUMBER ,
    'YES' AS DD_STOCK_QTY
  FROM stock_availability@ATPUAT2COMMONDM.WORLD a,
    CATALOGUE_BASIC_DETAILS cbd
  WHERE 1                    =1
  AND a.line_num             =cbd.CATALOGUE_NUMBER
  AND cbd.dd_indicator      IN (1)
  AND stock_status           ='IS'
  AND availability_lead_time = 0
  AND UPPER(availability_type)      ='CURRENT'
  AND cbd.Brand             IN('LEX','LAI','LWI')
  ),
  CATALOGUE_DC_STOCK_CHECK AS ---- DC CATALOGUE STOCK CHECk
  ( SELECT DISTINCT sk.STYLE CATALOGUE_NUMBER,
    SK.SKU,--pl.PROD_STAT,
    SK.colour_no,
    sk.colour_description,
    sk.colour_text,
    sk.size_description ,
    sa.stock_availability,
    ( CASE sa.stock_availability_code
      WHEN 0
      THEN 'OUT OF STOCK'
      WHEN 1
      THEN 'DC STOCK'
      WHEN 2
      THEN 'ON HOLD'
      WHEN 3
      THEN 'DD STOCK'
      WHEN 4
      THEN 'DD PRE-ORDER'
      WHEN 5
      THEN 'PRODUCT OFF-SALE'
    END ) AS DC_stock_availability_code ,
    pl.QTY DC_STOCK_QTY
  FROM product_availability@GRDBTOSAMUAT.WORLD pa,
    sku@GRDBTOSAMUAT.WORLD sk,
    stock_availability@GRDBTOSAMUAT.WORLD sa,
    CATALOGUE_BASIC_DETAILS cbd ,
    product_location_statuses@GRDBTODMSUAT.WORLD pl
  WHERE pa.sku                   =sk.sku
  AND pa.subscriber_code         ='ATG'
  AND sk.style                   = cbd.CATALOGUE_NUMBER
  AND pa.stock_availability_code =sa.stock_availability_code
  AND sk.sku                     = pl.prod_iD
  AND cbd.Brand                 IN('LEX','LAI','LWI')
  AND cbd.dd_indicator           = 0
  ) ,
  CATALOGUE_DD_SAM_STOCK_CODE AS ----  CATALOGUE STOCK CODE
  ( SELECT DISTINCT sk.STYLE CATALOGUE_NUMBER,
    CASE sa.stock_availability_code
      WHEN 0
      THEN 'OUT OF STOCK'
      WHEN 1
      THEN 'DC STOCK'
      WHEN 2
      THEN 'ON HOLD'
      WHEN 3
      THEN 'DD STOCK'
      WHEN 4
      THEN 'DD PRE-ORDER'
      WHEN 5
      THEN 'PRODUCT OFF-SALE'
    END AS DD_stock_availability_code
  FROM product_availability@GRDBTOSAMUAT.WORLD pa,
    sku@GRDBTOSAMUAT.WORLD sk,
    stock_availability@GRDBTOSAMUAT.WORLD sa,
    CATALOGUE_BASIC_DETAILS cbd ,
    product_location_statuses@GRDBTODMSUAT.WORLD pl
  WHERE pa.sku                   =sk.sku
  AND pa.subscriber_code         ='ATG'
  AND sk.style                   = cbd.CATALOGUE_NUMBER
  AND pa.stock_availability_code =sa.stock_availability_code
  AND sk.sku                     = pl.prod_iD
  AND cbd.dd_indicator           = 1 
  AND cbd.Brand                 IN('LEX','LAI','LWI')
  ), 
  CATALOGUE_MULTIPART_DETAILS AS ---- MULTIPART
  ( SELECT DISTINCT cbd.* ,
    prm.MULTI_PARTS_IND
  FROM CATALOGUE_basic_details cbd ,
    multi_part_cat_no_suffix@grdbtoopruat.world mp ,
    PRODUCT_RETURNS_PARAMETERS@grdbtoopruat.world prm
  WHERE 1                     =1
  AND cbd.CATALOGUE_NUMBER    = mp.CATALOGUE_NUMBER
  AND cbd.buyers_range_number = mp.buyers_range_number
  AND cbd.outlet_code         = mp.OUTLET_CODE
  AND cbd.suffix              = mp.CATALOGUE_NUMBER_SUFFIX
  AND cbd.line_item_ref       = mp.line_item_ref
  AND cbd.product_id          = prm.product_id
  AND prm.MULTI_PARTS_IND     = 1
  AND cbd.Brand              IN ( 'LEX','LAI','LWI')
  AND cbd.dd_indicator       IN (1, 0) -- DC
  ORDER BY cbd.CATALOGUE_NUMBER ,
    cbd.Brand
  ),
  CATALOGUE_WITH_PRODUCT_SERVICE AS ---- PRODUCT WITH SERVICE
  ( SELECT DISTINCT p.CATALOGUE_NUMBER ,
    p.line_item_description,
    ps.service_option_number SERVICE_CATALOGUE_NUMBER, --ps.service_suffix ,
    d.line_item_description SERVICE_line_item_description
  FROM CATALOGUE_BASIC_DETAILS p ,
    product_service@grdbtoopruat.world ps ,
    CATALOGUE_BASIC_DETAILS d
  WHERE p.CATALOGUE_NUMBER = ps.parent_CATALOGUE_NUMBER
  AND d.CATALOGUE_NUMBER   = ps.service_option_number
  AND d.line_item_description LIKE 'COLLECT%'
  AND d.Brand IN('LEX','LAI','LWI')
  ORDER BY p.CATALOGUE_NUMBER
  ),
  CATALOGUE_PROMOTION_OFFER AS ------ RETAIL OFFER
  ( SELECT DISTINCT cbd.CATALOGUE_NUMBER ,
    mvmb_prom.discount_scheme_code Promotion_Code,
    mvmb_prom.mb_promotion_number MultiBuy_Promotion_Num,
    mvmb_prom.mb_promotion_description
  FROM multibuy_product@grdbtoopruat.world mvmb_prod,
    multibuy_promo_brand_assoc@grdbtoopruat.world mvmb_prom_brd_ass,
    multibuy_promotion@grdbtoopruat.world mvmb_prom ,
    CATALOGUE_BASIC_DETAILS cbd
  WHERE 1=1
  AND TRUNC(sysdate) BETWEEN TRUNC(mvmb_prom.date_start) AND NVL(TRUNC(mvmb_prom.date_end), TRUNC(sysdate))
  AND TRUNC(sysdate) BETWEEN TRUNC(mvmb_prod.date_start) AND NVL(TRUNC(mvmb_prod.date_end), TRUNC(sysdate))
  AND mvmb_prod.mb_promotion_number = mvmb_prom_brd_ass.mb_promotion_number
  AND mvmb_prom_brd_ass.brand_ref   = cbd.Brand
  AND cbd.Brand                    IN('LEX','LAI','LWI')
  AND mvmb_prod.mb_promotion_number = mvmb_prom.mb_promotion_number
  AND mvmb_prom.mb_status           = 1
  AND cbd.CATALOGUE_NUMBER          = mvmb_prod.CATALOGUE_NUMBER
  )
SELECT DISTINCT cbd.CATALOGUE_NUMBER ,
  cbd.Brand ,
    (
  CASE CBD.DD_indicator
    WHEN 1
    THEN 'DD'
    WHEN 0
    THEN 'DC'
  END ) AS DD_indicator ,
-- LEX 0,100,150,200,400 -- LAI 0,50,99-- lWI 0,100,150,200
(
  CASE
  WHEN (cbd.Price > 400 AND cbd.BRAND IN ('LEX')) THEN
    400
  WHEN(cbd.Price > 200 AND cbd.BRAND IN ('LEX')) THEN
    200
  WHEN(cbd.Price > 150 AND cbd.BRAND IN ('LEX')) THEN
    150
  WHEN(cbd.Price > 100 AND cbd.BRAND IN ('LEX')) THEN
    100
  WHEN(cbd.Price > 0 AND cbd.BRAND IN ('LEX')) THEN
    0
  WHEN(cbd.Price > 99 AND cbd.BRAND IN ('LAI')) THEN
    99
  WHEN(cbd.Price > 50 AND cbd.BRAND IN ('LAI')) THEN
    50
  WHEN(cbd.Price > 0 AND cbd.BRAND IN ('LAI')) THEN
    0
  WHEN(cbd.Price > 200 AND cbd.BRAND IN ('LWI')) THEN
    200
  WHEN(cbd.Price > 150 AND cbd.BRAND IN ('LWI')) THEN
    150
  WHEN(cbd.Price > 100 AND cbd.BRAND IN ('LWI')) THEN
    100
  WHEN(cbd.Price > 0 AND cbd.BRAND IN ('LWI')) THEN
    0
  END )
AS
  MOV,
  cbd.price,
   (
  CASE
    WHEN UPPER(cbd.line_item_description) LIKE '%LAPTOP%'
    THEN 'LAPTOP'
    WHEN UPPER(cbd.line_item_description) LIKE '%TAB%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%FRIDGE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%WASHING%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%TV%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%CAMERA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%MOBILE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%SOCKET%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%SWITCH%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%WIRELESS%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%PRINTER%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%VACCUM%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%DISHWASHER%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%CHIMNEY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%CABLE%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%FAN%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%LIGHT%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%MICRO%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%ELECTRIC%'
    THEN 'ELECTRICAL'
    WHEN UPPER(cbd.line_item_description) LIKE '%SAMSUNG%'
    THEN 'SAMSUNG'
    WHEN UPPER(cbd.line_item_description) LIKE '%LG%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%SONY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%MOTOROLA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%NOKIA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%PANASONIC%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%PHILIPS%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%TOSHIBA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%BOSCH%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%APPLE%'
    THEN 'APPLE'
    WHEN UPPER(cbd.line_item_description) LIKE '%SANSUI%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(cbd.line_item_description) LIKE '%SOFA%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(cbd.line_item_description) LIKE '%MATTRESS%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(cbd.line_item_description) LIKE '%CURTAINS%'
    THEN 'UPHOLESTRY'
    ELSE 'OTHERS'
  END )                                AS PRODUCT_CATEGORY,
  cbd.line_item_description  AS PRODUCT_DESCRIPTION ,
  cbd.product_type_code ,
  cbd.Carrier_code,-- cbd.suffix,
  cbd.CARRIER_REFERENCE ,
  cbd.CARRIER_REF_DESCRIPTION,
  ( CASE WHEN NVL(cmd.MULTI_PARTS_IND,0) = 1 THEN 'YES' ELSE 'NO' END ) AS MULTI_PART_ITEM,
  cbd1.SKU,
  --cbd1.colour_no,
  cbd1.colour_description,
  --cbd1.colour_text,
  cbd1.size_description ,
  cbd1.stock_availability,
  cbd1.DC_stock_availability_code ,
  cbd1.DC_STOCK_QTY,
  cs.DD_stock_availability_code,
(  CASE   WHEN cds.DD_STOCK_QTY = 'YES' THEN 'YES' ELSE 'NO' END )AS DD_STOCK_AVAILABLE ,
  CDSD1.DC_STANDARD_DELIVERY ,
  CDSD.NEXTDAY_AVAILABLE_IND,
  CDSD.DD_EXPRESS_DELIVERY,
  CDSD.DD_STANDARD_DELIVERY,
  cps.SERVICE_CATALOGUE_NUMBER ,
  cps.SERVICE_LINE_ITEM_DESCRIPTION ,
  cpo.PROMOTION_CODE ,
  cpo.MULTIBUY_PROMOTION_NUM,
  cpo.MB_PROMOTION_DESCRIPTION ,
  CLI.locn_id,
  CLI.locn_name ,
  --CBC.B2b_END_DATE,
  CBC.B2b_CANCEL ,
  ( CASE  WHEN NVL(hdn.HDN_2_MAN_IND,0) = 1 THEN 'YES' ELSE 'NO' END ) AS TWO_MAN_PRODUCT  ,
  dbc.DIARY_BOOKING_CODE ,
(  CASE WHEN as1.NODS_DISPOSAL_STATUS = 10 THEN 'YES' ELSE 'NO' END ) AS AWAITING_STOCK ,
  cbd.WARRANTY_INDICATOR,
  cbd.WARRANTY_CODE,
 ( CASE WHEN cbd.CARRIER_REFERENCE in (10)  and CBd.carrier_ref_description = 'Yodel (LGT)' and Cbd.carrier_code ='FXLP1' and cbd.product_type_code = 1 THEN 'YES' ELSE 'NO' END) AS COLLECT_PLUS,
 TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
FROM CATALOGUE_BASIC_DETAILS cbd ,
  CATALOGUE_DD_STOCK_CHECK cds ,
  CATALOGUE_DC_STOCK_CHECK cbd1,
  CATALOGUE_DD_SAM_STOCK_CODE cs,
  CATALOGUE_MULTIPART_DETAILS cmd,
  CATALOGUE_WITH_PRODUCT_SERVICE cps,
  CATALOGUE_PROMOTION_OFFER cpo,
  CATALOGUE_DC_STNDRD_DLVRY CDSD1 ,
  CATALOGUE_DDEXP_STNDRD_DLVRY CDSD,
  CATALOGUE_B2B_CANCEL CBC ,
  CATALOGUE_LOCN_ID CLI ,
  HDN_2_MAN_IND HDN ,
  diary_booking_code dbc,
  awating_stock as1
WHERE cbd.CATALOGUE_NUMBER = cds.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = cbd1.CATALOGUE_NUMBER (+)
AND cbd.CATALOGUE_NUMBER   = cs.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = cmd.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = cps.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = Cpo.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = CDSD1.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = CDSD.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = CBC.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = CLI.CATALOGUE_NUMBER(+)
AND cbd.CATALOGUE_NUMBER   = HDN.QUOTABLE_PRODUCT_LINE(+)
AND cbd.CATALOGUE_NUMBER   = dbc.QUOTABLE_PRODUCT_LINE(+)
AND cbd.CATALOGUE_NUMBER   = as1.QUOTABLE_PRODUCT_LINE(+)
ORDER BY cbd.CATALOGUE_NUMBER,
  CBD.BRAND,
  dd_indicator ;

V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(19,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_METADATA');

COMMIT;

SP_ERROR_LOG(20,V_PROCE_NAME,SYSDATE,'INSERT INTO CATALOGUE_NON_IFC_PRICEMATCH STARTED');
--7

INSERT INTO CATALOGUE_NON_IFC_PRICEMATCH
WITH flyers AS
  (SELECT DISTINCT p.catalogue_number ,
    p.outlet_code ,
    p.buyers_range_number ,
    c.channel_code ,
    p.dd_indicator,
    p.product_type_code,
    p.CARRIER_CODE,
    p.WARRANTY_INDICATOR,
    p.WARRANTY_CODE,
    p.line_item_ref ,
    o.restriction_code ,
    oe.business_description ,
    op.selling_price ,
    p.line_item_description
  FROM channel@grdbtoopruat.world c,
    product@grdbtoopruat.world p,
    outlet_extract@grdbtoopruat.world oe,
    offer@grdbtoopruat.world o,
    offer_price@grdbtoopruat.world op,
    option_offer_price@grdbtoopruat.world oop,
    product_option@grdbtoopruat.world po,
    payment_term@grdbtoopruat.world pt
  WHERE 1 =1
  AND TRUNC(sysdate) BETWEEN TRUNC(oe.outlet_on_sale_date) AND TRUNC(oe.outlet_off_sale_date)
  AND TRUNC(sysdate) BETWEEN TRUNC(o.offer_onsale_date) AND TRUNC(o.offer_offsale_date)
  AND oe.business_description  = 'Flyers'
  AND oe.outlet_code           = p.outlet_code
  AND c.channel_code          IN( 'LEX','LAI','LWI') --UPPER (ca_rec_in.principal_brand)
  AND p.dd_indicator           = 0
  AND c.restriction_code       = o.restriction_code
  AND o.outlet_code            = p.outlet_code
  AND o.buyers_range_number    = p.buyers_range_number
  AND o.line_item_ref          = p.line_item_ref
  AND op.outlet_code           = o.outlet_code
  AND op.buyers_range_number   = o.buyers_range_number
  AND op.line_item_ref         = o.line_item_ref
  AND op.offer_number          = o.offer_number
  AND op.offer_version_number  = o.offer_version_number
  AND oop.outlet_code          = op.outlet_code
  AND oop.buyers_range_number  = op.buyers_range_number
  AND oop.line_item_ref        = op.line_item_ref
  AND oop.offer_number         = op.offer_number
  AND oop.offer_version_number = op.offer_version_number
  AND oop.price_break_number   = op.price_break_number
  AND oop.selling_price_number = op.selling_price_number
  AND po.outlet_code           = oop.outlet_code
  AND po.buyers_range_number   = oop.buyers_range_number
  AND po.line_item_ref         = oop.line_item_ref
  AND po.colour_no             = oop.colour_no
  AND po.size_no               = oop.size_no
  AND pt.selling_price_number  = op.selling_price_number
  AND pt.outlet_code           = op.outlet_code
  AND pt.buyers_range_number   = op.buyers_range_number
  AND pt.line_item_ref         = op.line_item_ref
  AND pt.offer_number          = op.offer_number
  AND pt.offer_version_number  = op.offer_version_number
    -- AND (
    --      ( op.selling_price - ca_rec_psp.lower_request_price_tolerance <= ca_rec_in.requested_price
    --      AND op.selling_price + ca_rec_psp.upper_request_price_tolerance >= ca_rec_in.requested_price)
    --)
    --  AND pt.total_selling_price != ca_rec_in.catalogue_amt
  AND NOT EXISTS
    (SELECT 'X'
    FROM flash_sales_outlet@grdbtoopruat.world fsa
    WHERE fsa.outlet_code  = p.outlet_code
    AND fsa.redundant_ind IS NULL
    )
  ) ,
  ecomm AS
  (SELECT DISTINCT p.catalogue_number ,
    p.outlet_code ,
    p.buyers_range_number ,
    c.channel_code ,
    p.dd_indicator,
    p.product_type_code,
    p.CARRIER_CODE,
    p.WARRANTY_INDICATOR,
    p.WARRANTY_CODE,
    p.line_item_ref ,
    o.restriction_code ,
    oe.business_description ,
    op.selling_price ,
    p.line_item_description 
  FROM channel@grdbtoopruat.world c,
    product@grdbtoopruat.world p,
    outlet_extract@grdbtoopruat.world oe,
    offer@grdbtoopruat.world o,
    offer_price@grdbtoopruat.world op,
    option_offer_price@grdbtoopruat.world oop,
    product_option@grdbtoopruat.world po,
    payment_term@grdbtoopruat.world pt
  WHERE 1 =1
  AND TRUNC(sysdate) BETWEEN TRUNC(oe.outlet_on_sale_date) AND TRUNC(oe.outlet_off_sale_date)
  AND TRUNC(sysdate) BETWEEN TRUNC(o.offer_onsale_date) AND TRUNC(o.offer_offsale_date)
  AND oe.business_description  = 'E-Commerce'
  AND oe.outlet_code           = p.outlet_code
  AND c.channel_code          IN( 'LEX','LAI','LWI') --UPPER (ca_rec_in.principal_brand)
  AND p.dd_indicator           = 0
  AND c.restriction_code       = o.restriction_code
  AND o.outlet_code            = p.outlet_code
  AND o.buyers_range_number    = p.buyers_range_number
  AND o.line_item_ref          = p.line_item_ref
  AND op.outlet_code           = o.outlet_code
  AND op.buyers_range_number   = o.buyers_range_number
  AND op.line_item_ref         = o.line_item_ref
  AND op.offer_number          = o.offer_number
  AND op.offer_version_number  = o.offer_version_number
  AND oop.outlet_code          = op.outlet_code
  AND oop.buyers_range_number  = op.buyers_range_number
  AND oop.line_item_ref        = op.line_item_ref
  AND oop.offer_number         = op.offer_number
  AND oop.offer_version_number = op.offer_version_number
  AND oop.price_break_number   = op.price_break_number
  AND oop.selling_price_number = op.selling_price_number
  AND po.outlet_code           = oop.outlet_code
  AND po.buyers_range_number   = oop.buyers_range_number
  AND po.line_item_ref         = oop.line_item_ref
  AND po.colour_no             = oop.colour_no
  AND po.size_no               = oop.size_no
  AND pt.selling_price_number  = op.selling_price_number
  AND pt.outlet_code           = op.outlet_code
  AND pt.buyers_range_number   = op.buyers_range_number
  AND pt.line_item_ref         = op.line_item_ref
  AND pt.offer_number          = op.offer_number
  AND pt.offer_version_number  = op.offer_version_number
    --and  op.selling_price  >200
    -- AND (
    --      ( op.selling_price - ca_rec_psp.lower_request_price_tolerance <= ca_rec_in.requested_price
    --      AND op.selling_price + ca_rec_psp.upper_request_price_tolerance >= ca_rec_in.requested_price)
    --)
    --  AND pt.total_selling_price != ca_rec_in.catalogue_amt
  AND NOT EXISTS
    (SELECT 'X'
    FROM flash_sales_outlet@grdbtoopruat.world fsa
    WHERE fsa.outlet_code  = p.outlet_code
    AND fsa.redundant_ind IS NULL
    )
  )
SELECT DISTINCT flyers.catalogue_number catalogue_number ,
 ( CASE WHEN UPPER(flyers.CHANNEL_CODE) = 'LEX' THEN 'VERY' WHEN UPPER(flyers.CHANNEL_CODE) = 'LAI' THEN 'LITTLEWOODS' WHEN UPPER(flyers.CHANNEL_CODE) = 'LWI' THEN 'LITTLEWOODS IRELAND' END ) BRAND ,
  (
   CASE flyers.DD_indicator
    WHEN 1
    THEN 'DD'
    WHEN 0
    THEN 'DC'
  END ) AS DD_indicator ,
    (
  CASE
  WHEN (flyers.selling_price > 400 AND flyers.CHANNEL_CODE IN ('LEX')) THEN
    400
  WHEN(flyers.selling_price > 200 AND flyers.CHANNEL_CODE IN ('LEX')) THEN
    200
  WHEN(flyers.selling_price > 150 AND flyers.CHANNEL_CODE IN ('LEX')) THEN
    150
  WHEN(flyers.selling_price > 100 AND flyers.CHANNEL_CODE IN ('LEX')) THEN
    100
  WHEN(flyers.selling_price > 0 AND flyers.CHANNEL_CODE IN ('LEX')) THEN
    0
  WHEN(flyers.selling_price > 99 AND flyers.CHANNEL_CODE IN ('LAI')) THEN
    99
  WHEN(flyers.selling_price > 50 AND flyers.CHANNEL_CODE IN ('LAI')) THEN
    50
  WHEN(flyers.selling_price > 0 AND flyers.CHANNEL_CODE IN ('LAI')) THEN
    0
  WHEN(flyers.selling_price > 200 AND flyers.CHANNEL_CODE IN ('LWI')) THEN
    200
  WHEN(flyers.selling_price > 150 AND flyers.CHANNEL_CODE IN ('LWI')) THEN
    150
  WHEN(flyers.selling_price > 100 AND flyers.CHANNEL_CODE IN ('LWI')) THEN
    100
  WHEN(flyers.selling_price > 0 AND flyers.CHANNEL_CODE IN ('LWI')) THEN
    0
  END )
AS
  MOV,
   (
  CASE
    WHEN UPPER(flyers.line_item_description) LIKE '%LAPTOP%'
    THEN 'LAPTOP'
    WHEN UPPER(flyers.line_item_description) LIKE '%TAB%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%FRIDGE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%WASHING%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%TV%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%CAMERA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%MOBILE%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%SOCKET%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%SWITCH%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%WIRELESS%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%PRINTER%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%VACCUM%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%DISHWASHER%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%CHIMNEY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%CABLE%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%FAN%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%LIGHT%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%MICRO%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%ELECTRIC%'
    THEN 'ELECTRICAL'
    WHEN UPPER(flyers.line_item_description) LIKE '%SAMSUNG%'
    THEN 'SAMSUNG'
    WHEN UPPER(flyers.line_item_description) LIKE '%LG%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%SONY%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%MOTOROLA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%NOKIA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%PANASONIC%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%PHILIPS%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%TOSHIBA%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%BOSCH%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%APPLE%'
    THEN 'APPLE'
    WHEN UPPER(flyers.line_item_description) LIKE '%SANSUI%'
    THEN 'ELECTRICAL_ELECTRONIC'
    WHEN UPPER(flyers.line_item_description) LIKE '%SOFA%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(flyers.line_item_description) LIKE '%MATTRESS%'
    THEN 'UPHOLESTRY'
    WHEN UPPER(flyers.line_item_description) LIKE '%CURTAINS%'
    THEN 'UPHOLESTRY'
    ELSE 'OTHERS'
  END )                                AS PRODUCT_CATEGORY,
  flyers.line_item_description,
  flyers.product_type_code,
  flyers.CARRIER_CODE,
 (CASE  WHEN flyers.WARRANTY_INDICATOR = 'Y' THEN 'YES'  ELSE 'NO' END ) AS WARRANTY_AVAILABLE ,
  flyers.WARRANTY_CODE,
  flyers.line_item_ref line_item_ref ,
   flyers.outlet_code ,
  flyers.buyers_range_number ,
  ecomm.selling_price connect_selling_price ,
  flyers.selling_price ATG_selling_price ,
  TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE
FROM ecomm ,
  flyers
WHERE 1                    =1
AND ecomm.catalogue_number = flyers.catalogue_number
AND ecomm.channel_code     = flyers.channel_code
AND ecomm.dd_indicator     = flyers.dd_indicator
  --AND ecomm.outlet_code         = flyers.outlet_code
  --AND ecomm.suffix              = flyers.suffix
AND ecomm.buyers_range_number = flyers.buyers_range_number
AND ecomm.line_item_ref       = flyers.line_item_ref
AND ecomm.restriction_code    = flyers.restriction_code
AND ecomm.selling_price       > flyers.selling_price
ORDER BY flyers.catalogue_number ,
  flyers.line_item_ref ,
  ecomm.selling_price ;



V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(21,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into CATALOGUE_NON_IFC_PRICEMATCH');



COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_METADATA COMPUTE STATISTICS';
SP_ERROR_LOG(22,V_PROCE_NAME,SYSDATE,'SP_REFRESH_CATALOGUE_METADATA TABLE CATALOGUE_METADATA ANALYZED');

/* ---Dont truncate for now else debugging will be a problem---
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_BASIC_DETAILS REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_B2B_CANCEL REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_DC_STNDRD_DLVRY REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_DDEXP_STNDRD_DLVRY REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_LOCN_ID REUSE STORAGE';
--EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_XSELL_PRODUCTS REUSE STORAGE';
--EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_METADATA REUSE STORAGE';
--EXECUTE IMMEDIATE 'CATALOGUE_NON_IFC_PRICEMATCH';
*/



EXCEPTION WHEN OTHERS THEN
 SP_ERROR_LOG(23,V_PROCE_NAME,SYSDATE,'RA_RETURN_MSG = ' ||  'Error encountered. Error Code =>  ' || SQLCODE || '. Error Message =>  '|| SQLERRM|| ' Error Line. '||DBMS_UTILITY.format_error_backtrace()) ;
 
END SP_REFRESH_CATALOGUE_METADATA;
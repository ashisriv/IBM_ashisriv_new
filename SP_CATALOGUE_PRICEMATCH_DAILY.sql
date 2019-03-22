create or replace 
PROCEDURE SP_CATALOGUE_PRICEMATCH_DAILY
AS
V_INS_CNT NUMBER;
V_PROCE_NAME    ERROR_LOG.PROCE_NAME%TYPE;
BEGIN
---truncate all tables ---

V_PROCE_NAME := 'SP_CATALOGUE_PRICEMATCH_DAILY';

DELETE FROM ERROR_LOG where PROCE_NAME = V_PROCE_NAME and TRUNC(LOG_DATE) < TRUNC(SYSDATE);

SP_ERROR_LOG(1,V_PROCE_NAME,SYSDATE, 'TRUNCATION STARTED');

EXECUTE IMMEDIATE 'TRUNCATE TABLE CATALOGUE_PRICEMATCH_DAILY REUSE STORAGE';


SP_ERROR_LOG(2,V_PROCE_NAME,SYSDATE, 'INSERT INTO CATALOGUE_PRICEMATCH_DAILY TABLE STARTED');

INSERT INTO CATALOGUE_PRICEMATCH_DAILY 
select
a.CATALOGUE_NUMBER ,
a.BRAND,
a.DD_INDICATOR,
a.MOV ,
a.PRODUCT_CATEGORY ,
a.LINE_ITEM_DESCRIPTION,
a.PRODUCT_TYPE_CODE,
a.CARRIER_CODE,
a.WARRANTY_AVAILABLE,
a.WARRANTY_CODE,
a.LINE_ITEM_REF,
a.OUTLET_CODE,
a.BUYERS_RANGE_NUMBER,
a.CONNECT_SELLING_PRICE,
a.ATG_SELLING_PRICE,
a.DATA_REFRESH_DATE 
from
------------------------------------------------------------  VERY FOR CREDIT OFFER ------------------------------------------------------------------------------------------------------------------------
( -- VERY TAKE3 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 0 and rownum < 100
UNION -- VERY TAKE 6 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION -- VERY TAKE 12 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 400 and rownum < 100
UNION --VERY BNPL 6 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 100 and rownum < 100
UNION  -- VERY BNPL 9 REVOLVER
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 150 and rownum < 100
UNION  -- VERY BNPL 12 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION  -- VERY Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DD'    and MOV > 99  and rownum < 100

UNION  -- VERY TAKE3 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'     and MOV > 0 and rownum < 100
UNION -- VERY TAKE 6 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION -- VERY TAKE 12 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'      and MOV > 400 and rownum < 100
UNION --VERY BNPL 6 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'      and MOV > 100 and rownum < 100
UNION  -- VERY BNPL 9 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'      and MOV > 150 and rownum < 100
UNION  -- VERY BNPL 12 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION  -- VERY Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'      and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' AND  DD_INDICATOR = 'DC'       and MOV > 99  and rownum < 100

------------------------------------------------------------------------------------------- VERY CREDIT OFFER DONE -----------------------------------------------
------------------------------------------------------------  LAI FOR CREDIT OFFER ------------------------------------------------------------------------------------------------------------------------

UNION  -- LAI TAKE3 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 0 and rownum < 100
UNION -- LAI TAKE 6 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION -- LAI TAKE 12 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 400 and rownum < 100
UNION --LAI BNPL 6 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 100 and rownum < 100
UNION  -- LAI BNPL 9 REVOLVER
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 150 and rownum < 100
UNION  -- LAI BNPL 12 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION  -- LAI Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DD'    and MOV > 99  and rownum < 100

UNION  -- LAI TAKE3 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'     and MOV > 0 and rownum < 100
UNION -- LAI TAKE 6 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION -- LAI TAKE 12 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'      and MOV > 400 and rownum < 100
UNION --LAI BNPL 6 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'      and MOV > 100 and rownum < 100
UNION  -- LAI BNPL 9 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'      and MOV > 150 and rownum < 100
UNION  -- LAI BNPL 12 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION  -- LAI Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'      and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' AND  DD_INDICATOR = 'DC'       and MOV > 99  and rownum < 100

------------------------------------------------------------------------------------------- LAI CREDIT OFFER DONE -----------------------------------------------
------------------------------------------------------------  LWI FOR CREDIT OFFER ------------------------------------------------------------------------------------------------------------------------

UNION  -- LWI TAKE3 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 0 and rownum < 100
UNION -- LWI TAKE 6 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION -- LWI TAKE 12 DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 400 and rownum < 100
UNION --LWI BNPL 6 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 100 and rownum < 100
UNION  -- LWI BNPL 9 REVOLVER
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 150 and rownum < 100
UNION  -- LWI BNPL 12 REVOLVER DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 200 and rownum < 100
UNION  -- LWI Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DD'    and MOV > 99  and rownum < 100

UNION  -- LWI TAKE3 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'     and MOV > 0 and rownum < 100
UNION -- LWI TAKE 6 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION -- LWI TAKE 12 DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'      and MOV > 400 and rownum < 100
UNION --LWI BNPL 6 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'      and MOV > 100 and rownum < 100
UNION  -- LWI BNPL 9 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'      and MOV > 150 and rownum < 100
UNION  -- LWI BNPL 12 REVOLVER DC
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'     and MOV > 200 and rownum < 100
UNION  -- LWI Ifc 24, IFC 48 DD UPHOLESTRY DD
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'      and MOV > 50  and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' AND  DD_INDICATOR = 'DC'       and MOV > 99  and rownum < 100

------------------------------------------------------------------------------------------- LWI CREDIT OFFER DONE -------------------------------------------------------------------------

UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 100
UNION  -- VERY IFC 24
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 500
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'VERY' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 500

UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 100
UNION  -- LAI IFC 24
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 500
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 500

UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DC'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 100
UNION  -- LWI IFC 24
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL' and MOV > 0 and rownum < 500
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'SAMSUNG' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'APPLE' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'    
and  UPPER(PRODUCT_CATEGORY)= 'LAPTOP' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'UPHOLESTRY' and MOV > 0 and rownum < 100
UNION
select distinct cbd.*  from CATALOGUE_NON_IFC_PRICEMATCH cbd where BRAND = 'LITTLEWOODS IRELAND' and DD_INDICATOR = 'DD'   
and  UPPER(PRODUCT_CATEGORY)= 'ELECTRICAL_ELECTRONIC' and MOV > 0 and rownum < 500

) a 
order by Catalogue_number,BRAND,DD_INDICATOR

;

COMMIT;


V_INS_CNT := SQL%ROWCOUNT;

SP_ERROR_LOG(3,V_PROCE_NAME,SYSDATE, V_INS_CNT ||' Rows inserted into CATALOGUE_PRICEMATCH_DAILY');

COMMIT;

EXCEPTION WHEN OTHERS THEN
 SP_ERROR_LOG(5,V_PROCE_NAME,SYSDATE,'RA_RETURN_MSG = ' ||  'Error encountered. Error Code =>  ' || SQLCODE || '. Error Message =>  '|| SQLERRM|| ' Error Line. '||DBMS_UTILITY.format_error_backtrace()) ;
 
END SP_CATALOGUE_PRICEMATCH_DAILY;
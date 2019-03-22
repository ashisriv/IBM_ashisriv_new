create or replace 
PROCEDURE SP_REFRESH_VOUCHER
AS
V_INS_CNT NUMBER;
V_PROCE_NAME    ERROR_LOG.PROCE_NAME%TYPE;
BEGIN
---truncate all tables ---
V_PROCE_NAME := 'SP_REFRESH_VOUCHER';

DELETE FROM ERROR_LOG where PROCE_NAME = V_PROCE_NAME and TRUNC(LOG_DATE) < TRUNC(SYSDATE);

SP_ERROR_LOG(1,V_PROCE_NAME,SYSDATE, 'SP_REFRESH_VOUCHER START');
--DBMS_OUTPUT.PUT_LINE('TRUNCATION STARTED');

EXECUTE IMMEDIATE 'TRUNCATE TABLE VALID_DISCOUNT_CODE REUSE STORAGE';
EXECUTE IMMEDIATE 'TRUNCATE TABLE VALID_VOUCHER_CODE REUSE STORAGE';


--1 VALID_DISCOUNT_CODE
--DBMS_OUTPUT.PUT_LINE('INSERT INTO VALID_DISCOUNT_CODE TABLE STARTED');

SP_ERROR_LOG(2,V_PROCE_NAME,SYSDATE, 'INSERT INTO VALID_DISCOUNT_CODE TABLE STARTED');


INSERT INTO VALID_DISCOUNT_CODE
   SELECT DISTINCT ds.* ,TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE --getCurrMBOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product,
      control@grdbtoopruat.world control ,
      discount_scheme@GRDBTOCAMUAT.WORLD ds
    WHERE control.control_number                    = 2
    AND product.catalogue_number                    = ds.discount_scheme_code
    AND outlet_extract.outlet_code                  = product.outlet_code
    AND outlet_extract.season_code                  = control.season_code
    AND TRUNC(outlet_extract.outlet_on_sale_date)  <= TRUNC(sysdate)
    AND TRUNC(outlet_extract.outlet_off_sale_date) >= TRUNC(sysdate)
    AND outlet_extract.business_description        IN ('Main Books','Brochures')
    AND offer.outlet_code                           = product.outlet_code
    AND offer.buyers_range_number                   = product.buyers_range_number
    AND offer.line_item_ref                         = product.line_item_ref
    AND offer.restriction_code                     IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)             <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)            >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator              = 'D'
    AND outlet_extract.channel_code                <> 'LIN'
    AND ds.redundant_ind                           IS NULL
    AND ds.targeted_tc_only_ind                    IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* ,TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE-- getNonMBOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer ,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product,
      discount_scheme@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number           = ds.discount_scheme_code
    AND outlet_extract.outlet_code           = product.outlet_code
    AND outlet_extract.business_description <> 'E-Commerce'
    AND outlet_extract.business_description <> 'Main Books'
    AND outlet_extract.business_description <> 'Brochures'
    AND offer.outlet_code                    = product.outlet_code
    AND offer.buyers_range_number            = product.buyers_range_number
    AND offer.line_item_ref                  = product.line_item_ref
    AND offer.restriction_code              IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)      <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)     >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator       = 'D'
    AND ds.redundant_ind                    IS NULL
    AND ds.targeted_tc_only_ind             IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE -- getMBOfferForInvalidSuffix
    FROM catalogue_number_and_suffix@grdbtoopruat.world catalogue_number_and_suffix,
      offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      discount_scheme@GRDBTOCAMUAT.WORLD ds
    WHERE catalogue_number_and_suffix.catalogue_number = ds.discount_scheme_code
    AND offer.restriction_code                        IN ('0','8','11')
    AND offer.outlet_code                              = catalogue_number_and_suffix.outlet_code
    AND offer.buyers_range_number                      = catalogue_number_and_suffix.buyers_range_number
    AND offer.line_item_ref                            = catalogue_number_and_suffix.line_item_ref
    AND catalogue_number_and_suffix.outlet_code        = outlet_extract.outlet_code
    AND outlet_extract.business_description           IN ('Main Books','Brochures','E-Commerce')
    AND TRUNC(outlet_extract.outlet_on_sale_date)     <= TRUNC(SYSDATE)
    AND TRUNC(outlet_extract.outlet_off_sale_date)    >= TRUNC(SYSDATE)
    AND ds.redundant_ind                              IS NULL
    AND ds.targeted_tc_only_ind                       IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE-- getPrevARIOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product ,
      discount_scheme@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number                  = ds.discount_scheme_code
    AND outlet_extract.outlet_code                  = product.outlet_code
    AND outlet_extract.business_description        <> 'E-Commerce'
    AND TRUNC(outlet_extract.outlet_on_sale_date)  <= TRUNC(sysdate)
    AND TRUNC(outlet_extract.outlet_off_sale_date) >= TRUNC(sysdate)
    AND outlet_extract.business_description        IN ('Main Books','Brochures')
    AND offer.outlet_code                           = product.outlet_code
    AND offer.buyers_range_number                   = product.buyers_range_number
    AND offer.line_item_ref                         = product.line_item_ref
    AND offer.restriction_code                     IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)             <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)            >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator              = 'D'
    AND ds.redundant_ind                           IS NULL
    AND ds.targeted_tc_only_ind                    IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE ---- getPrevARIOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product ,
      discount_scheme@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number                 = ds.discount_scheme_code
    AND outlet_extract.outlet_code                 = product.outlet_code
    AND TRUNC(outlet_extract.outlet_on_sale_date) <= TRUNC(sysdate)
    AND outlet_extract.business_description NOT   IN ('Main Books','Brochures','E-Commerce')
    AND offer.outlet_code                          = product.outlet_code
    AND offer.buyers_range_number                  = product.buyers_range_number
    AND offer.line_item_ref                        = product.line_item_ref
    AND offer.restriction_code                    IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)            <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)           >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator             = 'D'
    AND ds.redundant_ind                          IS NULL
    AND ds.targeted_tc_only_ind                   IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    
  ;
  
  V_INS_CNT := SQL%ROWCOUNT;

--DBMS_OUTPUT.PUT_LINE(V_INS_CNT ||' Rows inserted into VALID_DISCOUNT_CODE');

SP_ERROR_LOG(3,V_PROCE_NAME,SYSDATE, V_INS_CNT ||' Rows inserted into VALID_DISCOUNT_CODE');

--1 VALID_VOUCHER_CODE

SP_ERROR_LOG(4,V_PROCE_NAME,SYSDATE,'INSERT INTO VALID_VOUCHER_CODE');
  
INSERT INTO   VALID_VOUCHER_CODE
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE --getCurrMBOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product,
      control@grdbtoopruat.world control ,
      voucher_type@GRDBTOCAMUAT.WORLD ds
    WHERE control.control_number                    = 2
    AND product.catalogue_number                    = ds.voucher_code
    AND outlet_extract.outlet_code                  = product.outlet_code
    AND outlet_extract.season_code                  = control.season_code
    AND TRUNC(outlet_extract.outlet_on_sale_date)  <= TRUNC(sysdate)
    AND TRUNC(outlet_extract.outlet_off_sale_date) >= TRUNC(sysdate)
    AND outlet_extract.business_description        IN ('Main Books','Brochures')
    AND offer.outlet_code                           = product.outlet_code
    AND offer.buyers_range_number                   = product.buyers_range_number
    AND offer.line_item_ref                         = product.line_item_ref
    AND offer.restriction_code                     IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)             <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)            >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator              = 'D'
    AND outlet_extract.channel_code                <> 'LIN'
    AND ds.redundant_ind                           IS NULL
    AND ds.targeted_tc_only_ind                    IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE-- getNonMBOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer ,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product,
      voucher_type@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number           = ds.voucher_code
    AND outlet_extract.outlet_code           = product.outlet_code
    AND outlet_extract.business_description <> 'E-Commerce'
    AND outlet_extract.business_description <> 'Main Books'
    AND outlet_extract.business_description <> 'Brochures'
    AND offer.outlet_code                    = product.outlet_code
    AND offer.buyers_range_number            = product.buyers_range_number
    AND offer.line_item_ref                  = product.line_item_ref
    AND offer.restriction_code              IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)      <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)     >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator       = 'D'
    AND ds.redundant_ind                    IS NULL
    AND ds.targeted_tc_only_ind             IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* ,TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE-- getMBOfferForInvalidSuffix
    FROM catalogue_number_and_suffix@grdbtoopruat.world catalogue_number_and_suffix,
      offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      voucher_type@GRDBTOCAMUAT.WORLD ds
    WHERE catalogue_number_and_suffix.catalogue_number = ds.voucher_code
    AND offer.restriction_code                        IN ('0','8','11')
    AND offer.outlet_code                              = catalogue_number_and_suffix.outlet_code
    AND offer.buyers_range_number                      = catalogue_number_and_suffix.buyers_range_number
    AND offer.line_item_ref                            = catalogue_number_and_suffix.line_item_ref
    AND catalogue_number_and_suffix.outlet_code        = outlet_extract.outlet_code
    AND outlet_extract.business_description           IN ('Main Books','Brochures','E-Commerce')
    AND TRUNC(outlet_extract.outlet_on_sale_date)     <= TRUNC(SYSDATE)
    AND TRUNC(outlet_extract.outlet_off_sale_date)    >= TRUNC(SYSDATE)
    AND ds.redundant_ind                              IS NULL
    AND ds.targeted_tc_only_ind                       IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE -- getPrevARIOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product ,
      voucher_type@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number                  = ds.voucher_code
    AND outlet_extract.outlet_code                  = product.outlet_code
    AND outlet_extract.business_description        <> 'E-Commerce'
    AND TRUNC(outlet_extract.outlet_on_sale_date)  <= TRUNC(sysdate)
    AND TRUNC(outlet_extract.outlet_off_sale_date) >= TRUNC(sysdate)
    AND outlet_extract.business_description        IN ('Main Books','Brochures')
    AND offer.outlet_code                           = product.outlet_code
    AND offer.buyers_range_number                   = product.buyers_range_number
    AND offer.line_item_ref                         = product.line_item_ref
    AND offer.restriction_code                     IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)             <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)            >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator              = 'D'
    AND ds.redundant_ind                           IS NULL
    AND ds.targeted_tc_only_ind                    IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
    UNION
    SELECT DISTINCT ds.* , TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SSSS') AS DATA_REFRESH_DATE ---- getPrevARIOfferForCatnoChannel
    FROM offer@grdbtoopruat.world offer,
      outlet_extract@grdbtoopruat.world outlet_extract,
      product@grdbtoopruat.world product ,
      voucher_type@GRDBTOCAMUAT.WORLD ds
    WHERE product.catalogue_number                 = ds.voucher_code
    AND outlet_extract.outlet_code                 = product.outlet_code
    AND TRUNC(outlet_extract.outlet_on_sale_date) <= TRUNC(sysdate)
    AND outlet_extract.business_description NOT   IN ('Main Books','Brochures','E-Commerce')
    AND offer.outlet_code                          = product.outlet_code
    AND offer.buyers_range_number                  = product.buyers_range_number
    AND offer.line_item_ref                        = product.line_item_ref
    AND offer.restriction_code                    IN ('0','8','11')
    AND TRUNC(offer.offer_onsale_date)            <= TRUNC(sysdate)
    AND TRUNC(offer.offer_offsale_date)           >= TRUNC(sysdate)
    AND offer.dominant_offer_indicator             = 'D'
    AND ds.redundant_ind                          IS NULL
    AND ds.targeted_tc_only_ind                   IS NULL
    AND TRUNC(sysdate) BETWEEN TRUNC(ds.date_start) AND TRUNC(ds.date_end)
  ;
  

V_INS_CNT := SQL%ROWCOUNT;

--DBMS_OUTPUT.PUT_LINE(V_INS_CNT ||' Rows inserted into VALID_VOUCHER_CODE');

SP_ERROR_LOG(5,V_PROCE_NAME,SYSDATE,V_INS_CNT ||' Rows inserted into VALID_VOUCHER_CODE');

COMMIT;

EXECUTE IMMEDIATE 'ANALYZE TABLE CATALOGUE_B2B_CANCEL COMPUTE STATISTICS';
--DBMS_OUTPUT.PUT_LINE('TABLE  ANALYZED');

SP_ERROR_LOG(6,V_PROCE_NAME,SYSDATE,' SP_REFRESH_VOUCHER TABLE  ANALYZED');


EXCEPTION WHEN OTHERS THEN
 --DBMS_OUTPUT.PUT_LINE('RA_RETURN_MSG = ' ||  'Error encountered. Error Code =>  ' || SQLCODE || '. Error Message =>  '|| SQLERRM|| ' Error Line. '||DBMS_UTILITY.format_error_backtrace()) ;
 
 SP_ERROR_LOG(7,V_PROCE_NAME,SYSDATE,'SP_REFRESH_VOUCHER : RA_RETURN_MSG = ' ||  'Error encountered. Error Code =>  ' || SQLCODE || '. Error Message =>  '|| SQLERRM|| ' Error Line. '||DBMS_UTILITY.format_error_backtrace());
 
END SP_REFRESH_VOUCHER;
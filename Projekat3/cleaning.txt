SELECT * FROM dataset_for_cleaning;





-- Populate Property Address data
SELECT
    *
FROM
    dataset_for_cleaning
-- WHERE propertyaddress is null
ORDER BY
    parcelid;


-- joining table to itself 
SELECT 
    a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, NVL(a.propertyaddress, b.propertyaddress)
FROM dataset_for_cleaning a
JOIN dataset_for_cleaning b
    ON a.parcelid = b.parcelid
    AND a.uniqueid_ != b.uniqueid_
WHERE a.propertyaddress is null;


CREATE TABLE address (
    id VARCHAR2(128 BYTE),
    prop_address VARCHAR2(150 BYTE)
);

INSERT INTO address
    ( SELECT
        a.parcelid,
        nvl(a.propertyaddress, b.propertyaddress)
    FROM
             dataset_for_cleaning a
        JOIN dataset_for_cleaning b ON a.parcelid = b.parcelid
                                         AND a.uniqueid_ != b.uniqueid_
    WHERE
        a.propertyaddress IS NULL
    );
    
-- select * from address;

UPDATE dataset_for_cleaning t1
SET
    t1.propertyaddress = (
        SELECT
            t2.prop_address
        FROM
            address t2
        WHERE
            t1.parcelid = t2.id and rownum = 1
    )
WHERE
    t1.parcelid IN (
        SELECT
            t2.id
        FROM
            address t2
        WHERE
            t1.parcelid = t2.id and rownum = 1
    );
/*
ERROR - ora-01427: single-row subquery returns more than one row
*/
SELECT 
    a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, NVL(a.propertyaddress, b.propertyaddress)
FROM dataset_for_cleaning a
JOIN dataset_for_cleaning b
    ON a.parcelid = b.parcelid
    AND a.uniqueid_ != b.uniqueid_
WHERE a.propertyaddress is null;


select * from dataset_for_cleaning ;

-- Breaking out Property Address into Individual Columns (Address, City)
SELECT
    propertyaddress
FROM
    dataset_for_cleaning;
    
SELECT
    substr(propertyaddress, 1, instr(propertyaddress, ',', 1) - 1) AS address,
    substr(propertyaddress, instr(propertyaddress, ',', 1) + 1, length(propertyaddress)) AS city
FROM
    dataset_for_cleaning;


alter table dataset_for_cleaning
add property_split_address VARCHAR2(150 BYTE);

update dataset_for_cleaning
set property_split_address = substr(propertyaddress, 1, instr(propertyaddress, ',', 1) - 1);

alter table dataset_for_cleaning
add property_split_city VARCHAR2(150 BYTE);

update dataset_for_cleaning
set property_split_city = substr(propertyaddress, instr(propertyaddress, ',', 1) + 1, length(propertyaddress));


select * from dataset_for_cleaning;





-- Breaking out Owner Address into Individual Columns (Address, City, State)
SELECT
    owneraddress
FROM
    dataset_for_cleaning;

SELECT
    regexp_substr(owneraddress, '[^,]+', 1, 1),
    regexp_substr(owneraddress, '[^,]+', 1, 2),
    regexp_substr(owneraddress, '[^,]+', 1, 3)
FROM
    dataset_for_cleaning;
    
    
alter table dataset_for_cleaning
add owner_split_address VARCHAR2(150 BYTE);

update dataset_for_cleaning
set owner_split_address = regexp_substr(owneraddress, '[^,]+', 1, 1);

alter table dataset_for_cleaning
add owner_split_city VARCHAR2(150 BYTE);

update dataset_for_cleaning
set owner_split_city = regexp_substr(owneraddress, '[^,]+', 1, 2);

alter table dataset_for_cleaning
add owner_split_state VARCHAR2(150 BYTE);

update dataset_for_cleaning
set owner_split_state = regexp_substr(owneraddress, '[^,]+', 1, 3);

select * from dataset_for_cleaning;





-- Change Y and N to Yes and No in Sold as Vacant column
SELECT DISTINCT
    ( soldasvacant ),
    COUNT(soldasvacant)
FROM
    dataset_for_cleaning
GROUP BY
    soldasvacant
ORDER BY
    2;
    
SELECT
    soldasvacant,
    CASE
        WHEN soldasvacant = 'Y' THEN
            'Yes'
        WHEN soldasvacant = 'N' THEN
            'No'
        ELSE
            soldasvacant
    END
FROM
    dataset_for_cleaning;
    
UPDATE dataset_for_cleaning
SET
    soldasvacant =
        CASE
            WHEN soldasvacant = 'Y' THEN
                'Yes'
            WHEN soldasvacant = 'N' THEN
                'No'
            ELSE
                soldasvacant
        END;


SELECT DISTINCT
    ( soldasvacant ),
    COUNT(soldasvacant)
FROM
    dataset_for_cleaning
GROUP BY
    soldasvacant
ORDER BY
    2;




    
-- Remove duplicates
SELECT
    dataset_for_cleaning.*,
    ROW_NUMBER()
    OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference
         ORDER BY
             uniqueid_
    ) AS row_num
FROM
    dataset_for_cleaning
ORDER BY
    parcelid;

with row_num_cte as (
    SELECT
        dataset_for_cleaning.*,
        ROW_NUMBER()
        OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference
             ORDER BY
                 uniqueid_
        ) AS row_num
    FROM
        dataset_for_cleaning
)
SELECT
    *
FROM
    row_num_cte
WHERE
    row_num > 1;
    
    
DELETE FROM dataset_for_cleaning WHERE UniqueID_ in (
    with RowNumCTE AS(
        select dataset_for_cleaning.*, 
            row_number() over (
                partition by ParcelID,
                            PropertyAddress,
                            salePrice,
                            SaleDate,
                            LegalReference
                          ORDER BY
                            UniqueID_
            ) as row_num
            from dataset_for_cleaning --nvh
            )
        select uniqueID_
        from RowNumCTE
        where row_num > 1
);

-- provjera
with row_num_cte as (
    SELECT
        dataset_for_cleaning.*,
        ROW_NUMBER()
        OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference
             ORDER BY
                 uniqueid_
        ) AS row_num
    FROM
        dataset_for_cleaning
)
SELECT
    *
FROM
    row_num_cte
WHERE
    row_num > 1;



-- Delete Unused Columns
/
SELECT
    *
FROM
    dataset_for_cleaning;

ALTER TABLE dataset_for_cleaning
drop (bedrooms, fullbath, halfbath);


SELECT
    *
FROM
    dataset_for_cleaning;
    
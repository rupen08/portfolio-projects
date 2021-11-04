-- Data was downloaded from kaggle.com --
-- It is a nashville housing data which includes various columns --

SELECT * FROM portfolio.dbo.nashville;

-- I have my date column in DateTime --> needed to convert in Date only --
-- I can use convert (data type, expression) to update the new datatype for column --
-- try to check and update later on, if not have to add new cloumn by [alter table add] --
-- SELECT SaleDate, CONVERT(Date,SaleDate) as UpdatedSaleDate From portfolio.dbo.nashville;
-- UPDATE portfolio.dbo.nashville SET SaleDate = CONVERT(Date,SaleDate); 
-- this did't work --
-- Added new column and repeated same thing --
ALTER TABLE 
portfolio.dbo.nashville ADD UpdatedSaleDate Date; -- add new column to the table --
UPDATE portfolio.dbo.nashville SET UpdatedSaleDate = CONVERT(Date,SaleDate); -- this will add new column at the end --


-- owner having more than one property missing address as they are same, resulting in NULL --
SELECT COUNT(DISTINCT(ParcelId)) 
FROM portfolio.dbo.nashville;

-- handle null values in propertyadderess and populate them if needed --
-- perform self join operation to check 
-- around 48K out of 56K are unique parcelID, others are same customers, so address will also be 48K --

SELECT ParcelID, PropertyAddress 
FROM portfolio.dbo.nashville WHERE PropertyAddress IS NULL;  -- only 29 null --

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(b.PropertyAddress, a.PropertyAddress) 
FROM portfolio.dbo.nashville a JOIN portfolio.dbo.nashville b 
ON a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]  
WHERE b.PropertyAddress IS NULL;

UPDATE b SET PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress) 
FROM portfolio.dbo.nashville a JOIN portfolio.dbo.nashville b 
ON a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]  
WHERE b.PropertyAddress IS NULL;

SELECT PropertyAddress 
FROM portfolio.dbo.nashville; -- No null values --

-- breakdown the address into address, city by "," delimeter --
-- to do that i will start from index 1 till "," as "address" and from "," to len(expression) as "city" --
-- to do that need to use substring, charindex which returns number, len function return last index --
-- add new columns for address and city by alter table add columns --

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1), SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) 
FROM portfolio.dbo.nashville;

ALTER TABLE portfolio.dbo.nashville ADD AdderessUpdated VARCHAR(300); 
UPDATE portfolio.dbo.nashville SET AdderessUpdated = SUBSTRING(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1); 

ALTER TABLE portfolio.dbo.nashville ADD City VARCHAR(300); 
UPDATE portfolio.dbo.nashville SET City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) ;

SELECT * FROM portfolio.dbo.nashville;

-- state is available in owner's address --

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),1), -- parsename works in reverse way, 1 for last value after delimeter --
	   PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	   PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM portfolio.dbo.nashville;


ALTER TABLE portfolio.dbo.nashville ADD State VARCHAR(20);
UPDATE portfolio.dbo.nashville SET State = PARSENAME(REPLACE(OwnerAddress,',','.'),1) ;

--update all values in SoldasVacant yes or no --
-- this column as Y, N, YES and NO --
-- convert all to Yes and No by using case statement --

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
FROM portfolio.dbo.nashville GROUP BY SoldAsVacant ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM portfolio.dbo.nashville;

UPDATE portfolio.dbo.nashville SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;

-- Remove Duplicates --
--  CTE --> partation by on column on which I want to check duplicates as "row_num"--> Delete it if record having > 1 in row_num column --

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM portfolio.dbo.nashville
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1

Select * FROM portfolio.dbo.nashville

-- delete unused columns --
ALTER TABLE portfolio.dbo.nashville DROP COLUMN SaleDate, PropertyAddress, OwnerAddress, TaxDistrict;


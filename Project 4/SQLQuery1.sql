SELECT * FROM portfolio.dbo.nashville;

-- I dont need time in my SaleDate column, so i will update it

SELECT SaleDate, CONVERT(Date,SaleDate) as UpdatedSaleDate From portfolio.dbo.nashville;

UPDATE portfolio.dbo.nashville SET SaleDate = CONVERT(Date,SaleDate); -- if this did't work --

ALTER TABLE portfolio.dbo.nashville ADD UpdatedSaleDate Date; -- add new column to the table --
UPDATE portfolio.dbo.nashville SET UpdatedSaleDate = CONVERT(Date,SaleDate); -- this will add new column at the end --

--handle null values in propertyadderess and populate them if needed --

SELECT COUNT(DISTINCT(ParcelId)) FROM portfolio.dbo.nashville; -- around 48K out of 56K are unique parcelID, others are same customers, so address will also be 48K --

SELECT ParcelID, PropertyAddress FROM portfolio.dbo.nashville WHERE PropertyAddress IS NULL;  -- only 29 null --

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(b.PropertyAddress, a.PropertyAddress) FROM portfolio.dbo.nashville a JOIN portfolio.dbo.nashville b 
ON a.ParcelID = b.ParcelID and a.[UniqueID ] != b.[UniqueID ]  
WHERE b.PropertyAddress IS NULL;

UPDATE b SET PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress) FROM portfolio.dbo.nashville a JOIN portfolio.dbo.nashville b 
ON a.ParcelID = b.ParcelID and a.[UniqueID ] != b.[UniqueID ]  
WHERE b.PropertyAddress IS NULL;

SELECT PropertyAddress FROM portfolio.dbo.nashville; -- No null values --

-- breakdown the address intp address, state and city by "," delimeter --

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

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) FROM portfolio.dbo.nashville GROUP BY SoldAsVacant ORDER BY 2;

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


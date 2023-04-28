/* Limpeza de Dados com SQL */

SELECT
	*
FROM
	PortfolioProjects..NashvilleHousing;



-- Padronizando formato de data

SELECT
	SaleDate,
	CONVERT(DATE, SaleDate)
FROM
	PortfolioProjects..NashvilleHousing;


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	SaleDateConverted DATE;


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	SaleDateConverted = CONVERT(DATE, SaleDate);



-- Populando Valores nulos em PropertyAddress

SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
	PortfolioProjects..NashvilleHousing a
JOIN
	PortfolioProjects..NashvilleHousing b
	ON
		a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;


UPDATE a
SET
	PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
	PortfolioProjects..NashvilleHousing a
JOIN
	PortfolioProjects..NashvilleHousing b
	ON
		a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress IS NULL;



-- Separando o endereço em colunas individuais

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM
	PortfolioProjects..NashvilleHousing;


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	PropertySplitAddress Nvarchar(255);


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	PropertySplitCity Nvarchar(255);


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));


SELECT
	*
FROM
	PortfolioProjects..NashvilleHousing;


SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
	PortfolioProjects..NashvilleHousing;


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	OwnerSplitAddress Nvarchar(255);


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	OwnerSplitCity Nvarchar(255);


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


ALTER TABLE
	PortfolioProjects..NashvilleHousing
ADD
	OwnerSplitState Nvarchar(255);


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


SELECT
	*
FROM
	PortfolioProjects..NashvilleHousing;



-- Alterando Y e N para Yes e No em "Sold as Vacant"

SELECT
	DISTINCT(SoldasVacant),
	COUNT(SoldasVacant)
FROM
	PortfolioProjects..NashvilleHousing
GROUP BY
	SoldAsVacant
ORDER BY
	2;


SELECT
	SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM
	PortfolioProjects..NashvilleHousing;


UPDATE
	PortfolioProjects..NashvilleHousing
SET
	SoldAsVacant =
		CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END;



-- Removendo linhas duplicadas

WITH RowNumCTE AS(
	SELECT
		*,
		ROW_NUMBER()
			OVER(
				PARTITION BY
					ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY
						UniqueID) row_num
FROM
	PortfolioProjects..NashvilleHousing
)
DELETE
FROM
	RowNumCTE
WHERE
	row_num > 1;


SELECT
	*
FROM
	PortfolioProjects..NashvilleHousing;
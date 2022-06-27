--Standarize date format
Select SaleDateConverted
From NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(DATE, SaleDate)

Alter Table NashvilleHousing
Drop COLUMN SaleDateConverted;

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(DATE, SaleDate)



-- Populate Property Address
Select PropertyAddress
From NashvilleHousing
Where PropertyAddress is null

Select a. ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a 
Join NashvilleHousing as b 
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a 
Join NashvilleHousing as b 
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

--Breaking out Address into Individual Columns
Select PropertyAddress
From NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From NashvilleHousing

Update NashvilleHousing
Set PropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add City Nvarchar(255);

Update NashvilleHousing
Set City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select PropertyAddress, City
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

Update NashvilleHousing
Set OwnerAddress = Parsename (REPLACE(OwnerAddress, ',', '.'),3) 

Alter Table NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
Set OwnerCity = Parsename (REPLACE(OwnerAddress, ',', '.'),2)


Alter Table NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
Set OwnerState = Parsename (REPLACE(OwnerAddress, ',', '.'),1)

-- Change Y and N to Yes and No

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

--Remove Duplicates 
WITH RowNumCTE as(
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
From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1

--Delete Unused Columns
Select *
From NashvilleHousing

Alter Table NashivilleHousing
Drop Column TaxDisctrict, SaleDate
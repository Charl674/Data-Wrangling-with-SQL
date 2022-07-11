/*

Cleaning Data in SQL Queries

*/

select * 
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------
--Standardize Date Format

select SaleDate, CONVERT(DATE,SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)

--Alter Table NashVilleHousing
--add SaleDateConverted Date;

--Update NashvilleHousing
--set SaleDateConverted = CONVERT(date, SaleDate)



-----Populate Property Address data

select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress IS null 
ORDER BY ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN  PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null



update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN  PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------
--Breaking addreesses into columns (address, city, state)


select PropertyAddress
from PortfolioProject..NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1, Charindex (',', PropertyAddress)-1 ) as Address,
SUBSTRING(PropertyAddress, Charindex (',', PropertyAddress)+1 , LEN(PropertyAddress))  as Address

from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------

--Now let us update the table, separating the city name from the address

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress =SUBSTRING(PropertyAddress, 1, Charindex (',', PropertyAddress)-1 )



Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity =SUBSTRING(PropertyAddress, Charindex (',', PropertyAddress)+1 , LEN(PropertyAddress))



select * from PortfolioProject..NashvilleHousing




---------------------------------------------------------
/*Another delimiter(which is my preferred separator) is;
Parsename(keyword) only identifies periods. In our cuurent situation, we have the OwnerAddressbeinmg separated by commas. 
So we have replace them by periods  */


select 
Parsename (REPLACE(OwnerAddress, ',','.'),3),
Parsename (REPLACE(OwnerAddress, ',','.'),2),
Parsename (REPLACE(OwnerAddress, ',','.'),1)
from PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerAddressSplit nvarchar(255);
Update NashvilleHousing
set OwnerAddressSplit = Parsename (REPLACE(OwnerAddress, ',','.'),3)



Alter Table NashvilleHousing
Add OwnerCitySplit nvarchar(255);
Update NashvilleHousing
set OwnerCitySplit = Parsename (REPLACE(OwnerAddress, ',','.'),2)


Alter Table NashvilleHousing
Add OwnerStateSplit nvarchar(255);
Update NashvilleHousing
set OwnerStateSplit = Parsename (REPLACE(OwnerAddress, ',','.'),1)



select *
from PortfolioProject..NashvilleHousing




-----------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

select SoldAsVacant,
Case when SoldAsVacant= 'Y' THEN 'Yes'
     when SoldAsVacant= 'N' THEN 'No'
	 else SoldAsVacant
	 End

from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant= Case when SoldAsVacant= 'Y' THEN 'Yes'
     when SoldAsVacant= 'N' THEN 'No'
	 else SoldAsVacant
	 End


---------------------------------------------------------------------------------------------
--Remove Duplicates





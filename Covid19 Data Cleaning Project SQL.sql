--cleaning data in sql queries

select*
from ProfolioProject.dbo.NashvilleHousing

--standardize data format

select SaleDateConverted,convert(date,SaleDate)
from ProfolioProject.dbo.NashvilleHousing
order by SaleDate

update NashvilleHousing
set SaleDate=convert(date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted=convert(date,SaleDate)

--populate property address date

select *
from ProfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
from ProfolioProject.dbo.NashvilleHousing a
join ProfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from ProfolioProject.dbo.NashvilleHousing a
join ProfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into induvisul colums(address,city,state)

select PropertyAddress
from ProfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) as address
,SUBSTRING(PropertyAddress, charindex(',',PropertyAddress)+1,len(PropertyAddress)) as address
from ProfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySpiltAddress nvarchar(255);

update NashvilleHousing
set PropertySpiltAddress=SUBSTRING(PropertyAddress,1, charindex(',',PropertyAddress)-1) 

Alter Table NashvilleHousing
Add PropertySpiltCity nvarchar(255);

update NashvilleHousing
set PropertySpiltCity=SUBSTRING(PropertyAddress, charindex(',',PropertyAddress)+1,len(PropertyAddress))


select*
from ProfolioProject.dbo.NashvilleHousing

select OwnerAddress
from ProfolioProject.dbo.NashvilleHousing

--change y and n to yes and no in 'sold as vacant' field

select distinct(SoldAsVacant),count(SoldAsVacant)
from ProfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant= 'Y'then 'Yes'
      when SoldAsVacant= 'no'then 'No'
	  else SoldAsVacant
	  end
	  from ProfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant= 'y'then 'yes'
      when SoldAsVacant= 'n'then 'no'
	  else SoldAsVacant
	  end
	  from ProfolioProject.dbo.NashvilleHousing


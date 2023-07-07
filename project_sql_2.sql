-- display the first 10 records of the table
select * from portfolio_project_2.nashville_housing limit 10;

-- standardize date format
select date_format(str_to_date(SaleDate,'%M %d, %Y'),'%d-%m-%Y') from portfolio_project_2.nashville_housing;
alter table portfolio_project_2.nashville_housing add SaleDate_Modified date;
update portfolio_project_2.nashville_housing set SaleDate_Modified=str_to_date(SaleDate,'%M %d, %Y');
select SaleDate_Modified from portfolio_project_2.nashville_housing;

-- Populate property address data( data set does not contain any null values for property address) 
select t1.ParcelID, t1.PropertyAddress,t2.ParcelID,t2.PropertyAddress,ifnull(t1.PropertyAddress,t2.PropertyAddress) from portfolio_project_2.nashville_housing t1 join portfolio_project_2.nashville_housing t2 on t1.ParcelID=t2.ParcelID and t1.UniqueID<>t2.UniqueID where t1.PropertyAddress is null;

-- split PropertyAddress into address,city
alter table portfolio_project_2.nashville_housing add propert_address varchar(25),add property_city varchar(25);
select substring(PropertyAddress,1,locate(',',PropertyAddress)-1) as address from portfolio_project_2.nashville_housing;
select substring(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress)) as city from portfolio_project_2.nashville_housing;
update portfolio_project_2.nashville_housing set propert_address= substring(PropertyAddress,1,locate(',',PropertyAddress)-1);
update portfolio_project_2.nashville_housing set property_city= substring(PropertyAddress,locate(',',PropertyAddress)+1,length(PropertyAddress));

alter table portfolio_project_2.nashville_housing modify propert_address varchar(100);
alter table portfolio_project_2.nashville_housing modify property_city varchar(100);
alter table portfolio_project_2.nashville_housing rename column propert_address to property_address;

-- split OwnerAddress into address,city,state
select substring(OwnerAddress,1,locate(',',OwnerAddress)-1) from portfolio_project_2.nashville_housing;
select substring(city_state,1,locate(',',city_state)-1) from t1;
select substring(city_state,locate(',',city_state)+1,length(city_state)) from t1;

alter table portfolio_project_2.nashville_housing add owner_address varchar(100),add owner_city varchar(100),add owner_state varchar(100);
update portfolio_project_2.nashville_housing set owner_address=substring(OwnerAddress,1,locate(',',OwnerAddress)-1);
update t1 set owner_city=substring(city_state,1,locate(',',city_state)-1);
update t1 set owner_state=substring(city_state,locate(',',city_state)+1,length(city_state));
select owner_city,owner_state from portfolio_project_2.nashville_housing;


-- change Y to Yes and N to No in SoaldAsVacant field
select SoldAsVacant,case when SoldAsVacant='Y' then 'Yes'
						 when SoldAsVacant='N' then 'No'
                         else SoldAsVacant
                         end
from portfolio_project_2.nashville_housing;

update portfolio_project_2.nashville_housing set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
						 when SoldAsVacant='N' then 'No'
                         else SoldAsVacant
                         end;

select SoldAsVacant from portfolio_project_2.nashville_housing;

-- to check if the dataset contains any duplicate records
select *,row_number() over(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference order by UniqueID) from portfolio_project_2.nashville_housing order by ParcelID;


-- remove unused columns
alter table portfolio_project_2.nashville_housing drop column OwnerAddress;
alter table portfolio_project_2.nashville_housing drop column TaxDistrict;
alter table portfolio_project_2.nashville_housing drop column PropertyAddress;

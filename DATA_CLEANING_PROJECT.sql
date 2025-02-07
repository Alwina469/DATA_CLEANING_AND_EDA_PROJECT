-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022



SELECT * 
FROM world_layoffs.layoffs;


-- first thing we want to do is create a staging table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens

create table layoff_staging
like layoffs;

insert layoff_staging
select * from layoffs;


-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways



-- A. Remove Duplicates
-- we can do this by different ways but we dont have any unique column here so we have to do it by differnt method

# First let's check for duplicates

select * from layoff_staging;

select * ,
      ROW_NUMBER() OVER(
      PARTITION BY country,location , industry , total_laid_off, percentage_laid_off, `date`, stage , country,funds_raised_millions) AS row_num
FROM layoff_staging;

# TO CHECK DUPLICATES , CHECK WHERE ROW_NUM > 1

WITH DUPLICATES_CTE AS (
select * ,
      ROW_NUMBER() OVER(
      PARTITION BY country,location , industry , total_laid_off, percentage_laid_off, `date`, stage , country,funds_raised_millions) AS row_num
FROM layoff_staging)
select * from DUPLICATES_CTE
where row_num>1;

-- these are the ones we want to delete where the row number is > 1 or 2or greater essentially

-- now you may want to write it like this:

WITH DUPLICATES_CTE AS (
select * ,
      ROW_NUMBER() OVER(
      PARTITION BY country,location , industry , total_laid_off, percentage_laid_off, `date`, stage , country,funds_raised_millions) AS row_num
FROM layoff_staging)
DELETE from DUPLICATES_CTE
where row_num>1;

-- it will not work 
-- one solution, which I think is a good one. Create a new table then add a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- to check whether row_num added or not

 select * from layoff_staging2;

 
 -- inserting values in table
 
 insert layoff_staging2
 select * ,
    row_number() over(partition by country,location , industry , total_laid_off, percentage_laid_off, `date`, stage , country,funds_raised_millions) AS row_num
FROM layoff_staging ;

-- now that we have this we can delete rows were row_num is greater than 1

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- this row_num at the end we will delete it





-- B. Standardizing Data ( finding issues in data and fixing it)

select * from layoff_staging2;

-- 1. FOR COMPANY COLUMN
-- check for distinct company

select distinct company
from layoff_staging2;

-- to remove white spaces from company column ( we can clearly see the differnece)

select  company , trim(company)
from layoff_staging2;

-- we need to update the company column
 update layoff_staging2
 set company=trim(company);


-- 2. FOR INDUSTRY COLUMN
-- check for distinct industry

select distinct industry 
from layoff_staging2
order by 1;

-- output shows crypto , crypto currency , cryptocurrency as different . we need to update it

update layoff_staging2
set industry="crypto"
where industry like "crypto%";

-- if we look at industry it looks like we have some null and empty rows, let's take a look at these
select * from layoff_staging2
where industry is null 
or industry='';
-- now we need to populate those nulls if possible

select * from layoff_staging2 as t1
join layoff_staging2 as t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry ='') and t2.industry is not null;

--

update layoff_staging2 as t1
join layoff_staging2 as t2
on t1.company=t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry ='') and t2.industry is not null;

-- this is not working . we need to make these blanks as null first 
update layoff_staging2
set industry=null
where industry='';

-- run this query to check is these changed to null or not 
select * from layoff_staging2 as t1
join layoff_staging2 as t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry ='') and t2.industry is not null;

-- it is changed 
-- now use this query to update industry column
update layoff_staging2 as t1
join layoff_staging2 as t2
on t1.company=t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry ='') and t2.industry is not null;

-- 3. FOR LOCATION COLUMN
-- check for distinct location

select distinct location 
from layoff_staging2;

-- 4. FOR COUNTRY COLUMN
-- check for distinct country

select distinct country
from layoff_staging2;


-- output shows united states , united states. , we meed to change it

update layoff_staging2
set country="united states"
where country like"united states%";

/* we can do this with another method as well
 update layoff_staging2
 set country=trim(trailing "." from country)
 where country like united states%;*/
 
 -- date column need to be checked (change format of date column , change datatype from text to date)
 
 -- 4. FOR DATE COLUMN
 
 select `date` from layoff_staging2;
 
 -- change format 
 
 select `date`, str_to_date(`date`,'%m/%d/%Y')
 from layoff_staging2;
 
 -- updating (changing format first)
 update layoff_staging2
 set `date`= str_to_date(`date`,'%m/%d/%Y');
 
-- this will not change the datatype of date , so we have to do one more step for it

alter table layoff_staging2
modify column `date` date;
-- datatype changed



-- C. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values




-- D. remove any columns and rows we need to

select * from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null ;

-- Delete Useless data we can't really use

delete from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

-- delete row_num column 

alter table layoff_staging2
drop column row_num;


-- 5. check all field list again 

select * from layoff_staging2;

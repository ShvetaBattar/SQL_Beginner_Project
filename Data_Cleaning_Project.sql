-- Data Cleaning

select * from layoffs ;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns 


-- create backup table 
create table layoffs_staging 
like layoffs ;

insert into layoffs_staging  
select * from layoffs ;

select * from layoffs_staging;

-- Assigning row_num bcoz don't have unique id
select *,
row_number()over(partition by company,location,industry, total_laid_off, percentage_laid_off,`date`,stage,country,
funds_raised_millions) as row_num
from layoffs_staging;


-- cte for duplicate but not delete directly from it in mysql server
with duplicate_cte as
(
select *,
row_number()over(partition by company,location,industry, total_laid_off, percentage_laid_off,`date`,stage,country,
funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;


-- create new table to delete duplicate records
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL ,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insert values in new table
insert into layoffs_staging2 
select *,
row_number()over(partition by company,location,industry, total_laid_off, percentage_laid_off,`date`,stage,country,
funds_raised_millions) as row_num
from layoffs_staging ;

-- check duplicates
select * from layoffs_staging2
where row_num > 1;

-- delete records
DELETE from layoffs_staging2
where row_num > 1;

 select * from layoffs_staging2 ;

-- Standardizing Data

select distinct(trim(company))
from layoffs_staging2 ;

update layoffs_staging2
set company = trim(company) ;

select distinct industry
from layoffs_staging2 
order by 1;

update layoffs_staging2 
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country ,trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%' ;


select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2 ;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y') ;

alter table layoffs_staging2
modify column `date` Date ;

-------------------------------------------------------
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null ;

select *
from layoffs_staging2
where industry is null
or industry = '';

update layoffs_staging2
set industry = null
where industry ='';

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2 ;

















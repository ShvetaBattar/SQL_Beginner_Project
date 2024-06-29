-- Explorartory Data Analysis

select * from layoffs_staging2;

-- Using max() function on 2 columns
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- Retrieve records where company's layoff was 100% and ordered by funds_raised_millions column
select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Retrieve records where company's layoff was 100% and ordered by funds_raised_millions column
select * from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Retrieve total people laid off by particular company
select company ,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- Retrieve total people laid off by particular industry
select industry ,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Give year from date column and total people laid off in particular year
select YEAR(`date`) ,sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`) 
order by 2 desc;

select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- Give minimum and maximum date
select min(`date`) , max(`date`)
from layoffs_staging2;

-- Give month wise total laid off people
select month(`date`)  as `month`, sum(total_laid_off)
from layoffs_staging2
where month(`date`) is not null
group by `month` 
order by 2 ;

-- Extract year & month from date column and total laid off people
select substring(`date`,1,7)  as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `month` 
order by 2  desc;

-- Using cte to get rolling total laid off 
with Rolling_total1 as
(
select substring(`date`,1,7)  as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `month` 
order by 2  desc
)
select `month`,total_off,
sum(total_off) over(partition  by `month`order by `month`) as rolling_total
from Rolling_total1;

-- cte which rolling total laid off  
with Rolling_total as
(
select substring(`date`,1,7)  as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `month` 
order by 2  desc
)
select `month`,total_off,
sum(total_off) over(order by `month`) as rolling_total
from Rolling_total;

select company ,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- cte to get top 5 ranking companies group by year wise
with company_year (Company,Years, Total_laid_off) as
(
select company ,YEAR(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,YEAR(`date`)
order by 3 desc
), Company_Year_Rank as
(
select *, 
dense_rank()over(partition by Years order by Total_laid_off desc) as ranking
 from company_year
 where Years is not null
 )
select * 
from Company_Year_Rank 
where ranking <= 5;















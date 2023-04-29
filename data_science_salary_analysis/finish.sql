create database ds;
-- APAKAH ADA DATA NULL?
select * from ds_salaries
where job_title is null;

-- MELIHAT JOB TITLE APA SAJA
select distinct job_title from ds_salaries;

-- JOB TITLE YANG BERKAITAN DENGAN DATA ANALYSIS
select distinct job_title from ds_salaries where job_title like ('%Data Analyst%');

-- BERAPA GAJI RATA-RATA DATA ANALYS
select avg(salary) from ds_salaries where job_title like ('%Data Analyst%');

-- BERAPA GAJI BERDASARKAN LEVEL EXPERIENCE
select experience_level, avg(salary) from ds_salaries 
where job_title like ('%Data Analyst%')
group by experience_level;

-- BERAPA GAJI BERDASARKAN LEVEL EXPERIENCE DAN EMPLOYEMENT TYPE
select job_title,employment_type, avg(salary) from ds_salaries 
where job_title like ('%Data Analyst%')
group by job_title, employment_type
order by job_title, employment_type asc;

-- NEGARA DENGAN GAJI YANG MENARIK DATA ANALYSIS, FULLTIME, EXPERIENT LEVEL
select employee_residence, avg(salary_in_usd) avg_salary from ds_salaries
where job_title like ('%Data Analyst%') and
employment_type = 'FT' and
experience_level in ('SE','ME')
group by employee_residence
having avg_salary > 80000
;

-- ditahun keberapa kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi
-- untuk pekerjaan yang berkaitan dengan data analys, employ_type penuh waktu 
with dc_1 as (
	select
		work_year,
        avg(salary_in_usd) as salary_se
	from
		ds_salaries
	where
		job_title like '%Data Analyst%' and
        employment_type = 'FT' and
        experience_level = 'SE'
	group by
		work_year
), dc_2 as (
	select 
		work_year,
        avg(salary_in_usd) as salary_mid
	from
		ds_salaries
	where
		job_title like '%Data Analyst%' and
        employment_type = 'FT' and
        experience_level = 'MI'
	group by 
		work_year
), t_year as (
	select
		distinct work_year
	from
		ds_salaries
)
select
	t_year.work_year,
    salary_se,
    salary_mid,
    salary_se - salary_mid range_salary
from
	t_year
left join dc_1 on dc_1.work_year = t_year.work_year
left join dc_2 on dc_2.work_year = t_year.work_year
;
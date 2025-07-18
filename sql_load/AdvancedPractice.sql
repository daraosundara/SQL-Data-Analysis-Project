SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM    
    job_postings_fact
LIMIT 10;


SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM    
    job_postings_fact
LIMIT 10;

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

CREATE TABLE april_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

CREATE TABLE may_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

CREATE TABLE june_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

CREATE TABLE july_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

CREATE TABLE august_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

CREATE TABLE september_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

CREATE TABLE october_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

CREATE TABLE november_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

CREATE TABLE december_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 12;

SELECT *
FROM march_jobs;

SELECT  
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

SELECT  
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY    
    location_category;

SELECT  
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY    
    location_category;

SELECT 
    company_id,
    name
FROM company_dim
WHERE company_id IN (
    SELECT  
    company_id
    FROM
    job_postings_fact
    WHERE 
    job_no_degree_mention = true
);

SELECT 
    job_title_short,
    job_location,
    salary_year_avg    
FROM
    august_jobs
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg >= 70000 AND
    job_location = 'Anywhere';

SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM
    august_jobs
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg >= 150000;

SELECT * FROM job_postings_fact
LIMIT 5;

SELECT  
    job_title_short,
    COUNT(job_title_short) AS number_of_jobs,
    AVG(salary_year_avg) AS salary_avg
FROM
    job_postings_fact
GROUP BY job_title_short
ORDER BY number_of_jobs DESC;

SELECT
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS job_type,
    salary_year_avg
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL;

SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS job_type,
    AVG(salary_year_avg) AS average_salary
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_type;

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM
    (SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
    ) AS quarter_one_jobs
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC 




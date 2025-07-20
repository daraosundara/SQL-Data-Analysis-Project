/* 
Questions to Answer
1. What are the top-paying jobs for my role (Data Analyst)?
2. What are the skills required for these top-paying roles?
3. What are the most in-demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal(High demand and High paying) skills to learn?
*/

/*
Question 1
- Identify the top 10 highest-paying Data Analyst role that are available remotely.
- Focus on job postings with specified salaries.
*/

SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;


/* 
Question 2
- Use query from question 1
- Add the specific skills for the roles.
*/

WITH top_paying_jobs AS (
    SELECT
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON  top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/*
Top 5 Skills Required for Top Paying Data Analyst Jobs
| Skill     | Frequency | 
| SQL       | 8         |
| Python    | 7         |
| Tableau   | 6         |
| R         | 4         |
| Snowflake | 3         |
*/

/*
Question 3
- Identify the top 5 in-demand skills for data analysts
- Focus on all job postings
*/

SELECT *
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
LIMIT 10


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

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY
    demand_count DESC  
LIMIT 5;

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    demand_count DESC  
LIMIT 5;

/*
Question 4
- Look at the average salary associateed with each skill for Data Analyst positions
- Focus on roles with specified salaries, regardless of location
*/

SELECT 
    skills,
    ROUND (AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND 
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    average_salary DESC
LIMIT 25;

/*
Focus on Advanced Technologies
Rising Demand for Machine Learning Frameworks
Data Management Proficiency
Infrastructure and DevOps Skills
Versatility in Programming Languages
*/

/*
Question 5
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
), average_salary AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND (AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND 
        job_work_from_home = TRUE
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY average_salary DESC,
         demand_count DESC
LIMIT 25;

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.skill_id) > 10
ORDER BY 
    average_salary DESC,
    demand_count DESC
LIMIT 25

          
    


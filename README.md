# Introduction
In today’s data-driven landscape, understanding the intricacies of the data analysis job market is vital for aspiring professionals. This project aims to uncover key insights into salary trends, highlight the top-paying skills, and identify the most sought-after skills based on current job market trends. By diving into the evolving demands of this dynamic field, this provides a roadmap for individuals looking to elevate their careers in data analysis. Join us as we explore the skills that not only command higher salaries but also position you for success in the ever-changing world of analytics!

SQL queries? Check them out here >>>
[data_analsyt_jobs](/SQL%20project/data_analyst_jobs.sql)
# Background
This is a personal project to showcase SQL skills and also to understand the demands of the dynamic data analysis field as a budding analyst staying up to date with industry trends.

Data was sourced from [Luke Barousse App for Data Nerds](/https://lukebarousse.com/sql)

### The questions I looked to answer with my SQL queries include: 
1. What were the high paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are the most in-demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to have?
# Tools Used For Analysis
I employed the following tools for myanalysis of the data job market
- SQL
- PostgreSQL
Visual Studio Code
- Github
- Git
# Analysis
In this analysis, the point of each query was to investigate specific aspects of the data analyst job market
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and by job postings that include a yearly salary average. This query highlights the high paying opportunities in the field.

```sql
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
```
Key Insights
- High Salaries for Leadership Roles
- Emerging Demand for Specialized Roles
- Geographic Diversity

![Top Paying Jobs](images\average_salaries_2023.png)
*Bar chart visualizing the top ten salaries for data analyst roles*

### 2. Top Skills Required for Top Paying Data Analyst Jobs
I joined the job postings data to the skills data to uncover what employers are looking for in high paying roles. I also filtered by job location focusing on remote roles.

```sql
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
    salary_year_avg DESC
```
**Key Insights**

Concentration Around Core Skills:
- Just 5 skills (SQL, Python, Tableau, R, Snowflake) make up 42% of all skill mentions.
- Learning these gives you access to most high-paying opportunities.

Specialization Exists:
- 10 skills appear in only one job posting, suggesting roles that require niche or specialized expertise.

![Top Skills](images\top_skills.jpg)
*This chart shows the skills that appeared most frequently in the top paying remote data analyst jobs*

### 3. In-demand Skills for Data Analyst Roles
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
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
LIMIT 5
```

|Skills  | Demand Count|
|--------|-------------|
|SQL     |7291         |
|Excel   |4611         |
|Python  |4330         |
|Tableau |3745         |
|Power BI|2609         |

**Key Insights**
- SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Top Skills for Data Analysts Based on Salary
This query examined average salary associated with each skill for Data Analyst positions. 

```sql
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
LIMIT 25
```

**Key Insights**
- Focus on Advanced Technologies: High salaries for specialized skills like SVN and Solidity 
indicate a strong demand for expertise in advanced technologies, particularly blockchain.

- Rising Demand for Machine Learning Frameworks: Tools like TensorFlow, PyTorch, and Keras
are critical, reflecting a growing need for skills in machine learning and AI development.

- Data Management Proficiency: Skills in NoSQL databases such as Cassandra and Couchbase are 
essential for effective data handling, emphasizing the importance of data management in analytics.

- Infrastructure and DevOps Skills: Cloud-related skills, notably with Terraform and VMware, highlight 
the trend of integrating cloud technologies and automation in data solutions.

- Versatility in Programming Languages: Familiarity with diverse programming languages, including 
Golang and Scala, is important for navigating various computational needs in data analysis and development.

|Skills   |Average Salary($)|
|---------|--------------|
|pyspark  |208172|
|bitbucket|189155|
|couchbase |160515|
|watson|160515|
|datarobot|155486|
|gitlab|154500|
|swift|153750|
|jupyter|152777|
|pandas|151821|
|elasticsearch|145000|
|golang|145000|
|numpy|143513|
|databricks|141907|
|linux|136508|
|kubernetes|132500|
*Average salary of the Top 15 paying skills*

### 5. High Demand AND High Paying Skills
Using insights from demand and salary data, this query aimed to identify skills that are most optimal to learn, offering a strategic focus for skill development.

```sql
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
```

|Skills|Demand Count|Average Salary|
|------|------------|--------------|
|go|27|115320
|confluence|11|114210
|hadoop|22|113193
|snowflake|37|112948
|azure|34|111225
|bigquery|13|109654
|aws|32|108317
|java|17|106906
|ssis|12|106683
|jira|20|104918
*Table of the top paying skills for data analyst roles, filtered by average salary.*





# What I learned

# Conclusion
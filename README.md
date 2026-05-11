COVID-19 Data Exploration with SQL
Project Overview

This project explores global COVID-19 data using SQL. The analysis focuses on infection rates, death rates, vaccination progress, and global trends by querying and transforming data from two datasets:

covid_deaths
covid_vaccinations

The project demonstrates SQL skills including:

Data filtering
Aggregations
Joins
Window functions
Common Table Expressions (CTEs)
Views
Data cleaning and transformation
Dataset Information
Tables Used
covid_deaths

Contains information about:

Total cases
New cases
Total deaths
Population
Country and continent information
Daily COVID statistics
covid_vaccinations

Contains vaccination-related data such as:

New vaccinations administered
Vaccination trends over time
Key SQL Concepts Used
1. Data Filtering

Used WHERE continent IS NOT NULL to remove summary rows where continents or income groups appeared under the location column.

Example:

WHERE continent IS NOT NULL
2. Basic Data Selection

Selected relevant columns for analysis:

SELECT location, date, population, total_cases, 
new_cases, total_deaths
FROM covid_deaths
Analysis Performed
Total Cases vs Total Deaths

Calculated the likelihood of death after contracting COVID-19.

(total_deaths/total_cases)*100 AS death_percentage
Insights
Helps measure the severity of COVID-19 in specific countries.
Example focused on the United States.
Total Cases vs Population

Calculated what percentage of the population contracted COVID-19.

(total_cases/population)*100 AS percent_population_infected
Insights
Shows spread of COVID relative to population size.
Countries with Highest Infection Rate

Identified countries with the highest infection percentages.

Techniques Used
GROUP BY
MAX()
Aggregation functions
Countries with Highest Death Count

Calculated total death counts by country.

MAX(CAST(total_deaths AS INTEGER)) AS total_death_count
Techniques Used
Data type conversion using CAST()
Aggregation
Continent-Level Analysis

Analyzed death counts by continent.

Important Observation

Some rows contained continent names in the location field when continent was NULL, which required additional filtering.

Global Numbers

Computed worldwide totals for:

Total cases
Total deaths
Global death percentage
SUM(new_cases) AS total_cases
SUM(CAST(new_deaths AS INTEGER)) AS total_deaths
Joining Tables

Performed a LEFT JOIN between deaths and vaccinations tables:

LEFT JOIN covid_vaccinations AS vac
ON dth.location = vac.location
AND dth.date = vac.date
Purpose

Combined infection and vaccination data for deeper analysis.

Vaccination Analysis
Rolling Vaccination Count

Used a window function to calculate cumulative vaccinations over time.

SUM(vac.new_vaccinations) 
OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
Concepts Used
Window Functions
Partitioning
Running totals
Common Table Expression (CTE)

Created a CTE to simplify vaccination analysis.

WITH popvsvac AS
Benefits
Improved readability
Easier calculations
Reusable query structure
Creating a View

Created a reusable SQL view for future visualizations.

CREATE VIEW percent_population_vaccinated AS
Purpose

Stores processed vaccination data for dashboards or reporting tools like:

Tableau
Power BI
Excel
Skills Demonstrated
SQL Querying
Data Cleaning
Data Aggregation
Window Functions
Joins
CTEs
Views
Analytical Thinking
Exploratory Data Analysis (EDA)
Possible Future Improvements
Add visualizations using Tableau or Power BI
Analyze vaccination effectiveness over time
Compare countries by vaccination rates
Add rolling averages for cases and deaths
Perform time-series trend analysis
Example Technologies Used
SQL
PostgreSQL / MySQL / SQL Server
COVID-19 Public Dataset
Author

Created as a portfolio project to practice SQL-based data analysis and exploratory data analysis techniques.

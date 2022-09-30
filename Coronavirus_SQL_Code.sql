SELECT *
FROM covid_deaths
--we will use "WHERE continent IS NOT NULL" because sometimes when the continent field is null, 
--it shows 'Africa' under the location field
WHERE continent IS NOT NULL;

--SELECT *
--FROM covid_vaccinations

--Select Data that we are going to be using

SELECT location, date, population, total_cases, 
new_cases, total_deaths
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

--Looking at the Total Cases vs Total Deaths
--Shows liklihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percentage
FROM covid_deaths
WHERE location LIKE '%States%'
AND continent IS NOT NULL
ORDER BY location, date;

--Looking at the Total Cases vs Population
--Shows what percentage of the population got covid

SELECT location, date, total_cases, population, 
(total_cases/population)*100 as percent_population_infected
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

--Looking at Countries with the Highest Infection Rate compared to the overall Population

SELECT location, population,
MAX(total_cases) as highest_infection_count, 
MAX((total_cases/population))*100 as percent_population_infected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_population_infected DESC;

--Showing Countries with Highest Death Count per Population
SELECT location, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

--Found that in some rows when continent is NULL, the location has the contient
SELECT *
FROM covid_deaths
WHERE continent IS NULL;

--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;
--Not accurate, because north america only includes deaths from the USA

SELECT location, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY total_death_count DESC;

--Showing continents with highest death count
SELECT continent, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

--Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as INTEGER)) AS total_deaths, 
SUM(CAST(new_deaths as INTEGER))/SUM(new_cases)*100 AS death_percentage
--total_deaths, ROUND((total_deaths/total_cases)*100,2) as death_percentage_rounded
FROM covid_deaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;

SELECT *
FROM covid_vaccinations;


--JOINING BOTH TABLES
SELECT *
FROM covid_deaths AS dth
LEFT JOIN covid_vaccinations AS vac
ON dth.location = vac.location
AND dth.date = vac.date;

--Looking at Total Population vs Vaccinations 

/* 
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
AS rolling_people_vaccinated
FROM covid_deaths AS dth
LEFT JOIN covid_vaccinations AS vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent IS NOT null
ORDER BY 2,3 
*/

--Using a CTE

WITH popvsvac (continent, location, date, population, new_vaccinations, rolling_ppl_vac)
AS 
(SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
AS rolling_people_vacc
FROM covid_deaths AS dth
LEFT JOIN covid_vaccinations AS vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent IS NOT null
--ORDER BY 2,3
)

SELECT *, ROUND((rolling_ppl_vac/population)*100,3)
FROM popvsvac


--TEMP TABLE


--Creating View to store data for later visualizations
CREATE VIEW percent_population_vaccinated AS
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
AS rolling_people_vacc
FROM covid_deaths AS dth
LEFT JOIN covid_vaccinations AS vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent IS NOT null;

SELECT *
FROM public.percent_population_vaccinated;
